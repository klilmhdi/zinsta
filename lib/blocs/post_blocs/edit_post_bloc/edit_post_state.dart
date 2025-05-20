part of 'edit_post_bloc.dart';

abstract class EditPostState extends Equatable {
  const EditPostState();
}

class EditPostInitial extends EditPostState {
  @override
  List<Object> get props => [];
}

class EditPostLoading extends EditPostState {
  @override
  List<Object> get props => [];
}

class EditPostSuccess extends EditPostState {
  @override
  List<Object> get props => [];
}

class EditPostFailure extends EditPostState {
  final String error;
  const EditPostFailure(this.error);

  @override
  List<Object> get props => [error];
}
