import 'package:post_repository/post_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String id;
  final String postId;
  final String authorId;
  final String text;
  final DateTime createdAt;
  final MyUser author;

  const Comment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.text,
    required this.createdAt,
    required this.author,
  });

  static var empty = Comment(
    id: '',
    postId: '',
    authorId: '',
    text: '',
    createdAt: DateTime.now(),
    author: MyUser.empty,
  );

  Comment copyWith({
    String? id,
    String? postId,
    String? authorId,
    String? text,
    DateTime? createdAt,
    MyUser? author,
  }) => Comment(
    id: id ?? this.id,
    postId: postId ?? this.postId,
    authorId: authorId ?? this.authorId,
    text: text ?? this.text,
    createdAt: createdAt ?? this.createdAt,
    author: author ?? this.author,
  );

  bool get isEmpty => this == Comment.empty;

  bool get isNotEmpty => this != Comment.empty;

  CommentEntity toEntity() => CommentEntity(
    id: id,
    postId: postId,
    authorId: authorId,
    text: text,
    createdAt: createdAt,
    author: author.toEntity(),
  );

  static Comment fromEntity(CommentEntity entity) => Comment(
    id: entity.id,
    postId: entity.postId,
    authorId: entity.authorId,
    text: entity.text,
    createdAt: entity.createdAt,
    author: MyUser.fromEntity(entity.author),
  );

  @override
  List<Object?> get props => [id, postId, authorId, text, createdAt, author];
}
