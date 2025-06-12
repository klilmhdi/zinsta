part of 'follower_bloc.dart';

enum FollowStatus { initial, loading, following, notFollowing }

class FollowersState extends Equatable {
  final String? targetUserId;
  final bool isFollowing;
  final int followersCount;
  final int followingCount;
  final List<Map<String, dynamic>>? followersList;
  final List<Map<String, dynamic>>? followingList;
  final FollowStatus status;
  final String? error;

  const FollowersState({
    this.targetUserId,
    this.status = FollowStatus.initial,
    this.isFollowing = false,
    this.followersCount = 0,
    this.followingCount = 0,
    this.followersList,
    this.followingList,
    this.error,
  });

  FollowersState copyWith({
    FollowStatus? status,
    bool? isFollowing,
    int? followersCount,
    int? followingCount,
    List<Map<String, dynamic>>? followersList,
    List<Map<String, dynamic>>? followingList,
    String? error,
  }) {
    return FollowersState(
      status: status ?? this.status,
      isFollowing: isFollowing ?? this.isFollowing,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      followersList: followersList ?? this.followersList,
      followingList: followingList ?? this.followingList,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    isFollowing,
    followersCount,
    followingCount,
    error,
    followersList,
    followingList,
  ];
}

class FollowersInitial extends FollowersState {}

class FollowersLoading extends FollowersState {
  const FollowersLoading() : super(status: FollowStatus.loading);
}

class FollowersLoaded extends FollowersState {
  final String targetUserId;
  final bool isFollowing;
  final int followersCount;
  final int followingCount;
  final FollowStatus status;

  const FollowersLoaded({
    required this.targetUserId,
    required this.isFollowing,
    required this.followersCount,
    required this.followingCount,
    this.status = FollowStatus.initial,
  }) : super(
    targetUserId: targetUserId,
    isFollowing: isFollowing,
    followersCount: followersCount,
    followingCount: followingCount,
    status: status,
  );

  @override
  List<Object> get props => [targetUserId, isFollowing, followersCount, followingCount, status];
}

class FollowersError extends FollowersState {
  const FollowersError(String error) : super(error: error);
}

class GetFollowerLoading extends FollowersState {
  const GetFollowerLoading() : super(status: FollowStatus.loading);
}

class GetFollowerLoaded extends FollowersState {
  final List<MyUser> users;
  const GetFollowerLoaded(this.users);
}

class GetFollowerError extends FollowersState {
  const GetFollowerError(String error) : super(error: error);
}

class GetFollowingLoading extends FollowersState {
  const GetFollowingLoading() : super(status: FollowStatus.loading);
}

class GetFollowingLoaded extends FollowersState {
  final List<MyUser> users;
  const GetFollowingLoaded(this.users);
}

class GetFollowingError extends FollowersState {
  const GetFollowingError(String error) : super(error: error);
}