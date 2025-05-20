import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:post_repository/post_repository.dart';

part 'delete_user_event.dart';
part 'delete_user_state.dart';

class DeletePostBloc extends Bloc<DeletePostEvent, DeletePostState> {
  final PostRepository postRepository;

  DeletePostBloc({required this.postRepository}) : super(DeletePostInitial()) {
    on<SubmitDeletePost>((event, emit) async {
      emit(DeletePostLoading());
      try {
        await postRepository.deletePost(event.post);
        emit(DeletePostSuccess());
      } catch (e) {
        emit(DeletePostFailure(e.toString()));
      }
    });
  }
}