import '../notification_repository.dart';

abstract class NotificationRepository {
  /// Send notification
  Future<void> sendNotification();

  /// Save notification to FirebaseFireStore
  Future<void> saveNotification({required Notification notification});

  /// Get all notification from FirebaseFireStore
  // Future<Stream<List<Notification>>> getNotifications(String userId);
  Stream<List<Notification>> getNotifications(String userId);
}
