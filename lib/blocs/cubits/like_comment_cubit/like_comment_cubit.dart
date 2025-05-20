import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:zinsta/blocs/cubits/like_comment_cubit/like_comment_state.dart';

class LikesCommentsCubit extends Cubit<LikesCommentsState> {
  final FirebasePostRepository repository;

  LikesCommentsCubit(this.repository) : super(LikesCommentsInitialState());

  static LikesCommentsCubit get(context) => BlocProvider.of(context, listen: false);

  // Future<void> toggleLike(Post post, MyUser user) async {
  //   await repository.toggleLike(post, user);
  //   emit(LikesSuccessState(post, user));
  // }

  Future<void> toggleLike(Post post, MyUser user) async {
    try {
      final isLiked = post.likes.any((u) => u.id == user.id);

      await repository.toggleLike(post, user);

      if (isLiked) {
        post.likes.removeWhere((u) => u.id == user.id);
      } else {
        post.likes.add(user);
      }

      emit(LikesSuccessState(post, user));
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(LikesFailedState(e.toString()));
    }
  }

  Future<void> addComment({
    required Post post,
    required MyUser author,
    required String text,
  }) async {
    emit(CommentsLoadingState());

    final comment = Comment(
      id: UniqueKey().toString(),
      author: author,
      text: text,
      authorId: author.id,
      postId: post.postId,
      createdAt: DateTime.now(),
    );

    try {
      await repository.addComment(post, comment);

      post.comments.add(comment);

      emit(CommentsSuccessState());
    } catch (e) {
      print("[log] Error adding comment: $e");
      emit(CommentsFailedState(error: e.toString()));
    }
  }

  // Future<void> addComment({
  //   required Post post,
  //   required MyUser author,
  //   required String text,
  // }) async {
  //   emit(CommentsLoadingState());
  //
  //   final comment = Comment(
  //     id: UniqueKey().toString(),
  //     author: author,
  //     text: text,
  //     authorId: author.id,
  //     postId: post.postId,
  //     createdAt: DateTime.now(),
  //   );
  //
  //   try {
  //     await repository.addComment(post, comment);
  //     emit(CommentsSuccessState());
  //   } catch (e) {
  //     emit(CommentsFailedState(error: e.toString()));
  //   }
  // }
}
