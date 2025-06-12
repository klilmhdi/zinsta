import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:notification_repository/notification_repository.dart';
import 'package:post_repository/post_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:uuid/uuid.dart';

class FirebasePostRepository implements PostRepository {
  final postCollection = FirebaseFirestore.instance.collection('posts');
  final postPictureStorage = FirebaseStorage.instance.ref().child('post_images');
  final OneSignalNotificationRepository _notificationRepository;

  FirebasePostRepository({required OneSignalNotificationRepository notificationRepository})
    : _notificationRepository = notificationRepository;

  /// Create posts and upload it with Upload text, or picture, or both
  @override
  Future<Post> createPost(Post post) async {
    try {
      final String postId = const Uuid().v1();
      final DateTime now = DateTime.now();
      String imageUrl = '';

      if (post.postPicture.isNotEmpty) {
        final ref = postPictureStorage.child('$postId.jpg');
        final uploadTask = await ref.putFile(File(post.postPicture));
        imageUrl = await uploadTask.ref.getDownloadURL();
      }

      final newPost = post.copyWith(postId: postId, createAt: now, postPicture: imageUrl);

      await postCollection.doc(postId).set(newPost.toEntity().toDocument());

      await FirebaseFirestore.instance
          .collection('users')
          .doc(post.myUser.id)
          .collection('posts')
          .doc(postId)
          .set(newPost.toEntity().toDocument());

      return newPost;
    } catch (e, s) {
      log('Error creating post: $e');
      log('Error creating post: $s');
      rethrow;
    }
  }

  /// Get (Fetch) all posts from Posts collections
  @override
  Future<List<Post>> getPost() {
    try {
      return postCollection.get().then(
        (value) => value.docs.map((e) => Post.fromEntity(PostEntity.fromDocument(e.data()))).toList(),
      );
    } catch (e, s) {
      log('Error get posts: $e');
      log('Error get posts: $s');
      rethrow;
    }
  }

  /// Get (Fetch) posts depend on userId for profile screen
  @override
  Future<List<Post>> getPostViaUid(String userId) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('posts')
              .orderBy('createAt', descending: true)
              .get();

