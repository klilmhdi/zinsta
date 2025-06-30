part of 'follower_bloc.dart';

abstract class FollowersEvent extends Equatable {
  const FollowersEvent();

  @override
  List<Object> get props => [];
}

class LoadFollowersCount extends FollowersEvent {
  final String targetUserId;

  const LoadFollowersCount(this.targetUserId);

  @override
  List<Object> get props => [targetUserId];
}

class FollowUser extends FollowersEvent {
  final String targetUserId;

  const FollowUser(this.targetUserId);

  @override
  List<Object> get props => [targetUserId];
}

class UnfollowUser extends FollowersEvent {
  final String targetUserId;

  const UnfollowUser(this.targetUserId);

  @override
  List<Object> get props => [targetUserId];
}

class LoadFollowers extends FollowersEvent {
  final String userId;

  const LoadFollowers(this.userId);

  @override
  List<Object> get props => [userId];
}

class LoadFollowing extends FollowersEvent {
  final String userId;

  const LoadFollowing(this.userId);

  @override
  List<Object> get props => [userId];
}
