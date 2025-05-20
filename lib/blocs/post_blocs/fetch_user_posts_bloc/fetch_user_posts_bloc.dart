import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:post_repository/post_repository.dart';

part 'fetch_user_posts_event.dart';
part 'fetch_user_posts_state.dart';

class FetchUserPostsBloc extends Bloc<FetchUserPostsEvent, FetchUserPostsState> {
  final FirebasePostRepository postRepository;

  FetchUserPostsBloc({required this.postRepository})
      : super(const FetchUserPostsState()) {
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

// import 'dart:developer';
//
// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:equatable/equatable.dart';
// import 'package:post_repository/chat_repository.dart';
//
// part 'fetch_user_posts_event.dart';
//
// part 'fetch_user_posts_state.dart';
//
// // FetchUserPostsBloc
// class FetchUserPostsBloc extends Bloc<FetchUserPostsEvent, FetchUserPostsState> {
//   final FirebaseFirestore _firestore;
//
//   FetchUserPostsBloc({FirebaseFirestore? firestore})
//     : _firestore = firestore ?? FirebaseFirestore.instance,
//       super(const FetchUserPostsState()) {
//     on<LoadUserPosts>(_onLoadUserPosts);
//   }
//
//   Future<void> _onLoadUserPosts(LoadUserPosts event, Emitter<FetchUserPostsState> emit) async {
//     emit(state.copyWith(status: UserPostsStatus.loading));
//     try {
//       final snapshot =
//           await _firestore.collection('users').doc(event.userId).collection('posts').get();
//
//       final posts =
//           snapshot.docs.map((doc) => Post.fromEntity(PostEntity.fromDocument(doc.data()))).toList();
//       log('Posts: $posts');
//
//       emit(state.copyWith(status: UserPostsStatus.success, posts: posts));
//     } catch (e, s) {
//       log('Error loading user posts: $e');
//       log('Error loading user posts: $s');
//       emit(state.copyWith(status: UserPostsStatus.failure));
//     }
//   }
// }
