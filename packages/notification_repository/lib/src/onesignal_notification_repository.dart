import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../notification_repository.dart';

//*<<<<<<<<<< completed 90% >>>>>>>>>>*//
/// Issues:
/// * The notification did not send to another user
class OneSignalNotificationRepository implements NotificationRepository {
  // TODO: استبدل هذه القيم بـ App ID و REST API Key الخاصين بك من OneSignal
  static const String _oneSignalAppId = 'dad71c80-52d8-4983-81b2-af2487b5bc52';
  static const String _oneSignalRestApiKey = 'incy6ynbcuhd56bx57g643plb';
  static const String _oneSignalUrl = 'https://onesignal.com/api/v1/notifications';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference _postsCollection = FirebaseFirestore.instance.collection('posts');

  /// Configure OneSignal
  @override
  Future<void> initializeOneSignal() async {
    // تم تغييرها إلى دالة غير ثابتة
    try {
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      OneSignal.initialize(_oneSignalAppId);

      // طلب إذن الإشعارات
      OneSignal.Notifications.requestPermission(true);
      FirebaseMessaging.instance.getToken().then((value) => debugPrint("-------- FCM token: $value"));

      log('OneSignal initialized successfully');
    } catch (e, s) {
      log('Error initializing OneSignal: $e');
      log('Stacktrace: $s');
    }
  }

  /// Update the user's OneSignal Player ID
  @override
  Future<void> updateUserOneSignalPlayerId(String userId) async {
    try {
      final playerId = OneSignal.User.pushSubscription.id;
      if (playerId != null && playerId.isNotEmpty) {
        await _usersCollection.doc(userId).update({'oneSignalPlayerId': playerId});
        log('Updated OneSignal Player ID for user: $userId');
      }
    } catch (e, s) {
      log('Error updating OneSignal Player ID: $e');
      log('Stacktrace: $s');
    }
  }

  /// Send global notification (Firebase + OneSignal)
  @override
  Future<void> sendNotification({
    required String senderId,
    required String receiverId,
    required String message,
    required NotificationTypeEnum type,
    String postId = '',
  }) async {
    try {
      // الحصول على بيانات المرسل والمستقبل
      final senderDoc = await _usersCollection.doc(senderId).get();
      final receiverDoc = await _usersCollection.doc(receiverId).get();

      if (!senderDoc.exists || !receiverDoc.exists) {
        log('Sender or receiver not found');
        return;
      }

      final senderData = senderDoc.data() as Map<String, dynamic>;
      final receiverData = receiverDoc.data() as Map<String, dynamic>;

      final senderName = senderData['name'] as String? ?? 'مستخدم';
      final senderPicture = senderData['picture'] as String? ?? '';
      final receiverPlayerId = receiverData['oneSignalPlayerId'] as String? ?? '';

      // إنشاء ID فريد للإشعار
      final notificationId = '${type}_${senderId}_${postId.isNotEmpty ? postId : ''}'.hashCode.toString();

      // تحديد محتوى الإشعار حسب النوع
      String notificationTitle = '';
      String notificationMessage = '';
      String postContent = '';

      // الحصول على محتوى البوست إذا كان موجوداً
      if (postId.isNotEmpty) {
        try {
          final postDoc = await _postsCollection.doc(postId).get();
          if (postDoc.exists) {
            final postData = postDoc.data() as Map<String, dynamic>;
            postContent = postData['post'] as String? ?? '';
            // تقصير النص إذا كان طويلاً
            if (postContent.length > 50) {
              postContent = '${postContent.substring(0, 50)}...';
            }
          }
        } catch (e) {
          log('Error fetching post content: $e');
        }
      }

      switch (type) {
        case NotificationTypeEnum.like:
          notificationTitle = 'New Like';
          notificationMessage = '$senderName likes your post';
          if (postContent.isNotEmpty) {
            notificationMessage += ': "$postContent"';
          }
          break;
        case NotificationTypeEnum.comment:
          notificationTitle = 'New Comment';
          notificationMessage = '$senderName comments on your post';
          if (postContent.isNotEmpty) {
            notificationMessage += ': "$postContent"';
          }
          break;
        case NotificationTypeEnum.follow:
          notificationTitle = 'New Following';
          notificationMessage = '$senderName started following you';
          break;
        case NotificationTypeEnum.followBack:
          notificationTitle = 'Following Back';
          notificationMessage = '$senderName response your following request';
          break;
        case NotificationTypeEnum.reShare:
          notificationTitle = 'Repost';
          notificationMessage = '$senderName re-share your post';
          if (postContent.isNotEmpty) {
            notificationMessage += ': "$postContent"';
          }
          break;
      }

      String postImageUrl = '';
      if (postId.isNotEmpty) {
        postImageUrl = await _getPostImageUrl(postId);
      }

      // إنشاء كائن الإشعار
      final notification = NotificationModel(
        id: notificationId,
        senderId: senderId,
        receiverId: receiverId,
        senderName: senderName,
        senderPicture: senderPicture,
        postId: postId,
        postContent: postContent,
        type: type,
        message: notificationMessage,
        postImageUrl: postImageUrl,
        createdAt: DateTime.now(),
        isRead: false,
      );

      // حفظ الإشعار في Firebase
      await _usersCollection
          .doc(receiverId)
          .collection('notifications')
          .doc(notificationId)
          .set(notification.toEntity().toDocument());

      // إرسال الإشعار عبر OneSignal إذا كان Player ID متوفراً
      if (receiverPlayerId.isNotEmpty) {
        await _sendOneSignalNotification(
          playerId: receiverPlayerId,
          title: notificationTitle,
          message: notificationMessage,
          data: {'type': type.toJson(), 'senderId': senderId, 'postId': postId, 'notificationId': notificationId},
        );
      }

      log('Notification sent successfully to $receiverId');
    } catch (e, s) {
      log('Error sending notification: $e');
      log('Stacktrace: $s');
      rethrow;
    }
  }

