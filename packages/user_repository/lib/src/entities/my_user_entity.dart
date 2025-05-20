import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String id;
  final String name;
  final String username;
  final String email;
  final String bio;
  final String? picture;
  final String? background;

  const MyUserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.bio,
    required this.username,
    this.picture,
    this.background,
  });

  Map<String, Object?> toDocument() => {
    'id': id,
    'email': email,
    'name': name,
    'picture': picture,
    'username': username,
    'bio': bio,
    'background': background,
  };

  static MyUserEntity fromDocument(Map<String, dynamic> doc) => MyUserEntity(
    id: doc['id'] as String? ?? '',
    email: doc['email'] as String? ?? '',
    name: doc['name'] as String? ?? '',
    picture: doc['picture'] as String?,
    username: doc['username'] as String? ?? '',
    bio: doc['bio'] as String? ?? '',
    background: doc['background'] as String? ?? '',
  );

  @override
  List<Object?> get props => [id, email, name, picture, bio, background, username];
}
