import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String id;
  final String name;
  final String username;
  final String email;
  final String bio;
  final String? picture;
  final String? background;
  final String? token;
  final String oneSignalPlayerId;
  final bool isOnline;
  final DateTime lastSeen;

  const MyUserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.bio,
    required this.username,
    required this.oneSignalPlayerId,
    required this.isOnline,
    required this.lastSeen,
    this.picture,
    this.background,
    this.token,
  });

  Map<String, Object?> toDocument() => {
    'id': id,
    'email': email,
    'name': name,
    'picture': picture,
    'username': username,
    'bio': bio,
    'background': background,
    'token': token,
    'oneSignalPlayerId': oneSignalPlayerId,
    'isOnline': isOnline,
    'lastSeen': lastSeen,
  };

  static MyUserEntity fromDocument(Map<String, dynamic> doc) => MyUserEntity(
    id: doc['id'] as String? ?? '',
    email: doc['email'] as String? ?? '',
    name: doc['name'] as String? ?? '',
    picture: doc['picture'] as String?,
    username: doc['username'] as String? ?? '',
    bio: doc['bio'] as String? ?? '',
    background: doc['background'] as String? ?? '',
    token: doc['token'] as String?,
    oneSignalPlayerId: doc['oneSignalPlayerId'] as String? ?? '',
    isOnline: doc['isOnline'] as bool? ?? false,
    lastSeen: doc['lastSeen'] != null ? (doc['lastSeen'] as Timestamp).toDate() : DateTime.now(),
  );

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    picture,
    bio,
    background,
    username,
    token,
    oneSignalPlayerId,
    isOnline,
    lastSeen,
  ];
}
