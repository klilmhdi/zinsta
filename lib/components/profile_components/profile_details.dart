import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinsta/blocs/user_blocs/follower_following_bloc/follower_bloc.dart';
import 'package:zinsta/components/consts/animations.dart';
import 'package:zinsta/components/consts/app_color.dart';
import 'package:zinsta/components/consts/placeholders.dart';
import 'package:zinsta/components/consts/shimmer.dart';
import 'package:zinsta/components/consts/user_avatar.dart';
import 'package:zinsta/screens/layout/profile/follower_following_screen.dart';

Widget profileDetailsWidget(
  BuildContext context, {
  required String background,
  required String image,
  required String name,
  required String username,
  required String userId,
  required int followerCount,
  required int followingCount,
  String? bio,
}) {
  if (userId != FirebaseAuth.instance.currentUser?.uid) {
    context.read<FollowersBloc>().add(LoadFollowersCount(userId));
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: 360,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 330,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  shape: BoxShape.rectangle,
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: background,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => buildShimmer(),
                    errorWidget: (context, url, error) => buildDefaultBackground(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: CircleAvatar(
                  radius: 38,
                  backgroundColor: AppBasicsColors.lightBackground,
                  child: buildUserCertifiedAvatarWidget(
                    profilePicture: image,
                    avatarSize: 70,
                    certifiedSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 4),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: RichText(
          text: TextSpan(
            text: "@",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: CupertinoColors.systemGrey.highContrastColor,
            ),
            children: [
              TextSpan(
                text: username,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: CupertinoColors.systemGrey.highContrastColor,
                  decoration: TextDecoration.underline,
                  decorationColor: CupertinoColors.systemGrey,
                ),
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child:
            bio != ''
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      maxLines: bio != '' ? 12 : 1,
                      overflow: bio != '' ? TextOverflow.ellipsis : TextOverflow.visible,
                      bio ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: bio != '' ? 15 : 12,
                        color: CupertinoColors.systemGrey2.highContrastElevatedColor,
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      overflow: TextOverflow.ellipsis,
                      "Write your awesome Bio from Edit profile 🌟",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: CupertinoColors.systemGrey2,
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
      ),
      InkWell(
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,

        /// navigate to FollowerFollowingScreen
        onTap:
            () => Animations().rtlNavigationAnimation(
              context,
              FollowersFollowingsScreen(userId: userId),
            ),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            spacing: 4,
            children: [
              Row(
                children: [
                  Text(
                    "Follower: ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  AnimatedFlipCounter(
                    value: followerCount,
                    textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text("."),
              Row(
                children: [
                  Text(
                    "Following: ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  AnimatedFlipCounter(
                    value: followingCount,
                    textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 10),
    ],
  );
}
