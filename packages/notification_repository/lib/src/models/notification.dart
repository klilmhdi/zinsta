import 'package:notification_repository/src/entities/notification_entity.dart';
import 'package:notification_repository/src/enums/notification_type.dart';
import 'package:equatable/equatable.dart';

class Notification extends Equatable {
  final DateTime createdAt;
  final String id;
  final bool isRead;
  final String message;
  final String postId;
  final String receiverId;
  final String senderId;
  final NotificationTypeEnum type;

  const Notification({
    required this.createdAt,
    required this.id,
    required this.isRead,
    required this.message,
    required this.postId,
    required this.receiverId,
    required this.senderId,
    required this.type,
  });

  static var empty = Notification(
    createdAt: DateTime.now(),
    id: '1',
    isRead: false,
    message: '',
    postId: '',
    receiverId: '',
    senderId: '',
    type: NotificationTypeEnum.like,
  );

  Notification copyWith({
    String? id,
    String? postId,
    String? message,
    String? senderId,
    String? receiverId,
    NotificationTypeEnum? type,
    DateTime? createdAt,
    bool? isRead,
  }) => Notification(
    id: id ?? this.id,
    senderId: senderId ?? this.senderId,
    receiverId: receiverId ?? this.receiverId,
    type: type ?? this.type,
    postId: postId ?? this.postId,
    createdAt: createdAt ?? this.createdAt,
    isRead: isRead ?? this.isRead,
    message: message ?? this.message,
  );

  bool get isEmpty => this == Notification.empty;

  bool get isNotEmpty => this != Notification.empty;

  static Notification fromEntity(NotificationEntity entity) => Notification(
    id: entity.id,
    message: entity.message,
    postId: entity.postId,
    receiverId: entity.receiverId,
    senderId: entity.senderId,
    type: entity.type,
    isRead: entity.isRead,
    createdAt: entity.createdAt,
  );

  NotificationEntity toEntity() => NotificationEntity(
    id: id,
    message: message,
    postId: postId,
    receiverId: receiverId,
    senderId: senderId,
    type: type,
    isRead: isRead,
    createdAt: createdAt,
  );

  @override
  List<Object?> get props => [id, message, createdAt, isRead, postId, receiverId, senderId, type];
}
