import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:post_repository/post_repository.dart';

import 'edit_post_event.dart';

part 'edit_post_state.dart';

class EditPostBloc extends Bloc<EditPostEvent, EditPostState> {
  final PostRepository postRepository;

  EditPostBloc({required this.postRepository}) : super(EditPostInitial()) {
    on<SubmitEditPost>((event, emit) async {
      emit(EditPostLoading());
      try {
        await postRepository.editPost(event.post);
        emit(EditPostSuccess());
      } catch (e) {
        emit(EditPostFailure(e.toString()));
      }
    });
  }
}
