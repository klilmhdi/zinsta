import 'package:equatable/equatable.dart';
import 'package:post_repository/post_repository.dart';
import 'package:user_repository/user_repository.dart';

abstract class LikesCommentsState {}

class LikesCommentsInitialState extends LikesCommentsState {}

class LikesLoadingState extends LikesCommentsState {
  // const LikesLoadingState({required super.post});
}

class LikesSuccessState extends LikesCommentsState {
  final Post post;
  final MyUser user;

  LikesSuccessState(this.post, this.user);
  // const LikesSuccessState({required super.post});
}

class LikesFailedState extends LikesCommentsState {
  LikesFailedState(String message);
  // const LikesFailedState({required super.post});
}

class CommentsLoadingState extends LikesCommentsState {
  // const CommentsLoadingState({required super.post});
}

class CommentsSuccessState extends LikesCommentsState {
  // const CommentsSuccessState({required super.post});
}

class CommentsFailedState extends LikesCommentsState {
  final String error;

  // const CommentsFailedState({required super.post, required this.error});
  CommentsFailedState({required this.error});
}
