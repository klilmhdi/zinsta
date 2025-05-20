import 'package:flutter/cupertino.dart';
import 'package:hugeicons/hugeicons.dart';

Widget buildEmptyFollowerFollowingWidget(bool isFollower) => Column(
  crossAxisAlignment: CrossAxisAlignment.center,
  mainAxisAlignment: MainAxisAlignment.center,
  spacing: 8,
  children: [
    HugeIcon(icon: HugeIcons.strokeRoundedCancelCircle, size: 70, color: CupertinoColors.destructiveRed,),
    Text(
      'No ${isFollower ? "Followers" : "Followings"} yet',
      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
    ),
  ],
);
