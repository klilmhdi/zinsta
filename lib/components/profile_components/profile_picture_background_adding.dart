import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'dart:ui';

import '../consts/app_color.dart';

Widget buildProfilePictureBackgroundAddingWidget({
  required void Function() onPicturePickedTapped,
  required void Function() onBackgroundPickedTapped,
  required ImageProvider<Object> profilePicture,
  required ImageProvider<Object> profileBackground,
}) => SizedBox(
  height: 300,
  child: Stack(
    alignment: Alignment.bottomCenter,
    children: [
      Align(
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: onBackgroundPickedTapped,
          child: Container(
            margin: const EdgeInsets.all(15),
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppBasicsColors.secondaryColor,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image(image: profileBackground, fit: BoxFit.cover),
                  // BackdropFilter(
                  //   filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  //   child: Container(color: Colors.black.withOpacity(0.2)),
                  // ),
                  const Center(
                    child: Text(
                      "Pick background",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap: onPicturePickedTapped,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              backgroundColor: AppBasicsColors.primaryColor,
              radius: 40,
              backgroundImage: profilePicture,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                radius: 14,
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedCameraAdd03,
                  size: 16,
                  color: CupertinoColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
);
