import 'package:equatable/equatable.dart';
import '../entities/my_user_entity.dart';

import '../entities/entities.dart';

class MyUser extends Equatable {
  final String id;
  final String email;
  final String name;
  final String picture;
  final String username;
  final String bio;
  final String? background;

  const MyUser({
    required this.id,
    required this.email,
    required this.name,
    required this.picture,
    required this.username,
    required this.bio,
    this.background,
  });

  static const empty = MyUser(
    id: '',
    email: '',
    name: '',
    picture: '',
    username: '',
    bio: '',
    background: '',
  );

  MyUser copyWith({
    String? id,
    String? email,
    String? name,
    String? picture,
    String? username,
    String? bio,
    String? background,
  }) {
    return MyUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      picture: picture ?? this.picture,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      background: background ?? this.background,
    );
  }

  bool get isEmpty => this == MyUser.empty;
  bool get isNotEmpty => this != MyUser.empty;

  MyUserEntity toEntity() => MyUserEntity(
    id: id,
    email: email,
    name: name,
    picture: picture,
    username: username,
    bio: bio,
    background: background,
  );

  static MyUser fromEntity(MyUserEntity entity) => MyUser(
    id: entity.id,
    email: entity.email,
    name: entity.name,
    picture: entity.picture ?? '',
    username: entity.username,
    bio: entity.bio,
    background: entity.background,
  );

  @override
  List<Object?> get props => [id, email, name, picture, username, bio, background];
}