  /// Send like notification
  @override
  Future<void> sendLikeNotification({
    required String senderId,
    required String receiverId,
    required String postId,
  }) async {
    // تجنب إرسال إشعار للنفس
    if (senderId == receiverId) return;

    // Check for existing like notification for this post from this sender
    final existingNotifications =
        await _usersCollection
            .doc(receiverId)
            .collection('notifications')
            .where('senderId', isEqualTo: senderId)
            .where('postId', isEqualTo: postId)
            .where('type', isEqualTo: NotificationTypeEnum.like.toJson())
            .get();

    // If notification already exists, update its timestamp instead of creating new one
    if (existingNotifications.docs.isNotEmpty) {
      final existingId = existingNotifications.docs.first.id;
      await _usersCollection.doc(receiverId).collection('notifications').doc(existingId).update({
        'createdAt': DateTime.now(),
      });
      return;
    }

    // Otherwise, create new notification
    await sendNotification(
      senderId: senderId,
      receiverId: receiverId,
      message: 'Likes your post',
      type: NotificationTypeEnum.like,
      postId: postId,
    );
  }

  /// Send comment notification
  @override
  Future<void> sendCommentNotification({
    required String senderId,
    required String receiverId,
    required String postId,
    String commentText = '',
  }) async {
    // تجنب إرسال إشعار للنفس
    if (senderId == receiverId) return;

    String message = 'Comments on your post';
    if (commentText.isNotEmpty) {
      final shortComment = commentText.length > 30 ? '${commentText.substring(0, 30)}...' : commentText;
      message += ': "$shortComment"';
    }

    await sendNotification(
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      type: NotificationTypeEnum.comment,
      postId: postId,
    );
  }

  /// Send follow notification
  @override
  Future<void> sendFollowNotification({required String senderId, required String receiverId}) async {
    await sendNotification(
      senderId: senderId,
      receiverId: receiverId,
      message: 'Start following you',
      type: NotificationTypeEnum.follow,
    );
  }

  /// Send follow back notification
  @override
  Future<void> sendFollowBackNotification({required String senderId, required String receiverId}) async {
    await sendNotification(
      senderId: senderId,
      receiverId: receiverId,
      message: 'response your following request',
      type: NotificationTypeEnum.followBack,
    );
  }

  /// Send reshare notification
  @override
  Future<void> sendReShareNotification({
    required String senderId,
    required String receiverId,
    required String postId,
  }) async {
    // تجنب إرسال إشعار للنفس
    if (senderId == receiverId) return;

    await sendNotification(
      senderId: senderId,
      receiverId: receiverId,
      message: 're-share your post',
      type: NotificationTypeEnum.reShare,
      postId: postId,
    );
  }

  /// Get all notifications from FirebaseFireStore
  @override
  Stream<List<NotificationModel>> getUserNotifications(String userId) {
    try {
      return _usersCollection
          .doc(userId)
          .collection('notifications')
          .orderBy('createdAt', descending: true)
          .limit(50)
          .snapshots()
          .map(
            (snapshot) =>
                snapshot.docs
                    .map((doc) => NotificationModel.fromEntity(NotificationEntity.fromDocument(doc.data())))
                    .toList(),
          );
    } catch (e, s) {
      log('Error getting user notifications: $e');
      log('Stacktrace: $s');
      return Stream.value([]);
    }
  }

