import 'package:zinsta/core/models/comment.dart';
import 'package:zinsta/core/models/my_user.dart';
import 'package:zinsta/core/models/post.dart';

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

  /// Set like
  Future<void> toggleLike(Post post, MyUser user);

  /// Add comment
  Future<void> addComment(Post post, Comment comment);

  /// Edit (Update) the comment
  Future<void> editComment(Post post, Comment updatedComment);

  /// Delete (Remove) the comment
  Future<void> deleteComment(Post post, Comment comment);
}
