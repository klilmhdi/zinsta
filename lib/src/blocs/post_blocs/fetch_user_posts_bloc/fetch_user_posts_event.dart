part of 'fetch_user_posts_bloc.dart';

abstract class FetchUserPostsEvent extends Equatable {
  const FetchUserPostsEvent();

  @override
  List<Object> get props => [];
}

class LoadUserPosts extends FetchUserPostsEvent {
  final String userId;

  const LoadUserPosts({required this.userId});

  @override
  List<Object> get props => [userId];
}
