import 'package:equatable/equatable.dart';
import '../../../../core/models/post.dart';

abstract class EditPostEvent extends Equatable {
  const EditPostEvent();
}

class SubmitEditPost extends EditPostEvent {
  final Post post;

  const SubmitEditPost(this.post);

  @override
  List<Object> get props => [post];
}