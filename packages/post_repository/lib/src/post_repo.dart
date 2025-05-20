import 'package:user_repository/user_repository.dart';

import 'models/models.dart';

abstract class PostRepository {
  /// Create post
  Future<Post> createPost(Post post);

  /// Get all posts
  Future<List<Post>> getPost();

  /// Get posts via UserId
  Future<List<Post>> getPostViaUid(String userId);

  /// Edit (Update) the post
  Future<void> editPost(Post post);

  /// Delete (Remove) the post
  Future<void> deletePost(Post post);

  Future<void> toggleLike(Post post, MyUser user);

  Future<void> addComment(Post post, Comment comment);
}
