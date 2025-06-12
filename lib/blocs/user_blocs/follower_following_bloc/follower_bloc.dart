import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

import '../../../components/consts/shared_perferenced.dart';

part 'follower_event.dart';
part 'follower_state.dart';

class FollowersBloc extends Bloc<FollowersEvent, FollowersState> {
  final UserRepository _userRepository;
  final pref = SharedPrefController();

  FollowersBloc({required UserRepository userRepository})
    : _userRepository = userRepository,
      super(FollowersInitial()) {
    on<LoadFollowersCount>(_onLoadFollowersCount);
    on<FollowUser>(_onFollowUser);
    on<UnfollowUser>(_onUnfollowUser);
    on<LoadFollowers>(_onLoadFollowers);
    on<LoadFollowing>(_onLoadFollowing);
  }

  Future<void> _onLoadFollowersCount(LoadFollowersCount event, Emitter<FollowersState> emit) async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) {
        emit(FollowersInitial());
        return;
      }
      if (state is FollowersLoaded && (state as FollowersLoaded).targetUserId == event.targetUserId) {
        return;
      }
      emit(FollowersLoading());
      final isFollowing = await _userRepository.isFollowing(currentUserId, event.targetUserId);
      final followersCount = await _userRepository.getFollowersCount(event.targetUserId);
      final followingCount = await _userRepository.getFollowingCount(event.targetUserId);

      await pref.setUserFollowersCount(event.targetUserId, followersCount);
      await pref.setUserFollowingCount(event.targetUserId, followingCount);

      emit(
        FollowersLoaded(
          targetUserId: event.targetUserId,
          isFollowing: isFollowing,
          followersCount: followersCount,
          followingCount: followingCount,
        ),
      );
    } catch (e) {
      emit(FollowersError(e.toString()));
    }
  }

  Future<void> _onFollowUser(FollowUser event, Emitter<FollowersState> emit) async {
    if (state is! FollowersLoaded) return;
    final currentState = state as FollowersLoaded;

    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) return;
      emit(currentState.copyWith(status: FollowStatus.loading));
      await _userRepository.followUser(currentUserId, event.targetUserId);
      emit(
        FollowersLoaded(
          targetUserId: event.targetUserId,
          isFollowing: true,
          followersCount: currentState.followersCount + 1,
          followingCount: currentState.followingCount,
        ),
      );
    } catch (e) {
      emit(FollowersError(e.toString()));
    }
  }

  Future<void> _onUnfollowUser(UnfollowUser event, Emitter<FollowersState> emit) async {
    if (state is! FollowersLoaded) return;
    final currentState = state as FollowersLoaded;

    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) return;
      emit(currentState.copyWith(status: FollowStatus.loading));
      await _userRepository.unfollowUser(currentUserId, event.targetUserId);
      emit(
        FollowersLoaded(
          targetUserId: event.targetUserId,
          isFollowing: false,
          followersCount: currentState.followersCount - 1,
          followingCount: currentState.followingCount,
        ),
      );
    } catch (e) {
      emit(FollowersError(e.toString()));
    }
  }

  Future<void> _onLoadFollowers(LoadFollowers event, Emitter<FollowersState> emit) async {
    emit(GetFollowerLoading());
    try {
      final users = await _userRepository.getFollowers(event.userId);
      emit(GetFollowerLoaded(users));
    } catch (e) {
      emit(GetFollowerError(e.toString()));
    }
  }

  Future<void> _onLoadFollowing(LoadFollowing event, Emitter<FollowersState> emit) async {
    emit(GetFollowingLoading());
    try {
      final users = await _userRepository.getFollowing(event.userId);
      emit(GetFollowingLoaded(users));
    } catch (e) {
      emit(GetFollowingError(e.toString()));
    }
  }
}

// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:user_repository/user_repository.dart';
//
// import '../../../components/consts/shared_perferenced.dart';
//
// part 'follower_event.dart';
//
// part 'follower_state.dart';
//
// class FollowersBloc extends Bloc<FollowersEvent, FollowersState> {
//   final UserRepository _userRepository;
//   final pref = SharedPrefController();
//
//   FollowersBloc({required UserRepository userRepository})
//     : _userRepository = userRepository,
//       super(FollowersInitial()) {
//     on<LoadFollowersCount>(_onLoadFollowersCount);
//     on<FollowUser>(_onFollowUser);
//     on<UnfollowUser>(_onUnfollowUser);
//     on<LoadFollowers>(_onLoadFollowers);
//     on<LoadFollowing>(_onLoadFollowing);
//   }
//
//   Future<void> _onLoadFollowersCount(LoadFollowersCount event, Emitter<FollowersState> emit) async {
//     try {
//       final currentUserId = FirebaseAuth.instance.currentUser?.uid;
//       if (currentUserId == null) {
//         emit(FollowersInitial());
//         return;
//       }
//       if (state is FollowersLoaded && (state as FollowersLoaded).targetUserId == event.targetUserId) {
//         return;
//       }
//       emit(FollowersLoading());
//       final isFollowing = await _userRepository.isFollowing(currentUserId, event.targetUserId);
//       final followersCount = await _userRepository.getFollowersCount(event.targetUserId);
//       final followingCount = await _userRepository.getFollowingCount(event.targetUserId);
//
//       await pref.setUserFollowersCount(event.targetUserId, followersCount);
//       await pref.setUserFollowingCount(event.targetUserId, followingCount);
//
//       emit(
//         FollowersLoaded(
//           targetUserId: event.targetUserId,
//           isFollowing: isFollowing,
//           followersCount: followersCount,
//           followingCount: followingCount,
//         ),
//       );
//     } catch (e) {
//       emit(FollowersError(e.toString()));
//     }
//   }
//
//   Future<void> _onFollowUser(FollowUser event, Emitter<FollowersState> emit) async {
//     if (state is! FollowersLoaded) return;
//     final currentState = state as FollowersLoaded;
//
//     try {
//       final currentUserId = FirebaseAuth.instance.currentUser?.uid;
//       if (currentUserId == null) return;
//       emit(currentState.copyWith(status: FollowStatus.loading));
//       await _userRepository.followUser(currentUserId, event.targetUserId);
//       emit(
//         FollowersLoaded(
//           targetUserId: event.targetUserId,
//           isFollowing: true,
//           followersCount: currentState.followersCount + 1,
//           followingCount: currentState.followingCount,
//         ),
//       );
//     } catch (e) {
//       emit(FollowersError(e.toString()));
//     }
//   }
//
//   Future<void> _onUnfollowUser(UnfollowUser event, Emitter<FollowersState> emit) async {
//     if (state is! FollowersLoaded) return;
//     final currentState = state as FollowersLoaded;
//
//     try {
//       final currentUserId = FirebaseAuth.instance.currentUser?.uid;
//       if (currentUserId == null) return;
//       emit(currentState.copyWith(status: FollowStatus.loading));
//       await _userRepository.unfollowUser(currentUserId, event.targetUserId);
//       emit(
//         FollowersLoaded(
//           targetUserId: event.targetUserId,
//           isFollowing: false,
//           followersCount: currentState.followersCount - 1,
//           followingCount: currentState.followingCount,
//         ),
//       );
//     } catch (e) {
//       emit(FollowersError(e.toString()));
//     }
//   }
//
//   Future<void> _onLoadFollowers(LoadFollowers event, Emitter<FollowersState> emit) async {
//     emit(GetFollowerLoading());
//     try {
//       final users = await _userRepository.getFollowers(event.userId);
//       emit(GetFollowerLoaded(users));
//     } catch (e) {
//       emit(GetFollowerError(e.toString()));
//     }
//   }
//
//   Future<void> _onLoadFollowing(LoadFollowing event, Emitter<FollowersState> emit) async {
//     emit(GetFollowingLoading());
//     try {
//       final users = await _userRepository.getFollowing(event.userId);
//       emit(GetFollowingLoaded(users));
//     } catch (e) {
//       emit(GetFollowingError(e.toString()));
//     }
//   }
// }
