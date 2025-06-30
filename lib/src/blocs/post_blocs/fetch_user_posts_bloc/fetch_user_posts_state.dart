part of 'fetch_user_posts_bloc.dart';

enum UserPostsStatus { initial, loading, success, failure }

class FetchUserPostsState extends Equatable {
  final UserPostsStatus status;
  final List<Post> posts;

  const FetchUserPostsState({this.status = UserPostsStatus.initial, this.posts = const []});

  FetchUserPostsState copyWith({UserPostsStatus? status, List<Post>? posts}) =>
      FetchUserPostsState(status: status ?? this.status, posts: posts ?? this.posts);

  @override
  List<Object> get props => [status, posts];
}
