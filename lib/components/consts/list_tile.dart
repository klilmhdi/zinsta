// import 'dart:io';
//
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';
import 'package:zinsta/components/consts/animations.dart';
// import 'package:zinsta/components/consts/cerificate_icon.dart';
// import 'package:zinsta/components/consts/strings.dart';
import 'package:zinsta/components/consts/user_avatar.dart';
import 'package:zinsta/screens/layout/profile/profile_screen.dart';

Widget buildUserListTileWidget(BuildContext context, {required MyUser user}) => InkWell(
  onTap:
      () => Animations().rtlNavigationAnimation(
        context,
        ProfileScreen(isCurrentUser: false, user: user),
      ),
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            // Stack(
            //   clipBehavior: Clip.none,
            //   alignment: Alignment.topRight,
            //   children: [
            //     user.picture.isEmpty
            //         ? CircleAvatar(
            //           radius: 25,
            //           child: Icon(CupertinoIcons.person, color: Colors.grey.shade400),
            //         )
            //         : CircleAvatar(
            //           radius: 25,
            //           onBackgroundImageError:
            //               (_, __) => Icon(CupertinoIcons.person, color: Colors.grey.shade400),
            //           backgroundImage:
            //               AppStrings.isNetworkImage(user.picture)
            //                   ? CachedNetworkImageProvider(
            //                     user.picture,
            //                     errorListener:
            //                         (_) => Icon(CupertinoIcons.person, color: Colors.grey.shade400),
            //                   )
            //                   : FileImage(File(user.picture)) as ImageProvider,
            //         ),
            //     Positioned(top: -4, right: -4, child: buildCerificateWidget()),
            //   ],
            // ),
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