      return snapshot.docs.map((doc) => Post.fromEntity(PostEntity.fromDocument(doc.data()))).toList();
    } catch (e, s) {
      log('Error fetching user posts: $e');
      log('Stacktrace: $s');
      rethrow;
    }
  }

  @override
  Future<void> editPost(Post post) async {
    try {
      String imageUrl = post.postPicture;

      final isLocalImage = imageUrl.isNotEmpty && !imageUrl.startsWith('http');

      if (isLocalImage) {
        final file = File(imageUrl);
        final fileName = '${post.postId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

        final ref = FirebaseStorage.instance.ref().child('post_images').child(fileName);

        await ref.putFile(file);
        imageUrl = await ref.getDownloadURL();
      }

      final updatedPost = post.copyWith(isEdited: true, createAt: DateTime.now(), postPicture: imageUrl);

      final data = updatedPost.toEntity().toDocument();

      // تحديث البوست في المسارين
      await postCollection.doc(post.postId).update(data);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(post.myUser.id)
          .collection('posts')
          .doc(post.postId)
          .update(data);
    } catch (e, s) {
      log('Error editing post: $e');
      log('Stacktrace: $s');
      rethrow;
    }
  }

  @override
  Future<void> deletePost(Post post) async {
    try {
      await postCollection.doc(post.postId).delete();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(post.myUser.id)
          .collection('posts')
          .doc(post.postId)
          .delete();
    } catch (e, s) {
      log('Error deleting post: $e');
      log('Stacktrace: $s');
      rethrow;
    }
  }

  @override
  Future<int> toggleLike(Post post, MyUser user) async {
    try {
      final isLiked = post.likes.any((u) => u.id == user.id);
      final updatedLikes = isLiked ? post.likes.where((u) => u.id != user.id).toList() : [...post.likes, user];

      final updatedPost = post.copyWith(likes: updatedLikes);
      final data = updatedPost.toEntity().toDocument();

      // Use batch write for atomic updates
      final batch = FirebaseFirestore.instance.batch();

      // Update main posts collection
      batch.set(postCollection.doc(post.postId), data, SetOptions(merge: true));

      // Update user's posts subcollection
      final userPostRef = FirebaseFirestore.instance
          .collection('users')
          .doc(post.myUser.id)
          .collection('posts')
          .doc(post.postId);
      batch.set(userPostRef, data, SetOptions(merge: true));

      await batch.commit();

      if (!isLiked) {
        try {
          await _notificationRepository.sendLikeNotification(
            senderId: user.id,
            receiverId: post.myUser.id,
            postId: post.postId,
          );
        } catch (e) {
          log('Error sending like notification: $e');
        }
      }

      return updatedLikes.length; // Now valid since return type is Future<int>
    } catch (e, s) {
      log('Error toggling like: $e');
      log('Stacktrace: $s');
      rethrow;
    }
  }

  // @override
  // Future<void> toggleLike(Post post, MyUser user) async {
  //   try {
  //     final isLiked = post.likes.any((u) => u.id == user.id);
  //     final updatedLikes = isLiked ? post.likes.where((u) => u.id != user.id).toList() : [...post.likes, user];
  //
  //     final updatedPost = post.copyWith(likes: updatedLikes);
  //
  //     final data = updatedPost.toEntity().toDocument();
  //
  //     await postCollection.doc(post.postId).set(data, SetOptions(merge: true));
  //
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(post.myUser.id)
  //         .collection('posts')
  //         .doc(post.postId)
  //         .set(data, SetOptions(merge: true));
  //     if (!isLiked) {
  //       // إرسال الإشعار فقط عند الإعجاب (وليس عند إلغاء الإعجاب)
  //       try {
  //         await _notificationRepository.sendLikeNotification(
  //           senderId: user.id,
  //           receiverId: post.myUser.id,
  //           postId: post.postId,
  //         );
  //       } catch (e) {
  //         log('Error sending like notification: $e');
  //       }
  //     }
  //   } catch (e, s) {
  //     log('Error toggling like: $e');
  //     log('Stacktrace: $s');
  //     rethrow;
  //   }
  // }

  @override
  Future<void> addComment(Post post, Comment comment) async {
    try {
      final updatedComments = [...post.comments, comment];

      final updatedPost = post.copyWith(comments: updatedComments);

      final data = updatedPost.toEntity().toDocument();

      await postCollection.doc(post.postId).update(data);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(post.myUser.id)
          .collection('posts')
          .doc(post.postId)
          .update(data);

      try {
        await _notificationRepository.sendCommentNotification(
          senderId: comment.author.id,
          receiverId: post.myUser.id,
          postId: post.postId,
          commentText: comment.text,
        );
      } catch (e) {
        log('Error sending comment notification: $e');
      }

      debugPrint("-------------- Success --------------");
    } catch (e, s) {
      log('Error adding comment: $e');
      log('Stacktrace: $s');
      rethrow;
    }
  }

  /// حذف التعليق
  @override
  Future<void> deleteComment(Post post, Comment comment) async {
    try {
      final updatedComments = post.comments.where((c) => c.id != comment.id).toList();
      final updatedPost = post.copyWith(comments: updatedComments);
      final data = updatedPost.toEntity().toDocument();

      await postCollection.doc(post.postId).update(data);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(post.myUser.id)
          .collection('posts')
          .doc(post.postId)
          .update(data);

      log('Comment deleted successfully');
    } catch (e, s) {
      log('Error deleting comment: $e');
      log('Stacktrace: $s');
      rethrow;
    }
  }

  /// تعديل التعليق
  @override
  Future<void> editComment(Post post, Comment updatedComment) async {
    try {
      final updatedComments =
          post.comments.map((c) {
            return c.id == updatedComment.id ? updatedComment : c;
          }).toList();

      final updatedPost = post.copyWith(comments: updatedComments);
      final data = updatedPost.toEntity().toDocument();

      await postCollection.doc(post.postId).update(data);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(post.myUser.id)
          .collection('posts')
          .doc(post.postId)
          .update(data);

      log('Comment edited successfully');
    } catch (e, s) {
      log('Error editing comment: $e');
      log('Stacktrace: $s');
      rethrow;
    }
  }

  /// إعادة مشاركة البوست
  Future<void> reSharePost(Post originalPost, MyUser user) async {
    try {
      // إنشاء بوست جديد كإعادة مشاركة
      final reSharedPost = Post(
        postId: const Uuid().v1(),
        post: 'أعاد مشاركة منشور ${originalPost.myUser.name}',
        postPicture: originalPost.postPicture,
        myUser: user,
        likes: [],
        comments: [],
        createAt: DateTime.now(),
        isEdited: false,
        // originalPostId: originalPost.postId, // إضافة مرجع للبوست الأصلي
        // isReShare: true, // تحديد أن هذا إعادة مشاركة
      );

      await postCollection.doc(reSharedPost.postId).set(reSharedPost.toEntity().toDocument());

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .collection('posts')
          .doc(reSharedPost.postId)
          .set(reSharedPost.toEntity().toDocument());

      // إرسال إشعار إعادة المشاركة
      try {
        await _notificationRepository.sendReShareNotification(
          senderId: user.id,
          receiverId: originalPost.myUser.id,
          postId: originalPost.postId,
        );
      } catch (e) {
        log('Error sending reshare notification: $e');
      }

      log('Post reshared successfully');
    } catch (e, s) {
      log('Error resharing post: $e');
      log('Stacktrace: $s');
      rethrow;
    }
  }

  /// الحصول على البوستات المعاد مشاركتها
  Future<List<Post>> getReSharedPosts(String userId) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('posts')
              .where('isReShare', isEqualTo: true)
              .orderBy('createAt', descending: true)
              .get();

      return snapshot.docs.map((doc) => Post.fromEntity(PostEntity.fromDocument(doc.data()))).toList();
    } catch (e, s) {
      log('Error fetching reshared posts: $e');
      log('Stacktrace: $s');
      rethrow;
    }
  }
}
