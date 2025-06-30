import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:zinsta/core/models/notification.dart';
import 'package:zinsta/src/blocs/auth_blocs/authentication_bloc/authentication_bloc.dart';
import 'package:zinsta/src/components/consts/snackbars.dart';
import 'package:zinsta/src/components/consts/strings.dart';
import 'package:zinsta/src/components/profile_components/user_avatar.dart';

import '../../../core/enums/notification_type_enum.dart';
import '../../blocs/notification_blocs/notificaiton_bloc.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final bool isLastItem;

  const NotificationItem({super.key, required this.notification, this.isLastItem = false});

  void _handleNotificationTap(BuildContext context) {
    if (!notification.isRead) {
      context.read<NotificationBloc>().add(
        MarkNotificationAsRead(
          userId: context.read<AuthenticationBloc>().state.user!.uid,
          notificationId: notification.id,
        ),
      );
    }

    // Handle navigation based on notification type
    switch (notification.type) {
      case NotificationTypeEnum.like:
      case NotificationTypeEnum.comment:
      case NotificationTypeEnum.reShare:
        // Navigate to post
        if (notification.postId.isNotEmpty) {
          // Navigator.push(context, MaterialPageRoute(builder: (_) => PostScreen()));
        }
        break;
      case NotificationTypeEnum.follow:
      case NotificationTypeEnum.followBack:
        // Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(isCurrentUser: false)));
        break;
    }
  }

  void _handleFollowBackAction(BuildContext context) {
    if (notification.type == NotificationTypeEnum.follow) {
      context.read<NotificationBloc>().add(
        SendFollowBackNotification(
          senderId: context.read<AuthenticationBloc>().state.user!.uid,
          receiverId: notification.senderId,
        ),
      );
    }
  }

  void _handleDelete(BuildContext context) {
    context.read<NotificationBloc>().add(
      DeleteNotification(userId: context.read<AuthenticationBloc>().state.user!.uid, notificationId: notification.id),
    );
    showCustomSnackBar(
      context: context,
      title: 'Notification Deleted successful',
      duration: 3,
      type: MessageType.success,
    );
  }

  @override
  Widget build(BuildContext context) => Slidable(
    key: ValueKey(notification.id),
    groupTag: 'notifications',
    closeOnScroll: true,
    useTextDirection: true,
    endActionPane: ActionPane(
      motion: const ScrollMotion(),
      dismissible: DismissiblePane(onDismissed: () => _handleDelete(context)),
      children: [
        SlidableAction(
          onPressed: (context) => _handleDelete(context),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: HugeIcons.strokeRoundedDelete02,
          label: 'Delete',
          borderRadius: BorderRadius.circular(12),
        ),
      ],
    ),
    child: Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          leading: _buildAvatarWithBadge(context, profilePicture: notification.senderPicture),
          title: Text(
            notification.message,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            // _formatTimeAgo(notification.createdAt),
            AppStrings.getEnglishTimeAgo(notification.createdAt),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey),
          ),
          trailing: _buildTrailingWidget(context),
          onTap: () => _handleNotificationTap(context),
        ),
        if (!isLastItem) Divider(height: 1, thickness: 3, color: Theme.of(context).dividerColor),
      ],
    ),
  );

  Widget _buildTrailingWidget(BuildContext context) {
    if (notification.type == NotificationTypeEnum.follow || notification.type == NotificationTypeEnum.followBack) {
      return _buildFollowButton(context);
    }

    if (notification.postImageUrl.isNotEmpty) {
      return SizedBox(
        width: 48,
        height: 48,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: CachedNetworkImage(
            imageUrl: notification.postImageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: Colors.grey[200]),
            errorWidget:
                (context, url, error) => Container(color: Colors.grey[200], child: const Icon(Icons.error, size: 20)),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildAvatarWithBadge(BuildContext context, {required String profilePicture}) => Stack(
    clipBehavior: Clip.none,
    children: [
      buildUserCertifiedAvatarWidget(profilePicture: profilePicture),
      Positioned(
        bottom: -4,
        right: -4,
        child: Container(
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: _getBadgeColor(context),
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2),
          ),
          child: Icon(_getNotificationIcon(), size: 15, color: Colors.white),
        ),
      ),
    ],
  );

  Widget _buildFollowButton(BuildContext context) => SizedBox(
    width: 100,
    child: OutlinedButton(
      onPressed: () => _handleFollowBackAction(context),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        side: BorderSide(color: Theme.of(context).primaryColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text(
        notification.type == NotificationTypeEnum.followBack ? 'Following' : 'Follow',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).primaryColor, fontSize: 12),
      ),
    ),
  );

  IconData _getNotificationIcon() {
    switch (notification.type) {
      case NotificationTypeEnum.like:
        return HugeIcons.strokeRoundedFavouriteCircle;
      case NotificationTypeEnum.comment:
        return HugeIcons.strokeRoundedCommentAdd01;
      case NotificationTypeEnum.follow:
      case NotificationTypeEnum.followBack:
        return HugeIcons.strokeRoundedUserAdd01;
      case NotificationTypeEnum.reShare:
        return HugeIcons.strokeRoundedShare05;
    }
  }

  Color _getBadgeColor(BuildContext context) {
    switch (notification.type) {
      case NotificationTypeEnum.like:
        return Colors.red;
      case NotificationTypeEnum.comment:
        return Colors.blue;
      case NotificationTypeEnum.follow:
      case NotificationTypeEnum.followBack:
        return Colors.green;
      case NotificationTypeEnum.reShare:
        return Colors.purple;
    }
  }
}
