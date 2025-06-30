part of 'delete_user_bloc.dart';

abstract class DeletePostState extends Equatable {
  const DeletePostState();
}

class DeletePostInitial extends DeletePostState {
  @override
  List<Object> get props => [];
}

class DeletePostLoading extends DeletePostState {
  @override
  List<Object> get props => [];
}

class DeletePostSuccess extends DeletePostState {
  @override
  List<Object> get props => [];
}

class DeletePostFailure extends DeletePostState {
  final String error;

  const DeletePostFailure(this.error);

  @override
  List<Object> get props => [error];
}
