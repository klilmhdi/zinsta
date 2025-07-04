import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:zinsta/src/blocs/notification_blocs/notificaiton_bloc.dart';
import 'package:zinsta/src/components/consts/loading_indicator.dart';

import '../../../../../core/models/notification.dart';
import '../../../../blocs/auth_blocs/authentication_bloc/authentication_bloc.dart';
import '../../../../components/notification_components/notification_list_tile.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) =>
          context.read<NotificationBloc>().add(LoadNotifications(context.read<AuthenticationBloc>().state.user!.uid)),
    );

    return BlocBuilder<NotificationBloc, NotificationState>(
      builder:
          (context, state) => Scaffold(
            appBar: AppBar(
              leading: const BackButton(),
              leadingWidth: 40,
              title: Text.rich(
                TextSpan(
                  text: "Notifications ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: "(${state is NotificationLoaded ? state.notifications.length : 0})",
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              actions: [
                if (state is NotificationLoaded && state.notifications.isNotEmpty)
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed:
                        () => context.read<NotificationBloc>().add(
                          DeleteAllNotification(userId: context.read<AuthenticationBloc>().state.user!.uid),
                        ),
                    icon: HugeIcon(icon: HugeIcons.strokeRoundedDelete02, color: CupertinoColors.destructiveRed),
                  ),
                const SizedBox(width: 15),
              ],
            ),
            body: _buildBodyContent(context, state),
          ),
    );
  }

  Widget _buildBodyContent(BuildContext context, NotificationState state) {
    if (state is NotificationLoading) {
      return Center(child: basicLoadingIndicator());
    }

    if (state is NotificationLoading) {
      return Center(child: basicLoadingIndicator());
    }

    if (state is NotificationLoaded) {
      if (state.notifications.isEmpty) {
        return _buildEmptyState();
      }
      return _buildNotificationList(state.notifications);
    }

    if (state is NotificationError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HugeIcon(icon: HugeIcons.strokeRoundedNotificationOff01, size: 50),
            const SizedBox(height: 16),
            Text(state.message, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed:
                  () => context.read<NotificationBloc>().add(
                    LoadNotifications(context.read<AuthenticationBloc>().state.user!.uid),
                  ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return _buildEmptyState();
  }

  Widget _buildNotificationList(List<NotificationModel> notifications) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(height: 1, color: Theme.of(context).dividerColor),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return NotificationItem(notification: notification, isLastItem: index == notifications.length - 1);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const HugeIcon(icon: HugeIcons.strokeRoundedNotificationOff01, size: 50),
          const SizedBox(height: 16),
          const Text('No notifications received yet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hugeicons/hugeicons.dart';
// import 'package:zinsta/src/blocs/notification_blocs/notificaiton_bloc.dart';
// import 'package:zinsta/src/components/consts/loading_indicator.dart';
//
// import '../../../../blocs/auth_blocs/authentication_bloc/authentication_bloc.dart';
// import '../../../../components/notification_components/notification_list_tile.dart';
//
// class NotificationScreen extends StatelessWidget {
//   const NotificationScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback(
//       (_) =>
//           context.read<NotificationBloc>().add(LoadNotifications(context.read<AuthenticationBloc>().state.user!.uid)),
//     );
//     return BlocBuilder<NotificationBloc, NotificationState>(
//       builder:
//           (context, state) => Scaffold(
//             appBar: AppBar(
//               leading: BackButton(),
//               // leading: HugeIcon(icon: HugeIcons.strokeRoundedArrowLeft01),
//               leadingWidth: 40,
//               title: Text.rich(
//                 TextSpan(
//                   text: "Notifications ",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                   children: [
//                     TextSpan(
//                       text: "(${state is NotificationLoaded ? state.notifications.length : 0})",
//                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 IconButton(
//                   splashColor: Colors.transparent,
//                   highlightColor: Colors.transparent,
//                   disabledColor: Colors.transparent,
//                   focusColor: Colors.transparent,
//                   hoverColor: Colors.transparent,
//                   onPressed:
//                       () => context.read<NotificationBloc>().add(
//                         DeleteAllNotification(userId: context.read<AuthenticationBloc>().state.user!.uid),
//                       ),
//                   icon: HugeIcon(icon: HugeIcons.strokeRoundedDelete02, color: CupertinoColors.destructiveRed),
//                 ),
//                 SizedBox(width: 15),
//               ],
//             ),
//             body:
//                 state is NotificationLoaded
//                     ? state.notifications.isEmpty
//                         ? Center(
//                           child: Column(
//                             spacing: 10,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               HugeIcon(icon: HugeIcons.strokeRoundedNotificationOff01, size: 50),
//                               Text(
//                                 'No notifications received yet',
//                                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                               ),
//                             ],
//                           ),
//                         )
//                         : ListView.separated(
//                           separatorBuilder:
//                               (context, index) => Divider(height: 1, color: Theme.of(context).dividerColor),
//                           itemCount: state.notifications.length,
//                           itemBuilder: (context, index) {
//                             final notification = state.notifications[index];
//                             return NotificationItem(
//                               notification: notification,
//                               isLastItem: index == state.notifications.length - 1,
//                             );
//                           },
//                         )
//                     : state is NotificationLoading
//                     ? Center(child: basicLoadingIndicator())
//                     : Center(
//                       child: Column(
//                         spacing: 10,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           HugeIcon(icon: HugeIcons.strokeRoundedNotificationOff01, size: 50),
//                           Text(
//                             'No notifications received yet',
//                             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                           ),
//                         ],
//                       ),
//                     ),
//           ),
//     );
//   }
// }
