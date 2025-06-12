import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:zinsta/blocs/post_blocs/like_comment_cubit/like_comment_state.dart';
import 'package:zinsta/components/consts/shared_perferenced.dart';

import '../../notification_blocs/notificaiton_bloc.dart';

class LikesCommentsCubit extends Cubit<LikesCommentsState> {
  final FirebasePostRepository repository;

  LikesCommentsCubit(this.repository) : super(LikesCommentsInitialState());

  static LikesCommentsCubit get(context) => BlocProvider.of(context, listen: false);

  // Future<void> toggleLike(BuildContext context, {required Post post, required MyUser currentUser}) async {
  //   try {
  //     final isLiked = post.likes.any((u) => u.id == currentUser.id);
  //     await repository.toggleLike(post, currentUser);
  //
  //     final newCount = isLiked ? post.likes.length - 1 : post.likes.length + 1;
  //     await SharedPrefController().setPostLikesCount(post.postId, newCount);
  //
  //     if (!isLiked) {
  //       context.read<NotificationBloc>().add(
  //         SendLikeNotification(
  //           senderId: currentUser.id,
  //           receiverId: post.myUser.id,
  //           postId: post.postId,
  //         ),
  //       );
  //     }
  //
  //     if (isLiked) {
  //       post.likes.removeWhere((u) => u.id == currentUser.id);
  //     } else {
  //       post.likes.add(currentUser);
  //     }
  //
  //     emit(LikesSuccessState(post, currentUser));
  //   } catch (e, s) {
  //     log(e.toString());
  //     log(s.toString());
  //     emit(LikesFailedState(e.toString()));
  //   }
  // }
  Future<void> toggleLike(BuildContext context, {required Post post, required MyUser currentUser}) async {
    emit(LikesLoadingState());

    try {
      final isLiked = post.likes.any((u) => u.id == currentUser.id);

      // Optimistic update
      final updatedLikes =
          isLiked ? post.likes.where((u) => u.id != currentUser.id).toList() : [...post.likes, currentUser];

      final updatedPost = post.copyWith(likes: updatedLikes);
      final newCount = updatedLikes.length;

      // Update local cache immediately
      await SharedPrefController().setPostLikesCount(post.postId, newCount);

      // Emit success state with optimistic update
      emit(LikesSuccessState(updatedPost, currentUser));

      // Perform the actual Firestore update
      await repository.toggleLike(post, currentUser);

      if (!isLiked) {
        context.read<NotificationBloc>().add(
          SendLikeNotification(senderId: currentUser.id, receiverId: post.myUser.id, postId: post.postId),
        );
      }
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(LikesFailedState(e.toString()));
    }
  }

  Future<void> addComment(
    BuildContext context, {
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
      final newCount = post.comments.length + 1;
      await SharedPrefController().setPostCommentsCount(post.postId, newCount);
      context.read<NotificationBloc>().add(
        SendCommentNotification(
          senderId: author.id,
          receiverId: post.myUser.id,
          postId: post.postId,
          commentText: text,
        ),
      );
      emit(CommentsSuccessState());
    } catch (e) {
      print("[log] Error adding comment: $e");
      emit(CommentsFailedState(error: e.toString()));
    }
  }
}
