import 'package:firebase_auth/firebase_auth.dart';
import 'package:zinsta/core/models/my_user.dart';

abstract class UserRepository {
  Stream<User?> get user;

  /// Sign in function
  Future<void> signIn(String email, String password);

  /// Logout
  Future<void> logOut();

  /// Sign up function
  Future<MyUser> signUp(MyUser myUser, String password, String token);

  /// Reset password function
  Future<void> resetPassword(String email);

  /// Create user and upload the data to firebase
  Future<void> setUserData(MyUser user);

  /// Get (Fetch) user data
  Future<MyUser> getMyUser(String myUserId);

  /// Edit user data
  Future<void> editUserData({
    required String userId,
    required MyUser user,
    String? profilePicturePath,
    String? backgroundPicturePath,
  });

  /// Search
  Future<List<MyUser>> searchUserFromUsername(String query);

  /// Send follow
  Future<void> followUser(String currentUserId, String targetUserId);

  /// remove the follow
  Future<void> unfollowUser(String currentUserId, String targetUserId);

  /// Check if I request a follow
  Future<bool> isFollowing(String currentUserId, String targetUserId);

  /// Get followers count
  Future<int> getFollowersCount(String userId);

  /// Get following count
  Future<int> getFollowingCount(String userId);

  /// Get followers
  Future<List<MyUser>> getFollowers(String userId);

  /// Get followings
  Future<List<MyUser>> getFollowing(String userId);

  /// Check if the user online now
  Future<void> updateUserOnlineStatus(String userId, bool isOnline);
}
