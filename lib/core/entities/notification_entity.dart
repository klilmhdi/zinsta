import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:zinsta/core/enums/notification_type_enum.dart';

class NotificationEntity extends Equatable {
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

  const NotificationEntity({
    required this.createdAt,
    required this.id,
    required this.isRead,
    required this.message,
    required this.postId,
    required this.receiverId,
    required this.senderId,
    required this.senderName,
    required this.senderPicture,
    this.postContent = '',
    this.postImageUrl = '',
    required this.type,
  });

  Map<String, Object?> toDocument() {
    return {
      'createdAt': createdAt,
      'id': id,
      'isRead': isRead,
      'message': message,
      'postId': postId,
      'receiverId': receiverId,
      'senderId': senderId,
      'senderName': senderName,
      'senderPicture': senderPicture,
      'postContent': postContent,
      'postImageUrl': postImageUrl,
      'type': type.toJson(),
    };
  }

  static NotificationEntity fromDocument(Map<String, dynamic> doc) {
    return NotificationEntity(
      createdAt: (doc['createdAt'] as Timestamp).toDate(),
      id: doc['id'] as String,
      isRead: doc['isRead'] as bool,
      message: doc['message'] as String,
      postId: doc['postId'] as String? ?? '',
      receiverId: doc['receiverId'] as String,
      senderId: doc['senderId'] as String,
      senderName: doc['senderName'] as String? ?? '',
      senderPicture: doc['senderPicture'] as String? ?? '',
      postImageUrl: doc['postImageUrl'] as String? ?? '',
      postContent: doc['postContent'] as String? ?? '',
      type: NotificationTypeEnumExtension.fromJson(doc['type'] as String),
    );
  }

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
    type,
    postImageUrl
  ];
}
