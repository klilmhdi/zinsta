import 'package:zinsta/core/enums/notification_type_enum.dart';

import '../models/notification.dart';

abstract class NotificationRepository {
  /// Configure OneSignal
  Future<void> initializeOneSignal();

  /// Update the user's OneSignal Player ID
  Future<void> updateUserOneSignalPlayerId(String userId);

  /// Send notification
  Future<void> sendNotification({
    required String senderId,
    required String receiverId,
    required String message,
    required NotificationTypeEnum type,
    String postId = '',
  });

  /// Send like notification
  Future<void> sendLikeNotification({required String senderId, required String receiverId, required String postId});

  /// Send comment notification
  Future<void> sendCommentNotification({
    required String senderId,
    required String receiverId,
    required String postId,
    String commentText = '',
  });

  /// Send follow notification
  Future<void> sendFollowNotification({required String senderId, required String receiverId});

  /// Send follow back notification
  Future<void> sendFollowBackNotification({required String senderId, required String receiverId});

  /// Send re-share notification
  Future<void> sendReShareNotification({required String senderId, required String receiverId, required String postId});

  /// Get user notifications
  Stream<List<NotificationModel>> getUserNotifications(String userId);

  /// Mark notification as read
  Future<void> markAsRead(String userId, String notificationId);

  /// Mark all notifications as read
  Future<void> markAllAsRead(String userId);

  /// Delete notification
  Future<void> deleteNotification(String userId, String notificationId);

  /// Delete All notifications
  Future<void> deleteAllNotifications(String userId);

  /// Get the number of unread notifications
  Future<int> getUnreadNotificationsCount(String userId);

  /// Get the number of unread notifications
  Stream<int> getUnreadNotificationsCountStream(String userId);

  /// Clean up old notifications (more than 30 days old)
  Future<void> cleanupOldNotifications(String userId);
}
