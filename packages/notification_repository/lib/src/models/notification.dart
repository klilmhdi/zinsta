import 'package:equatable/equatable.dart';
import 'package:notification_repository/src/entities/notification_entity.dart';
import 'package:notification_repository/src/enums/notification_type.dart';

class NotificationModel extends Equatable {
  final String id;
  final String message;
  final String postId;
  final String receiverId;
  final String senderId;
  final String senderName;
  final String senderPicture;
  final String postContent;
  final String postImageUrl;
  final bool isRead;
  final DateTime createdAt;
  final NotificationTypeEnum type;

  const NotificationModel({
    required this.createdAt,
    required this.id,
    required this.isRead,
    required this.message,
    required this.postId,
    required this.receiverId,
    required this.senderId,
    required this.senderName,
    required this.senderPicture,
    required this.postImageUrl,
    this.postContent = '',
    required this.type,
  });

  static var empty = NotificationModel(
    createdAt: DateTime.now(),
    id: '0',
    isRead: false,
    message: '',
    postId: '',
    receiverId: '',
    senderId: '',
    senderName: '',
    postImageUrl: '',
    senderPicture: '',
    postContent: '',
    type: NotificationTypeEnum.like,
  );

  NotificationModel copyWith({
    String? id,
    String? postId,
    String? message,
    String? senderId,
    String? receiverId,
    String? senderName,
    String? senderPicture,
    String? postContent,
    String? postImageUrl,
    NotificationTypeEnum? type,
    DateTime? createdAt,
    bool? isRead,
  }) => NotificationModel(
    id: id ?? this.id,
    senderId: senderId ?? this.senderId,
    receiverId: receiverId ?? this.receiverId,
    senderName: senderName ?? this.senderName,
    senderPicture: senderPicture ?? this.senderPicture,
    postContent: postContent ?? this.postContent,
    postImageUrl: postImageUrl ?? this.postImageUrl,
    type: type ?? this.type,
    postId: postId ?? this.postId,
    createdAt: createdAt ?? this.createdAt,
    isRead: isRead ?? this.isRead,
    message: message ?? this.message,
  );

  bool get isEmpty => this == NotificationModel.empty;

  bool get isNotEmpty => this != NotificationModel.empty;

  static NotificationModel fromEntity(NotificationEntity entity) => NotificationModel(
    id: entity.id,
    message: entity.message,
    postId: entity.postId,
    receiverId: entity.receiverId,
    senderId: entity.senderId,
    senderName: entity.senderName,
    postImageUrl: entity.postImageUrl,
    senderPicture: entity.senderPicture,
    postContent: entity.postContent,
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
    senderName: senderName,
    senderPicture: senderPicture,
    postContent: postContent,
    postImageUrl: postImageUrl,
    type: type,
    isRead: isRead,
    createdAt: createdAt,
  );

  @override
  List<Object?> get props => [
    id,
    message,
    createdAt,
    isRead,
    postId,
    receiverId,
    senderId,
    senderName,
    senderPicture,
    postContent,
    postImageUrl,
    type,
  ];
}