  /// Mark notification as read
  @override
  Future<void> markAsRead(String userId, String notificationId) async {
    try {
      await _usersCollection.doc(userId).collection('notifications').doc(notificationId).update({'isRead': true});

      log('Notification marked as read: $notificationId');
    } catch (e, s) {
      log('Error marking notification as read: $e');
      log('Stacktrace: $s');
      rethrow;
    }
  }

  /// Mark all notifications as read
  @override
  Future<void> markAllAsRead(String userId) async {
    try {
      final batch = _firestore.batch();
      final notifications =
          await _usersCollection.doc(userId).collection('notifications').where('isRead', isEqualTo: false).get();

      for (final doc in notifications.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();
      log('All notifications marked as read for user: $userId');
    } catch (e, s) {
      log('Error marking all notifications as read: $e');
      log('Stacktrace: $s');
      rethrow;
    }
  }

  /// Delete notification
  @override
  Future<void> deleteNotification(String userId, String notificationId) async {
    try {
      await _usersCollection.doc(userId).collection('notifications').doc(notificationId).delete();

      log('Notification deleted: $notificationId');
    } catch (e, s) {
      log('Error deleting notification: $e');
      log('Stacktrace: $s');
      rethrow;
    }
  }

  /// Delete All notifications
  @override
  Future<void> deleteAllNotifications(String userId) async {
    try {
      final batch = _firestore.batch();
      final notifications = await _usersCollection.doc(userId).collection('notifications').get();

      for (final doc in notifications.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      log('All notifications deleted for user: $userId');
    } catch (e, s) {
      log('Error deleting all notifications: $e');
      log('Stacktrace: $s');
      rethrow;
    }
  }

  /// Get the number of unread notifications
  @override
  Future<int> getUnreadNotificationsCount(String userId) async {
    try {
      final snapshot =
          await _usersCollection.doc(userId).collection('notifications').where('isRead', isEqualTo: false).get();

      return snapshot.docs.length;
    } catch (e, s) {
      log('Error getting unread notifications count: $e');
      log('Stacktrace: $s');
      return 0;
    }
  }

  /// Get the number of unread notifications
  @override
  Stream<int> getUnreadNotificationsCountStream(String userId) {
    try {
      return _usersCollection
          .doc(userId)
          .collection('notifications')
          .where('isRead', isEqualTo: false)
          .snapshots()
          .map((snapshot) => snapshot.docs.length);
    } catch (e, s) {
      log('Error getting unread notifications count stream: $e');
      log('Stacktrace: $s');
      return Stream.value(0);
    }
  }

  /// Clean up old notifications (more than 30 days old)
  @override
  Future<void> cleanupOldNotifications(String userId) async {
    try {
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      final batch = _firestore.batch();

      final oldNotifications =
          await _usersCollection
              .doc(userId)
              .collection('notifications')
              .where('createdAt', isLessThan: thirtyDaysAgo)
              .get();

      for (final doc in oldNotifications.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      log('Old notifications cleaned up for user: $userId');
    } catch (e, s) {
      log('Error cleaning up old notifications: $e');
      log('Stacktrace: $s');
    }
  }

  //* Private functions *//
  /// Send notification via OneSignal
  Future<void> _sendOneSignalNotification({
    required String playerId,
    required String title,
    required String message,
    Map<String, dynamic>? data,
  }) async {
    try {
      final headers = {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Basic $_oneSignalRestApiKey',
      };

      final body = {
        'app_id': _oneSignalAppId,
        'include_player_ids': [playerId],
        'headings': {'en': title, 'ar': title},
        'contents': {'en': message, 'ar': message},
        'data': data ?? {},
        'android_channel_id': 'social_notifications',
        'priority': 10,
        'ttl': 86400,
      };

      final response = await http.post(Uri.parse(_oneSignalUrl), headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        log('OneSignal notification sent successfully');
      } else {
        log('Failed to send OneSignal notification: ${response.body}');
      }
    } catch (e, s) {
      log('Error sending OneSignal notification: $e');
      log('Stacktrace: $s');
    }
  }

  /// Get post of image depend on PostID from FirebaseFirestore
  Future<String> _getPostImageUrl(String postId) async {
    try {
      final doc = await _postsCollection.doc(postId).get();

      if (doc.exists) {
        final postData = doc.data() as Map<String, dynamic>;
        return postData['postPicture'] ?? '';
      }
      return '';
    } catch (e) {
      log('Error getting post image: $e');
      return '';
    }
  }
}
