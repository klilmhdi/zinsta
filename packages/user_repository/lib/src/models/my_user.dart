import 'package:equatable/equatable.dart';

import '../entities/entities.dart';
import '../entities/my_user_entity.dart';

class MyUser extends Equatable {
  final String id;
  final String email;
  final String name;
  final String picture;
  final String username;
  final String bio;
  final String? background;
  final String? token;
  final String oneSignalPlayerId;
  final bool isOnline;
  final DateTime lastSeen;

  const MyUser({
    required this.id,
    required this.email,
    required this.name,
    required this.picture,
    required this.username,
    required this.bio,
    required this.oneSignalPlayerId,
    required this.isOnline,
    required this.lastSeen,
    this.background,
    this.token,
  });

  static var empty = MyUser(
    id: '',
    email: '',
    name: '',
    picture: '',
    username: '',
    bio: '',
    background: '',
    token: '',
    isOnline: false,
    lastSeen: DateTime.now(),
    oneSignalPlayerId: '',
  );

  MyUser copyWith({
    String? id,
    String? email,
    String? name,
    String? picture,
    String? username,
    String? bio,
    String? background,
    String? token,
    String? oneSignalPlayerId,
    bool? isOnline,
    DateTime? lastSeen,
  }) {
    return MyUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      picture: picture ?? this.picture,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      background: background ?? this.background,
      token: token ?? this.token,
      isOnline: isOnline ?? this.isOnline,
      oneSignalPlayerId: oneSignalPlayerId ?? this.oneSignalPlayerId,
      lastSeen: lastSeen ?? this.lastSeen,
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
    token: token,
    isOnline: isOnline,
    oneSignalPlayerId: oneSignalPlayerId,
    lastSeen: lastSeen,
  );

  static MyUser fromEntity(MyUserEntity entity) => MyUser(
    id: entity.id,
    email: entity.email,
    name: entity.name,
    picture: entity.picture ?? '',
    username: entity.username,
    bio: entity.bio,
    background: entity.background,
    token: entity.token,
    oneSignalPlayerId: entity.oneSignalPlayerId,
    isOnline: entity.isOnline,
    lastSeen: entity.lastSeen,
  );

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    picture,
    username,
    bio,
    background,
    token,
    oneSignalPlayerId,
    isOnline,
    lastSeen,
  ];
}
