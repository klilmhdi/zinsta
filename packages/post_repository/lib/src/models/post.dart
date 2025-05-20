import 'package:post_repository/post_repository.dart';
import 'package:user_repository/user_repository.dart';
import '../entities/entities.dart';

import 'package:equatable/equatable.dart';
import '../entities/post_entity.dart';

class Post extends Equatable {
  final String postId;
  final String post;
  final String postPicture;
  final DateTime createAt;
  final MyUser myUser;
  final List<MyUser> likes;
  final List<Comment> comments;
  final bool isEdited;

  const Post({
    required this.postId,
    required this.post,
    required this.createAt,
    required this.myUser,
    this.likes = const [],
    this.comments = const [],
    this.postPicture = '',
    this.isEdited = false
  });

  static var empty = Post(
    postId: '',
    post: '',
    createAt: DateTime.now(),
    myUser: MyUser.empty,
    likes: const [],
    comments: const [],
    postPicture: '',
    isEdited: false
  );

  Post copyWith({
    String? postId,
    String? post,
    DateTime? createAt,
    MyUser? myUser,
    List<MyUser>? likes,
    List<Comment>? comments,
    String? postPicture,
    bool? isEdited,
  }) {
    return Post(
      postId: postId ?? this.postId,
      post: post ?? this.post,
      createAt: createAt ?? this.createAt,
      myUser: myUser ?? this.myUser,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      postPicture: postPicture ?? this.postPicture,
      isEdited: isEdited ?? this.isEdited,
    );
  }

  bool get isEmpty => this == Post.empty;

  bool get isNotEmpty => this != Post.empty;

  PostEntity toEntity() => PostEntity(
    postId: postId,
    post: post,
    createAt: createAt,
    myUser: myUser.toEntity(),
    likes: likes.map((u) => u.toEntity()).toList(),
    comments: comments.map((u) => u.toEntity()).toList(),
    postPicture: postPicture,
    isEdited: isEdited,
  );

  static Post fromEntity(PostEntity entity) => Post(
    postId: entity.postId,
    post: entity.post,
    createAt: entity.createAt,
    myUser: MyUser.fromEntity(entity.myUser),
    likes: entity.likes.map(MyUser.fromEntity).toList(),
    comments: entity.comments.map(Comment.fromEntity).toList(),
    postPicture: entity.postPicture,
    isEdited: entity.isEdited,
  );

  @override
  List<Object?> get props => [postId, post, createAt, myUser, likes, comments, postPicture, isEdited];
}
