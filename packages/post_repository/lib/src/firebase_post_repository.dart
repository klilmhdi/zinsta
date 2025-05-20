import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:post_repository/post_repository.dart';
import 'package:post_repository/src/models/post.dart';
import 'package:user_repository/user_repository.dart';
import 'package:uuid/uuid.dart';
import 'post_repo.dart';

class FirebasePostRepository implements PostRepository {
  final postCollection = FirebaseFirestore.instance.collection('posts');
  final postPictureStorage = FirebaseStorage.instance.ref().child('post_images');

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
        (value) =>
            value.docs.map((e) => Post.fromEntity(PostEntity.fromDocument(e.data()))).toList(),
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

      return snapshot.docs
          .map((doc) => Post.fromEntity(PostEntity.fromDocument(doc.data())))
          .toList();
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

      final updatedPost = post.copyWith(
        isEdited: true,
        createAt: DateTime.now(),
        postPicture: imageUrl,
      );

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

  Future<void> toggleLike(Post post, MyUser user) async {
    try {
      final isLiked = post.likes.any((u) => u.id == user.id);
      final updatedLikes =
          isLiked ? post.likes.where((u) => u.id != user.id).toList() : [...post.likes, user];

      final updatedPost = post.copyWith(likes: updatedLikes);

      final data = updatedPost.toEntity().toDocument();

      await postCollection.doc(post.postId).set(data, SetOptions(merge: true));

      await FirebaseFirestore.instance
          .collection('users')
          .doc(post.myUser.id)
          .collection('posts')
          .doc(post.postId)
          .set(data, SetOptions(merge: true));
    } catch (e, s) {
      log('Error toggling like: $e');
      log('Stacktrace: $s');
      rethrow;
    }
  }

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
      debugPrint("-------------- Success --------------");
    } catch (e, s) {
      log('Error adding comment: $e');
      log('Stacktrace: $s');
      rethrow;
    }
  }
}
