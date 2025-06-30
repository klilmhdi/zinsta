part of 'delete_user_bloc.dart';

abstract class DeletePostEvent extends Equatable {
  const DeletePostEvent();
}

class SubmitDeletePost extends DeletePostEvent {
  final Post post;
  const SubmitDeletePost(this.post);

  @override
  List<Object> get props => [post];
}
