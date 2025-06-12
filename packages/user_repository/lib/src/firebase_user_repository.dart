import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:notification_repository/notification_repository.dart';
import 'package:user_repository/src/models/my_user.dart';

import 'entities/entities.dart';
import 'user_repo.dart';

class FirebaseUserRepository implements UserRepository {
  FirebaseUserRepository({FirebaseAuth? firebaseAuth, required OneSignalNotificationRepository notificationRepository})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _notificationRepository = notificationRepository;

  final FirebaseAuth _firebaseAuth;
  final OneSignalNotificationRepository _notificationRepository;
  final usersCollection = FirebaseFirestore.instance.collection('users');

  @override
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser;
      return user;
    });
  }

  /// Sign up function
  @override
  Future<MyUser> signUp(MyUser myUser, String password, String token) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(email: myUser.email, password: password);

      myUser = myUser.copyWith(id: user.user!.uid, token: token, lastSeen: DateTime.now());

      return myUser;
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      rethrow;
    }
  }

  /// Sign in function
  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      // تحديث OneSignal Player ID عند تسجيل الدخول
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        await _notificationRepository.updateUserOneSignalPlayerId(currentUser.uid);
      }
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      rethrow;
    }
  }

  /// Logout
  @override
  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      rethrow;
    }
  }

  /// Reset password function
  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      rethrow;
    }
  }

  /// Create user and upload the data to firebase
  @override
  Future<void> setUserData(MyUser user) async {
    try {
      await usersCollection.doc(user.id).set(user.toEntity().toDocument());

      // تحديث OneSignal Player ID عند إنشاء المستخدم
      await _notificationRepository.updateUserOneSignalPlayerId(user.id);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      rethrow;
    }
  }

  /// Get (Fetch) user data
  @override
  Future<MyUser> getMyUser(String myUserId) async {
    try {
      return usersCollection
          .doc(myUserId)
          .get()
          .then((value) => MyUser.fromEntity(MyUserEntity.fromDocument(value.data()!)));
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      rethrow;
    }
  }

  /// Edit user data & upload profile and background pictures
  @override
  Future<void> editUserData({
    required String userId,
    required MyUser user,
    String? profilePicturePath,
    String? backgroundPicturePath,
  }) async {
    try {
      Map<String, dynamic> updatedData = user.toEntity().toDocument();

      if (profilePicturePath != null) {
        final profileRef = FirebaseStorage.instance.ref().child('$userId/PP/profile_pic');
        await profileRef.putFile(File(profilePicturePath));
        final profileUrl = await profileRef.getDownloadURL();
        updatedData['picture'] = profileUrl;
      }

      if (backgroundPicturePath != null) {
        final bgRef = FirebaseStorage.instance.ref().child('$userId/PP/background_pic');
        await bgRef.putFile(File(backgroundPicturePath));
        final bgUrl = await bgRef.getDownloadURL();
        updatedData['background'] = bgUrl;
      }

      await usersCollection.doc(userId).update(updatedData);

      final updatedMyUserData = user.toEntity().toDocument();

      final publicPostsSnapshot =
          await FirebaseFirestore.instance.collection('posts').where('myUser.id', isEqualTo: userId).get();

      for (final doc in publicPostsSnapshot.docs) {
        await doc.reference.update({'myUser': updatedMyUserData});
      }
      final privatePostsSnapshot = await usersCollection.doc(userId).collection('posts').get();

      for (final doc in privatePostsSnapshot.docs) {
        await doc.reference.update({'myUser': updatedMyUserData});
      }
    } catch (e, s) {
      log('Error updating user data: $e');
      log('Stacktrace: $s');
      rethrow;
    }
  }

  /// Search on profile via name
  @override
  Future<List<MyUser>> searchUserFromUsername(String query) async {
    if (query.trim().isEmpty) return [];

    final lowerQuery = query.trim().toLowerCase();

    final nameSnapshot =
        await usersCollection
            .where('name', isGreaterThanOrEqualTo: lowerQuery)
            .where('name', isLessThan: '${lowerQuery}z')
            .get();

    final usernameSnapshot =
        await usersCollection
            .where('username', isGreaterThanOrEqualTo: lowerQuery)
            .where('username', isLessThan: '${lowerQuery}z')
            .get();

    final allDocs = [...nameSnapshot.docs, ...usernameSnapshot.docs];

    final uniqueUsers = <String, MyUser>{};
    for (var doc in allDocs) {
      final data = doc.data();
      final user = MyUser.fromEntity(MyUserEntity.fromDocument(data));
      uniqueUsers[user.id] = user;
    }

    return uniqueUsers.values.toList();
  }

  /// Send follow for another user
  @override
  Future<void> followUser(String currentUserId, String targetUserId) async {
    final currentUserDoc = await usersCollection.doc(currentUserId).get();
    final targetUserDoc = await usersCollection.doc(targetUserId).get();

    final batch = FirebaseFirestore.instance.batch();
    batch.set(usersCollection.doc(currentUserId).collection('following').doc(targetUserId), {
      ...targetUserDoc.data()!,
      'timestamp': FieldValue.serverTimestamp(),
    });

    batch.set(usersCollection.doc(targetUserId).collection('followers').doc(currentUserId), {
      ...currentUserDoc.data()!,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await batch.commit();

    // إرسال إشعار المتابعة
    try {
      await _notificationRepository.sendFollowNotification(senderId: currentUserId, receiverId: targetUserId);

      // التحقق من وجود متابعة متبادلة وإرسال إشعار رد المتابعة
      final isFollowingBack = await isFollowing(targetUserId, currentUserId);
      if (isFollowingBack) {
        await _notificationRepository.sendFollowBackNotification(senderId: targetUserId, receiverId: currentUserId);
      }
    } catch (e) {
      log('Error sending follow notification: $e');
    }
  }

  /// Remove the follow from another user
  @override
  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    final currentUserRef = usersCollection.doc(currentUserId);
    final targetUserRef = usersCollection.doc(targetUserId);

    await Future.wait([
      currentUserRef.collection('following').doc(targetUserId).delete(),
      targetUserRef.collection('followers').doc(currentUserId).delete(),
    ]);
  }

  /// Check if I request a follow from another users
  @override
  Future<bool> isFollowing(String currentUserId, String targetUserId) async {
    final doc = await usersCollection.doc(currentUserId).collection('following').doc(targetUserId).get();
    return doc.exists;
  }

  /// Get (Fetch) followers count
  @override
  Future<int> getFollowersCount(String userId) async {
    final snapshot = await usersCollection.doc(userId).collection('followers').get();
    return snapshot.docs.length;
  }

  /// Get (Fetch) following count
  @override
  Future<int> getFollowingCount(String userId) async {
    final snapshot = await usersCollection.doc(userId).collection('following').get();
    return snapshot.docs.length;
  }

  /// Get followers
  @override
  Future<List<MyUser>> getFollowers(String userId) async {
    final snapshot = await usersCollection.doc(userId).collection('followers').get();

    List<MyUser> followers = [];

    for (var doc in snapshot.docs) {
      final userSnapshot = await usersCollection.doc(doc.id).get();
      if (userSnapshot.exists) {
        followers.add(MyUser.fromEntity(MyUserEntity.fromDocument(userSnapshot.data()!)));
      }
    }

    return followers;
  }

  /// Get followings
  @override
  Future<List<MyUser>> getFollowing(String userId) async {
    final snapshot = await usersCollection.doc(userId).collection('following').get();

    List<MyUser> following = [];

    for (var doc in snapshot.docs) {
      final userSnapshot = await usersCollection.doc(doc.id).get();
      if (userSnapshot.exists) {
        following.add(MyUser.fromEntity(MyUserEntity.fromDocument(userSnapshot.data()!)));
      }
    }

    return following;
  }

  /// تحديث OneSignal Player ID
  Future<void> updateOneSignalPlayerId(String userId, String playerId) async {
    try {
      await usersCollection.doc(userId).update({'oneSignalPlayerId': playerId});
      log('OneSignal Player ID updated for user: $userId');
    } catch (e, s) {
      log('Error updating OneSignal Player ID: $e');
      log('Stacktrace: $s');
      rethrow;
    }
  }

  /// تحديث حالة المستخدم (متصل/غير متصل)
  @override
  Future<void> updateUserOnlineStatus(String userId, bool isOnline) async {
    try {
      await usersCollection.doc(userId).update({'isOnline': isOnline, 'lastSeen': DateTime.now()});
    } catch (e, s) {
      log('Error updating user online status: $e');
      log('Stacktrace: $s');
    }
  }
}

