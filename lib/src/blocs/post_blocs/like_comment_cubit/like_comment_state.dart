import '../../../../core/models/my_user.dart';
import '../../../../core/models/post.dart';

abstract class LikesCommentsState {}

class LikesCommentsInitialState extends LikesCommentsState {}

class LikesLoadingState extends LikesCommentsState {}

class LikesSuccessState extends LikesCommentsState {
  final Post post;
  final MyUser user;

  LikesSuccessState(this.post, this.user);
}

class LikesFailedState extends LikesCommentsState {
  LikesFailedState(String message);
}

class CommentsLoadingState extends LikesCommentsState {}

class CommentsSuccessState extends LikesCommentsState {}

class CommentsFailedState extends LikesCommentsState {
  final String error;

  CommentsFailedState({required this.error});
}
