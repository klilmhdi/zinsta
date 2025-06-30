import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/models/post.dart';
import '../../../../core/repo/post_repo.dart';

part 'create_post_event.dart';

part 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  PostRepository _postRepository;

  CreatePostBloc({required PostRepository postRepository})
    : _postRepository = postRepository,
      super(CreatePostInitial()) {
    on<CreatePost>((event, emit) async {
      emit(CreatePostLoading());
      try {
        Post post = await _postRepository.createPost(event.post);
        emit(CreatePostSuccess(post));
      } catch (e, s) {
        debugPrint("-------------------------- ${e.toString()}");
        debugPrint("-------------------------- ${s.toString()}");
        emit(CreatePostFailure());
      }
    });
  }
}