// import 'dart:developer';
// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:notification_repository/notification_repository.dart';
// import 'package:user_repository/src/models/my_user.dart';
//
// import 'entities/entities.dart';
// import 'user_repo.dart';
//
// class FirebaseUserRepository implements UserRepository {
//   FirebaseUserRepository({
//     FirebaseAuth? firebaseAuth,
//     required OneSignalNotificationRepository notificationRepository, // تم تغييرها إلى required
//   }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
//        _notificationRepository = notificationRepository;
//
//   final FirebaseAuth _firebaseAuth;
//   final OneSignalNotificationRepository _notificationRepository; // تم تغييرها إلى غير nullable
//   final usersCollection = FirebaseFirestore.instance.collection('users');
//
//   @override
//   Stream<User?> get user {
//     return _firebaseAuth.authStateChanges().map((firebaseUser) {
//       final user = firebaseUser;
//       return user;
//     });
//   }
//
//   /// Sign up function
//   @override
//   Future<MyUser> signUp(MyUser myUser, String password, String token) async {
//     try {
//       UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(email: myUser.email, password: password);
//
//       myUser = myUser.copyWith(id: user.user!.uid, token: token, lastSeen: DateTime.now());
//
//       return myUser;
//     } catch (e, s) {
//       log(e.toString());
//       log(s.toString());
//       rethrow;
//     }
//   }
//
//   /// Sign in function
//   @override
//   Future<void> signIn(String email, String password) async {
//     try {
//       await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
//
//       // تحديث OneSignal Player ID عند تسجيل الدخول
//       final currentUser = _firebaseAuth.currentUser;
//       if (currentUser != null) {
//         await _notificationRepository.updateUserOneSignalPlayerId(currentUser.uid);
//       }
//     } catch (e, s) {
//       log(e.toString());
//       log(s.toString());
//       rethrow;
//     }
//   }
//
//   /// Logout
//   @override
//   Future<void> logOut() async {
//     try {
//       await _firebaseAuth.signOut();
//     } catch (e, s) {
//       log(e.toString());
//       log(s.toString());
//       rethrow;
//     }
//   }
//
//   /// Reset password function
//   @override
//   Future<void> resetPassword(String email) async {
//     try {
//       await _firebaseAuth.sendPasswordResetEmail(email: email);
//     } catch (e, s) {
//       log(e.toString());
//       log(s.toString());
//       rethrow;
//     }
//   }
//
//   /// Create user and upload the data to firebase
//   @override
//   Future<void> setUserData(MyUser user) async {
//     try {
//       await usersCollection.doc(user.id).set(user.toEntity().toDocument());
//
//       // تحديث OneSignal Player ID عند إنشاء المستخدم
//       await _notificationRepository.updateUserOneSignalPlayerId(user.id);
//     } catch (e, s) {
//       log(e.toString());
//       log(s.toString());
//       rethrow;
//     }
//   }
//
//   /// Get (Fetch) user data
//   @override
//   Future<MyUser> getMyUser(String myUserId) async {
//     try {
//       return usersCollection
//           .doc(myUserId)
//           .get()
//           .then((value) => MyUser.fromEntity(MyUserEntity.fromDocument(value.data()!)));
//     } catch (e, s) {
//       log(e.toString());
//       log(s.toString());
//       rethrow;
//     }
//   }
//
//   /// Edit user data & upload profile and background pictures
//   @override
//   Future<void> editUserData({
//     required String userId,
//     required MyUser user,
//     String? profilePicturePath,
//     String? backgroundPicturePath,
//   }) async {
//     try {
//       Map<String, dynamic> updatedData = user.toEntity().toDocument();
//
//       if (profilePicturePath != null) {
//         final profileRef = FirebaseStorage.instance.ref().child('$userId/PP/profile_pic');
//         await profileRef.putFile(File(profilePicturePath));
//         final profileUrl = await profileRef.getDownloadURL();
//         updatedData['picture'] = profileUrl;
//       }
//
//       if (backgroundPicturePath != null) {
//         final bgRef = FirebaseStorage.instance.ref().child('$userId/PP/background_pic');
//         await bgRef.putFile(File(backgroundPicturePath));
//         final bgUrl = await bgRef.getDownloadURL();
//         updatedData['background'] = bgUrl;
//       }
//
//       await usersCollection.doc(userId).update(updatedData);
//
//       final updatedMyUserData = user.toEntity().toDocument();
//
//       final publicPostsSnapshot =
//           await FirebaseFirestore.instance.collection('posts').where('myUser.id', isEqualTo: userId).get();
//
//       for (final doc in publicPostsSnapshot.docs) {
//         await doc.reference.update({'myUser': updatedMyUserData});
//       }
//       final privatePostsSnapshot = await usersCollection.doc(userId).collection('posts').get();
//
//       for (final doc in privatePostsSnapshot.docs) {
//         await doc.reference.update({'myUser': updatedMyUserData});
//       }
//     } catch (e, s) {
//       log('Error updating user data: $e');
//       log('Stacktrace: $s');
//       rethrow;
//     }
//   }
//
//   /// Search on profile via name
//   @override
//   Future<List<MyUser>> searchUserFromUsername(String query) async {
//     if (query.trim().isEmpty) return [];
//
//     final lowerQuery = query.trim().toLowerCase();
//
//     final nameSnapshot =
//         await usersCollection
//             .where('name', isGreaterThanOrEqualTo: lowerQuery)
//             .where('name', isLessThan: '${lowerQuery}z')
//             .get();
//
//     final usernameSnapshot =
//         await usersCollection
//             .where('username', isGreaterThanOrEqualTo: lowerQuery)
//             .where('username', isLessThan: '${lowerQuery}z')
//             .get();
//
//     final allDocs = [...nameSnapshot.docs, ...usernameSnapshot.docs];
//
//     final uniqueUsers = <String, MyUser>{};
//     for (var doc in allDocs) {
//       final data = doc.data();
//       final user = MyUser.fromEntity(MyUserEntity.fromDocument(data));
//       uniqueUsers[user.id] = user;
//     }
//
//     return uniqueUsers.values.toList();
//   }
//
//   /// Send follow for another user
//   @override
//   Future<void> followUser(String currentUserId, String targetUserId) async {
//     final currentUserDoc = await usersCollection.doc(currentUserId).get();
//     final targetUserDoc = await usersCollection.doc(targetUserId).get();
//
//     final batch = FirebaseFirestore.instance.batch();
//     batch.set(usersCollection.doc(currentUserId).collection('following').doc(targetUserId), {
//       ...targetUserDoc.data()!,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//
//     batch.set(usersCollection.doc(targetUserId).collection('followers').doc(currentUserId), {
//       ...currentUserDoc.data()!,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//
//     await batch.commit();
//
//     // إرسال إشعار المتابعة
//     try {
//       await _notificationRepository.sendFollowNotification(senderId: currentUserId, receiverId: targetUserId);
//
//       // التحقق من وجود متابعة متبادلة وإرسال إشعار رد المتابعة
//       final isFollowingBack = await isFollowing(targetUserId, currentUserId);
//       if (isFollowingBack) {
//         await _notificationRepository.sendFollowBackNotification(senderId: targetUserId, receiverId: currentUserId);
//       }
//     } catch (e) {
//       log('Error sending follow notification: $e');
//     }
//   }
//
//   /// Remove the follow from another user
//   @override
//   Future<void> unfollowUser(String currentUserId, String targetUserId) async {
//     final currentUserRef = usersCollection.doc(currentUserId);
//     final targetUserRef = usersCollection.doc(targetUserId);
//
//     await Future.wait([
//       currentUserRef.collection('following').doc(targetUserId).delete(),
//       targetUserRef.collection('followers').doc(currentUserId).delete(),
//     ]);
//   }
//
//   /// Check if I request a follow from another users
//   @override
//   Future<bool> isFollowing(String currentUserId, String targetUserId) async {
//     final doc = await usersCollection.doc(currentUserId).collection('following').doc(targetUserId).get();
//     return doc.exists;
//   }
//
//   /// Get (Fetch) followers count
//   @override
//   Future<int> getFollowersCount(String userId) async {
//     final snapshot = await usersCollection.doc(userId).collection('followers').get();
//     return snapshot.docs.length;
//   }
//
//   /// Get (Fetch) following count
//   @override
//   Future<int> getFollowingCount(String userId) async {
//     final snapshot = await usersCollection.doc(userId).collection('following').get();
//     return snapshot.docs.length;
//   }
//
//   /// Get followers
//   @override
//   Future<List<MyUser>> getFollowers(String userId) async {
//     final snapshot = await usersCollection.doc(userId).collection('followers').get();
//
//     List<MyUser> followers = [];
//
//     for (var doc in snapshot.docs) {
//       final userSnapshot = await usersCollection.doc(doc.id).get();
//       if (userSnapshot.exists) {
//         followers.add(MyUser.fromEntity(MyUserEntity.fromDocument(userSnapshot.data()!)));
//       }
//     }
//
//     return followers;
//   }
//
//   /// Get followings
//   @override
//   Future<List<MyUser>> getFollowing(String userId) async {
//     final snapshot = await usersCollection.doc(userId).collection('following').get();
//
//     List<MyUser> following = [];
//
//     for (var doc in snapshot.docs) {
//       final userSnapshot = await usersCollection.doc(doc.id).get();
//       if (userSnapshot.exists) {
//         following.add(MyUser.fromEntity(MyUserEntity.fromDocument(userSnapshot.data()!)));
//       }
//     }
//
//     return following;
//   }
//
//   /// تحديث OneSignal Player ID
//   Future<void> updateOneSignalPlayerId(String userId, String playerId) async {
//     try {
//       await usersCollection.doc(userId).update({'oneSignalPlayerId': playerId});
//       log('OneSignal Player ID updated for user: $userId');
//     } catch (e, s) {
//       log('Error updating OneSignal Player ID: $e');
//       log('Stacktrace: $s');
//       rethrow;
//     }
//   }
//
//   /// تحديث حالة المستخدم (متصل/غير متصل)
//   @override
//   Future<void> updateUserOnlineStatus(String userId, bool isOnline) async {
//     try {
//       await usersCollection.doc(userId).update({'isOnline': isOnline, 'lastSeen': DateTime.now()});
//     } catch (e, s) {
//       log('Error updating user online status: $e');
//       log('Stacktrace: $s');
//     }
//   }
// }

