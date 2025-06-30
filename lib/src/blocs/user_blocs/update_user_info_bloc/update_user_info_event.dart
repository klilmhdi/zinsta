part of 'update_user_info_bloc.dart';

abstract class UpdateUserInfoEvent extends Equatable {
  const UpdateUserInfoEvent();

  @override
  List<Object?> get props => [];
}

class EditUserData extends UpdateUserInfoEvent {
  final String userId;
  final String name;
  final String username;
  final String email;
  final String bio;
  final String? profileImagePath;
  final String? backgroundImagePath;

  const EditUserData({
    required this.userId,
    required this.name,
    required this.username,
    required this.email,
    required this.bio,
    this.profileImagePath,
    this.backgroundImagePath,
  });

  @override
  List<Object?> get props => [userId, name, username, email, bio, profileImagePath, backgroundImagePath];
}
