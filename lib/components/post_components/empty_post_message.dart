import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

Widget emptyPostsWidget() => const Center(
  heightFactor: 1.4,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    spacing: 8,
    children: [
      HugeIcon(icon: HugeIcons.strokeRoundedCameraOff02, size: 50),
      Text(
        'No posts yet',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    ],
  ),
);
