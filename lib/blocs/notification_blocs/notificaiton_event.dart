part of 'notificaiton_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadNotifications extends NotificationEvent {
  final String userId;

  const LoadNotifications(this.userId);

  @override
  List<Object> get props => [userId];
}

class SendLikeNotification extends NotificationEvent {
  final String senderId;
  final String receiverId;
  final String postId;

  const SendLikeNotification({required this.senderId, required this.receiverId, required this.postId});

  @override
  List<Object> get props => [senderId, receiverId, postId];
}

class SendCommentNotification extends NotificationEvent {
  final String senderId;
  final String receiverId;
  final String postId;
  final String commentText;

  const SendCommentNotification({
    required this.senderId,
    required this.receiverId,
    required this.postId,
    this.commentText = '',
  });

  @override
  List<Object> get props => [senderId, receiverId, postId, commentText];
}

class SendFollowNotification extends NotificationEvent {
  final String senderId;
  final String receiverId;

  const SendFollowNotification({required this.senderId, required this.receiverId});

  @override
  List<Object> get props => [senderId, receiverId];
}

class SendFollowBackNotification extends NotificationEvent {
  final String senderId;
  final String receiverId;

  const SendFollowBackNotification({required this.senderId, required this.receiverId});

  @override
  List<Object> get props => [senderId, receiverId];
}

class MarkNotificationAsRead extends NotificationEvent {
  final String userId;
  final String notificationId;

  const MarkNotificationAsRead({required this.userId, required this.notificationId});

  @override
  List<Object> get props => [userId, notificationId];
}

class MarkAllNotificationsAsRead extends NotificationEvent {
  final String userId;

  const MarkAllNotificationsAsRead(this.userId);

  @override
  List<Object> get props => [userId];
}

class DeleteNotification extends NotificationEvent {
  final String userId;
  final String notificationId;

  const DeleteNotification({required this.userId, required this.notificationId});

  @override
  List<Object> get props => [userId, notificationId];
}

class DeleteAllNotification extends NotificationEvent {
  final String userId;

  const DeleteAllNotification({required this.userId});

  @override
  List<Object> get props => [userId];
}

class UpdateOneSignalPlayerId extends NotificationEvent {
  final String userId;

  const UpdateOneSignalPlayerId(this.userId);

  @override
  List<Object> get props => [userId];
}

class InitializeOneSignal extends NotificationEvent {
  const InitializeOneSignal();
}