// class FirebaseUserRepository implements UserRepository {
//   FirebaseUserRepository({
//     FirebaseAuth? firebaseAuth,
//     required OneSignalNotificationRepository notificationRepository, // تم تغييرها إلى required
//   }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
//        _notificationRepository = notificationRepository;
//
//   final FirebaseAuth _firebaseAuth;
//   final OneSignalNotificationRepository _notificationRepository; // تم تغييرها إلى غير nullable
//   final usersCollection = FirebaseFirestore.instance.collection('users');
//
//   @override
//   Stream<User?> get user {
//     return _firebaseAuth.authStateChanges().map((firebaseUser) {
//       final user = firebaseUser;
//       return user;
//     });
//   }
//
//   /// Sign up function
//   @override
//   Future<MyUser> signUp(MyUser myUser, String password, String token) async {
//     try {
//       UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(email: myUser.email, password: password);
//
//       myUser = myUser.copyWith(id: user.user!.uid, token: token, lastSeen: DateTime.now());
//
//       return myUser;
//     } catch (e, s) {
//       log(e.toString());
//       log(s.toString());
//       rethrow;
//     }
//   }
//
//   /// Sign in function
//   @override
//   Future<void> signIn(String email, String password) async {
//     try {
//       await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
//
//       // تحديث OneSignal Player ID عند تسجيل الدخول
//       final currentUser = _firebaseAuth.currentUser;
//       if (currentUser != null) {
//         await _notificationRepository.updateUserOneSignalPlayerId(currentUser.uid);
//       }
//     } catch (e, s) {
//       log(e.toString());
//       log(s.toString());
//       rethrow;
//     }
//   }
//
//   /// Logout
//   @override
//   Future<void> logOut() async {
//     try {
//       await _firebaseAuth.signOut();
//     } catch (e, s) {
//       log(e.toString());
//       log(s.toString());
//       rethrow;
//     }
//   }
//
//   /// Reset password function
//   @override
//   Future<void> resetPassword(String email) async {
//     try {
//       await _firebaseAuth.sendPasswordResetEmail(email: email);
//     } catch (e, s) {
//       log(e.toString());
//       log(s.toString());
//       rethrow;
//     }
//   }
//
//   /// Create user and upload the data to firebase
//   @override
//   Future<void> setUserData(MyUser user) async {
//     try {
//       await usersCollection.doc(user.id).set(user.toEntity().toDocument());
//
//       // تحديث OneSignal Player ID عند إنشاء المستخدم
//       await _notificationRepository.updateUserOneSignalPlayerId(user.id);
//     } catch (e, s) {
//       log(e.toString());
//       log(s.toString());
//       rethrow;
//     }
//   }
//
//   /// Get (Fetch) user data
//   @override
//   Future<MyUser> getMyUser(String myUserId) async {
//     try {
//       return usersCollection
//           .doc(myUserId)
//           .get()
//           .then((value) => MyUser.fromEntity(MyUserEntity.fromDocument(value.data()!)));
//     } catch (e, s) {
//       log(e.toString());
//       log(s.toString());
//       rethrow;
//     }
//   }
//
//   /// Edit user data & upload profile and background pictures
//   @override
//   Future<void> editUserData({
//     required String userId,
//     required MyUser user,
//     String? profilePicturePath,
//     String? backgroundPicturePath,
//   }) async {
//     try {
//       Map<String, dynamic> updatedData = user.toEntity().toDocument();
//
//       if (profilePicturePath != null) {
//         final profileRef = FirebaseStorage.instance.ref().child('$userId/PP/profile_pic');
//         await profileRef.putFile(File(profilePicturePath));
//         final profileUrl = await profileRef.getDownloadURL();
//         updatedData['picture'] = profileUrl;
//       }
//
//       if (backgroundPicturePath != null) {
//         final bgRef = FirebaseStorage.instance.ref().child('$userId/PP/background_pic');
//         await bgRef.putFile(File(backgroundPicturePath));
//         final bgUrl = await bgRef.getDownloadURL();
//         updatedData['background'] = bgUrl;
//       }
//
//       await usersCollection.doc(userId).update(updatedData);
//
//       final updatedMyUserData = user.toEntity().toDocument();
//
//       final publicPostsSnapshot =
//           await FirebaseFirestore.instance.collection('posts').where('myUser.id', isEqualTo: userId).get();
//
//       for (final doc in publicPostsSnapshot.docs) {
//         await doc.reference.update({'myUser': updatedMyUserData});
//       }
//       final privatePostsSnapshot = await usersCollection.doc(userId).collection('posts').get();
//
//       for (final doc in privatePostsSnapshot.docs) {
//         await doc.reference.update({'myUser': updatedMyUserData});
//       }
//     } catch (e, s) {
//       log('Error updating user data: $e');
//       log('Stacktrace: $s');
//       rethrow;
//     }
//   }
//
//   /// Search on profile via name
//   @override
//   Future<List<MyUser>> searchUserFromUsername(String query) async {
//     if (query.trim().isEmpty) return [];
//
//     final lowerQuery = query.trim().toLowerCase();
//
//     final nameSnapshot =
//         await usersCollection
//             .where('name', isGreaterThanOrEqualTo: lowerQuery)
//             .where('name', isLessThan: '${lowerQuery}z')
//             .get();
//
//     final usernameSnapshot =
//         await usersCollection
//             .where('username', isGreaterThanOrEqualTo: lowerQuery)
//             .where('username', isLessThan: '${lowerQuery}z')
//             .get();
//
//     final allDocs = [...nameSnapshot.docs, ...usernameSnapshot.docs];
//
//     final uniqueUsers = <String, MyUser>{};
//     for (var doc in allDocs) {
//       final data = doc.data();
//       final user = MyUser.fromEntity(MyUserEntity.fromDocument(data));
//       uniqueUsers[user.id] = user;
//     }
//
//     return uniqueUsers.values.toList();
//   }
//
//   /// Send follow for another user
//   @override
//   Future<void> followUser(String currentUserId, String targetUserId) async {
//     final currentUserDoc = await usersCollection.doc(currentUserId).get();
//     final targetUserDoc = await usersCollection.doc(targetUserId).get();
//
//     final batch = FirebaseFirestore.instance.batch();
//     batch.set(usersCollection.doc(currentUserId).collection('following').doc(targetUserId), {
//       ...targetUserDoc.data()!,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//
//     batch.set(usersCollection.doc(targetUserId).collection('followers').doc(currentUserId), {
//       ...currentUserDoc.data()!,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//
//     await batch.commit();
//
//     // إرسال إشعار المتابعة
//     try {
//       await _notificationRepository.sendFollowNotification(senderId: currentUserId, receiverId: targetUserId);
//
//       // التحقق من وجود متابعة متبادلة وإرسال إشعار رد المتابعة
//       final isFollowingBack = await isFollowing(targetUserId, currentUserId);
//       if (isFollowingBack) {
//         await _notificationRepository.sendFollowBackNotification(senderId: targetUserId, receiverId: currentUserId);
//       }
//     } catch (e) {
//       log('Error sending follow notification: $e');
//     }
//   }
//
//   /// Remove the follow from another user
//   @override
//   Future<void> unfollowUser(String currentUserId, String targetUserId) async {
//     final currentUserRef = usersCollection.doc(currentUserId);
//     final targetUserRef = usersCollection.doc(targetUserId);
//
//     await Future.wait([
//       currentUserRef.collection('following').doc(targetUserId).delete(),
//       targetUserRef.collection('followers').doc(currentUserId).delete(),
//     ]);
//   }
//
//   /// Check if I request a follow from another users
//   @override
//   Future<bool> isFollowing(String currentUserId, String targetUserId) async {
//     final doc = await usersCollection.doc(currentUserId).collection('following').doc(targetUserId).get();
//     return doc.exists;
//   }
//
//   /// Get (Fetch) followers count
//   @override
//   Future<int> getFollowersCount(String userId) async {
//     final snapshot = await usersCollection.doc(userId).collection('followers').get();
//     return snapshot.docs.length;
//   }
//
//   /// Get (Fetch) following count
//   @override
//   Future<int> getFollowingCount(String userId) async {
//     final snapshot = await usersCollection.doc(userId).collection('following').get();
//     return snapshot.docs.length;
//   }
//
//   /// Get followers
//   @override
//   Future<List<MyUser>> getFollowers(String userId) async {
//     final snapshot = await usersCollection.doc(userId).collection('followers').get();
//
//     List<MyUser> followers = [];
//
//     for (var doc in snapshot.docs) {
//       final userSnapshot = await usersCollection.doc(doc.id).get();
//       if (userSnapshot.exists) {
//         followers.add(MyUser.fromEntity(MyUserEntity.fromDocument(userSnapshot.data()!)));
//       }
//     }
//
//     return followers;
//   }
//
//   /// Get followings
//   @override
//   Future<List<MyUser>> getFollowing(String userId) async {
//     final snapshot = await usersCollection.doc(userId).collection('following').get();
//
//     List<MyUser> following = [];
//
//     for (var doc in snapshot.docs) {
//       final userSnapshot = await usersCollection.doc(doc.id).get();
//       if (userSnapshot.exists) {
//         following.add(MyUser.fromEntity(MyUserEntity.fromDocument(userSnapshot.data()!)));
//       }
//     }
//
//     return following;
//   }
//
//   /// تحديث OneSignal Player ID
//   Future<void> updateOneSignalPlayerId(String userId, String playerId) async {
//     try {
//       await usersCollection.doc(userId).update({'oneSignalPlayerId': playerId});
//       log('OneSignal Player ID updated for user: $userId');
//     } catch (e, s) {
//       log('Error updating OneSignal Player ID: $e');
//       log('Stacktrace: $s');
//       rethrow;
//     }
//   }
//
//   /// تحديث حالة المستخدم (متصل/غير متصل)
//   @override
//   Future<void> updateUserOnlineStatus(String userId, bool isOnline) async {
//     try {
//       await usersCollection.doc(userId).update({'isOnline': isOnline, 'lastSeen': DateTime.now()});
//     } catch (e, s) {
//       log('Error updating user online status: $e');
//       log('Stacktrace: $s');
//     }
//   }
// }
