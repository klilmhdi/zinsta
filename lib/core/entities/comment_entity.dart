import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:zinsta/core/entities/my_user_entity.dart';

class CommentEntity extends Equatable {
  final String id;
  final String postId;
  final String authorId;
  final String text;
  final DateTime createdAt;
  final MyUserEntity author;

  const CommentEntity({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.text,
    required this.createdAt,
    required this.author,
  });

  Map<String, Object?> toDocument() => {
    'id': id,
    'postId': postId,
    'authorId': authorId,
    'text': text,
    'createdAt': createdAt,
    'author': author.toDocument(),
  };

  static CommentEntity fromDocument(Map<String, dynamic> doc) => CommentEntity(
    id: doc['id'] as String? ?? "",
    postId: doc['postId'] as String? ?? "",
    text: doc['text'] as String? ?? "",
    authorId: doc['authorId'] as String? ?? "",
    createdAt: (doc['createdAt'] as Timestamp?)?.toDate() ?? DateTime(1970),
    author: MyUserEntity.fromDocument(doc['author']),
  );

  @override
  List<Object?> get props => [id, postId, authorId, text, createdAt, author];
}
