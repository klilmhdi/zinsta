import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notification_repository/notification_repository.dart';

part 'notificaiton_event.dart';
part 'notificaiton_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final OneSignalNotificationRepository _notificationRepository;

  NotificationBloc({required OneSignalNotificationRepository notificationRepository})
    : _notificationRepository = notificationRepository,
      super(NotificationInitial()) {
    on<InitializeOneSignal>(_onInitializeOneSignal);
    on<LoadNotifications>(_onLoadNotifications);
    on<SendLikeNotification>(_onSendLikeNotification);
    on<SendCommentNotification>(_onSendCommentNotification);
    on<SendFollowNotification>(_onSendFollowNotification);
    on<SendFollowBackNotification>(_onSendFollowBackNotification);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
    on<MarkAllNotificationsAsRead>(_onMarkAllNotificationsAsRead);
    on<DeleteNotification>(_onDeleteNotification);
    on<DeleteAllNotification>(_onDeleteAllNotifications);
    on<UpdateOneSignalPlayerId>(_onUpdateOneSignalPlayerId);
  }

  void _onInitializeOneSignal(InitializeOneSignal event, Emitter<NotificationState> emit) async {
    try {
      await _notificationRepository.initializeOneSignal(); // <-- استخدم النسخة الموجودة
      emit(OneSignalInitialized());
    } catch (e) {
      emit(NotificationError('فشل في تهيئة OneSignal: ${e.toString()}'));
    }
  }

  void _onLoadNotifications(LoadNotifications event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      await emit.forEach<List<NotificationModel>>(
        _notificationRepository.getUserNotifications(event.userId),
        onData: (notifications) {
          final unreadCount = notifications.where((n) => !n.isRead).length;
          return NotificationLoaded(notifications: notifications, unreadCount: unreadCount);
        },
        onError: (error, stackTrace) => NotificationError(error.toString()),
      );
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  void _onSendLikeNotification(SendLikeNotification event, Emitter<NotificationState> emit) async {
    try {
      await _notificationRepository.sendLikeNotification(
        senderId: event.senderId,
        receiverId: event.receiverId,
        postId: event.postId,
      );
      emit(const NotificationSent('تم إرسال إشعار الإعجاب'));
    } catch (e) {
      emit(NotificationError('فشل في إرسال إشعار الإعجاب: ${e.toString()}'));
    }
  }

  void _onSendCommentNotification(SendCommentNotification event, Emitter<NotificationState> emit) async {
    try {
      await _notificationRepository.sendCommentNotification(
        senderId: event.senderId,
        receiverId: event.receiverId,
        postId: event.postId,
        commentText: event.commentText,
      );
      emit(const NotificationSent('تم إرسال إشعار التعليق'));
    } catch (e) {
      emit(NotificationError('فشل في إرسال إشعار التعليق: ${e.toString()}'));
    }
  }

  void _onSendFollowNotification(SendFollowNotification event, Emitter<NotificationState> emit) async {
    try {
      await _notificationRepository.sendFollowNotification(senderId: event.senderId, receiverId: event.receiverId);
      emit(const NotificationSent('تم إرسال إشعار المتابعة'));
    } catch (e) {
      emit(NotificationError('فشل في إرسال إشعار المتابعة: ${e.toString()}'));
    }
  }

  void _onSendFollowBackNotification(SendFollowBackNotification event, Emitter<NotificationState> emit) async {
    try {
      await _notificationRepository.sendFollowBackNotification(senderId: event.senderId, receiverId: event.receiverId);
      emit(const NotificationSent('تم إرسال إشعار رد المتابعة'));
    } catch (e) {
      emit(NotificationError('فشل في إرسال إشعار رد المتابعة: ${e.toString()}'));
    }
  }

  void _onMarkNotificationAsRead(MarkNotificationAsRead event, Emitter<NotificationState> emit) async {
    try {
      await _notificationRepository.markAsRead(event.userId, event.notificationId);
      emit(NotificationMarkedAsRead());
    } catch (e) {
      emit(NotificationError('فشل في تحديد الإشعار كمقروء: ${e.toString()}'));
    }
  }

  void _onMarkAllNotificationsAsRead(MarkAllNotificationsAsRead event, Emitter<NotificationState> emit) async {
    try {
      await (_notificationRepository).markAllAsRead(event.userId);
      emit(NotificationMarkedAsRead());
    } catch (e) {
      emit(NotificationError('فشل في تحديد جميع الإشعارات كمقروءة: ${e.toString()}'));
    }
  }

  void _onDeleteNotification(DeleteNotification event, Emitter<NotificationState> emit) async {
    try {
      await _notificationRepository.deleteNotification(event.userId, event.notificationId);
      emit(NotificationDeleted());
    } catch (e) {
      emit(NotificationError('فشل في حذف الإشعار: ${e.toString()}'));
    }
  }

  void _onDeleteAllNotifications(DeleteAllNotification event, Emitter<NotificationState> emit) async {
    try {
      await _notificationRepository.deleteAllNotifications(event.userId);
      emit(AllNotificationsDeleted());
    } catch (e) {
      emit(NotificationError('فشل في حذف الإشعار: ${e.toString()}'));
    }
  }

  void _onUpdateOneSignalPlayerId(UpdateOneSignalPlayerId event, Emitter<NotificationState> emit) async {
    try {
      await (_notificationRepository).updateUserOneSignalPlayerId(event.userId);
      emit(OneSignalPlayerIdUpdated());
    } catch (e) {
      emit(NotificationError('فشل في تحديث OneSignal Player ID: ${e.toString()}'));
    }
  }
}