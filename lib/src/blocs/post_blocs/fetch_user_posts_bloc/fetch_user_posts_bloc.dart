import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../repo/firebase_post_repository.dart';
import '../../../../core/models/post.dart';

part 'fetch_user_posts_event.dart';
part 'fetch_user_posts_state.dart';

class FetchUserPostsBloc extends Bloc<FetchUserPostsEvent, FetchUserPostsState> {
  final FirebasePostRepository postRepository;

  FetchUserPostsBloc({required this.postRepository}) : super(const FetchUserPostsState()) {
    on<LoadUserPosts>(_onLoadUserPosts);
  }

  Future<void> _onLoadUserPosts(LoadUserPosts event, Emitter<FetchUserPostsState> emit) async {
    emit(state.copyWith(status: UserPostsStatus.loading));
    try {
      final posts = await postRepository.getPostViaUid(event.userId);
      log('Posts: $posts');

      emit(state.copyWith(status: UserPostsStatus.success, posts: posts));
    } catch (e, s) {
      log('Error loading user posts: $e');
      log('Stacktrace: $s');
      emit(state.copyWith(status: UserPostsStatus.failure));
    }
  }
}
