import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zinsta/core/entities/my_user_entity.dart';
import 'comment_entity.dart';
import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String postId;
  final String post;
  final String postPicture;
  final DateTime createAt;
  final MyUserEntity myUser;
  final List<MyUserEntity> likes;
  final List<CommentEntity> comments;
  final bool isEdited;

  const PostEntity({
    required this.postId,
    required this.post,
    required this.createAt,
    required this.myUser,
    this.likes = const [],
    this.comments = const [],
    this.postPicture = '',
    this.isEdited = false,
  });

  Map<String, Object?> toDocument() => {
    'postId': postId,
    'post': post,
    'createAt': Timestamp.fromDate(createAt),
    'myUser': myUser.toDocument(),
    'likes': likes.map((u) => u.toDocument()).toList(),
    'comments': comments.map((u) => u.toDocument()).toList(),
    'postPicture': postPicture,
    'isEdited': isEdited,
  };

  static PostEntity fromDocument(Map<String, dynamic> doc) => PostEntity(
    postId: doc['postId'] as String? ?? '',
    post: doc['post'] as String? ?? '',
    isEdited: doc['isEdited'] as bool? ?? false,
    createAt: (doc['createAt'] as Timestamp?)?.toDate() ?? DateTime(1970),
    myUser: MyUserEntity.fromDocument(doc['myUser']),
    likes: (doc['likes'] as List<dynamic>? ?? []).map((e) => MyUserEntity.fromDocument(e)).toList(),
    comments:
        (doc['comments'] as List<dynamic>? ?? [])
            .map((e) => CommentEntity.fromDocument(e))
            .toList(),
    postPicture: doc['postPicture'] as String? ?? '',
  );

  @override
  List<Object?> get props => [
    postId,
    post,
    createAt,
    myUser,
    likes,
    comments,
    postPicture,
    isEdited,
  ];
}
