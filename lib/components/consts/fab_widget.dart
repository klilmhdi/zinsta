import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:notification_repository/notification_repository.dart';
import 'package:post_repository/post_repository.dart';
import 'package:zinsta/blocs/post_blocs/create_post_bloc/create_post_bloc.dart';
import 'package:zinsta/blocs/user_blocs/my_user_bloc/my_user_bloc.dart';
import 'package:zinsta/components/consts/animations.dart';
import 'package:zinsta/components/consts/app_color.dart';
import 'package:zinsta/screens/layout/post/post_screen.dart';

Widget buildFABWidget() => BlocBuilder<MyUserBloc, MyUserState>(
  builder: (context, state) {
    if (state.status == MyUserStatus.success) {
      return FloatingActionButton(
        backgroundColor: AppBasicsColors.softViolet,
        elevation: 0,
        shape: CircleBorder(),
        onPressed:
            () => Animations().navFromBottomToTopAnimation(
              context,
              BlocProvider<CreatePostBloc>(
                create:
                    (context) => CreatePostBloc(
                      postRepository: FirebasePostRepository(notificationRepository: OneSignalNotificationRepository()),
                    ),
                child: PostScreen(state.user!),
              ),
            ),
        child: HugeIcon(icon: HugeIcons.strokeRoundedImageAdd02, color: AppBasicsColors.lightBackground),
      );
    } else {
      return const FloatingActionButton(onPressed: null, child: CircularProgressIndicator());
    }
  },
);
