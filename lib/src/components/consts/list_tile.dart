import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zinsta/src/components/consts/animations.dart';
import 'package:zinsta/src/components/profile_components/user_avatar.dart';
import 'package:zinsta/src/screens/layout/profile/profile_screen.dart';

import '../../../core/models/my_user.dart';

Widget buildUserListTileWidget(BuildContext context, {required MyUser user}) => InkWell(
  onTap: () => Animations().rtlNavigationAnimation(context, ProfileScreen(isCurrentUser: false, user: user)),
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            buildUserCertifiedAvatarWidget(profilePicture: user.picture),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                RichText(
                  text: TextSpan(
                    text: "@",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: CupertinoColors.systemGrey.highContrastColor,
                    ),
                    children: [
                      TextSpan(
                        text: user.username,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: CupertinoColors.systemGrey.highContrastColor,
                          decoration: TextDecoration.underline,
                          decorationColor: CupertinoColors.systemGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ),
);
