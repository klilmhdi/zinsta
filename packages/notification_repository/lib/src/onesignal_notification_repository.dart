import 'dart:developer';

import 'package:notification_repository/src/models/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../notification_repository.dart';
import 'notification_repo.dart';

// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';

class OnesignalNotificationRepository implements NotificationRepository {
  final usersCollection = FirebaseFirestore.instance.collection('users');

  /// Get all notifications from user collection
  @override
  Stream<List<Notification>> getNotifications(String userId) {
    return usersCollection
        .doc(userId)
        .collection('notifications')
        .orderBy('createAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => Notification.fromEntity(NotificationEntity.fromDocument(doc.data())),
                  )
                  .toList(),
        );
  }

  /// After send notification, save the notification in user collection
  @override
  Future<void> saveNotification({required Notification notification}) async {
    try {
      await usersCollection
          .doc(notification.receiverId)
          .collection('notifications')
          .doc(notification.id)
          .set(notification.toEntity().toDocument());
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
    }
  }

  @override
  Future<void> sendNotification() {
    // TODO: implement sendNotification
    throw UnimplementedError();
  }
}
