import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:notification_repository/src/enums/notification_type.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String message;
  final String postId;
  final String receiverId;
  final String senderId;
  final NotificationTypeEnum type;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.message,
    required this.postId,
    required this.receiverId,
    required this.senderId,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  Map<String, Object?> toDocument() => {
    'id': id,
    'postId': postId,
    'message': message,
    'senderId': senderId,
    'receiverId': receiverId,
    'isRead': isRead,
    'type': type,
    'createAt': Timestamp.fromDate(createdAt),
  };

  static NotificationEntity fromDocument(Map<String, dynamic> doc) => NotificationEntity(
    id: doc['id'] as String? ?? '',
    senderId: doc['senderId'] as String? ?? '',
    receiverId: doc['receiverId'] as String? ?? '',
    postId: doc['postId'] as String? ?? '',
    message: doc['message'] as String? ?? '',
    isRead: doc['isRead'] as bool? ?? false,
    createdAt: (doc['createdAt'] as Timestamp?)?.toDate() ?? DateTime(1970),
    type: NotificationTypeEnumExtension.fromJson(doc['type']),
  );

  @override
  List<Object?> get props => [id, message, createdAt, isRead, postId, receiverId, senderId, type];
}
