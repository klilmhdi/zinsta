import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class FollowCubit extends Cubit<bool> {
  final FirebaseUserRepository userRepository;
  final String currentUserId;
  final String targetUserId;

  FollowCubit({
    required this.userRepository,
    required this.currentUserId,
    required this.targetUserId,
  }) : super(false) {
    checkFollowStatus();
  }

  Future<void> checkFollowStatus() async {
    final isFollowing = await userRepository.isFollowing(currentUserId, targetUserId);
    emit(isFollowing);
  }

  Future<void> sendFollow() async {
    await userRepository.followUser(currentUserId, targetUserId);
    emit(true);
  }

  Future<void> removeFollow() async {
    await userRepository.unfollowUser(currentUserId, targetUserId);
    emit(false);
  }
}
