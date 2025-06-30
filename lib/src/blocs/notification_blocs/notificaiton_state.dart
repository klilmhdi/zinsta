part of 'notificaiton_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  final int unreadCount;

  const NotificationLoaded({required this.notifications, required this.unreadCount});

  @override
  List<Object> get props => [notifications, unreadCount];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object> get props => [message];
}

class NotificationSent extends NotificationState {
  final String message;

  const NotificationSent(this.message);

  @override
  List<Object> get props => [message];
}

class NotificationMarkedAsRead extends NotificationState {}

class NotificationDeleted extends NotificationState {}

class AllNotificationsDeleted extends NotificationState {}

class OneSignalPlayerIdUpdated extends NotificationState {}

class OneSignalInitialized extends NotificationState {}
