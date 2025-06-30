import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:zinsta/src/repo/firebase_post_repository.dart';
import 'package:zinsta/src/repo/onesignal_notification_repository.dart';
import 'package:zinsta/src/blocs/cubits/app_cubit/app_cubit.dart';
import 'package:zinsta/src/blocs/user_blocs/my_user_bloc/my_user_bloc.dart';
import 'package:zinsta/src/components/consts/app_color.dart';

import '../../blocs/post_blocs/create_post_bloc/create_post_bloc.dart';
import '../../screens/layout/post/post_screen.dart';
import 'animations.dart';

Widget buildBottomNavBar({
  required List<NavigationModel> items,
  required int currentIndex,
  required ValueChanged<int> onTap,
}) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: List.generate(3, (index) {
      if (index == 1) {
        return BlocBuilder<MyUserBloc, MyUserState>(
          builder: (context, state) {
            if (state.status == MyUserStatus.success) {
              return GestureDetector(
                onTap:
                    () => Animations().navFromBottomToTopAnimation(
                      context,
                      BlocProvider<CreatePostBloc>(
                        create: (context) => CreatePostBloc(postRepository: FirebasePostRepository(notificationRepository: OneSignalNotificationRepository())),
                        child: PostScreen(state.user!),
                      ),
                    ),
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: AppBasicsColors.primaryColor, blurRadius: 6),
                      BoxShadow(color: AppBasicsColors.secondaryColor, blurRadius: 2),
                      BoxShadow(color: AppBasicsColors.primaryColor, blurRadius: 3),
                    ],
                    gradient: LinearGradient(
                      begin: Alignment(-0, 3),
                      end: Alignment(-4, -2),
                      colors: [
                        AppBasicsColors.primaryColor,
                        AppBasicsColors.secondaryColor.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                  child: HugeIcon(icon: HugeIcons.strokeRoundedLayerAdd, color: CupertinoColors.white, size: 18),
                ),
              );
            } else {
              return CupertinoActivityIndicator();
            }
          },
        );
      } else {
        int mappedIndex = index == 0 ? 0 : 1;
        bool isSelected = currentIndex == mappedIndex;

        return Flexible(
          child: GestureDetector(
            onTap: () => onTap(mappedIndex),
            child: Container(
              width: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.transparent,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                spacing: 5,
                children: [
                  HugeIcon(
                    icon: items[mappedIndex].icon.icon,
                    color: !isSelected ? AppBasicsColors.primaryColor : AppBasicsColors.secondaryColor,
                    size: isSelected ? 20 : 28,
                  ),
                  Text(
                    !isSelected ? "" : items[mappedIndex].label,
                    style: TextStyle(color: !isSelected ? AppBasicsColors.primaryColor : AppBasicsColors.secondaryColor),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }),
  ),
);
