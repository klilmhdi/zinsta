import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:zinsta/src/components/consts/app_color.dart';

enum MessageType { success, error, info }

void showCustomSnackBar({
  required BuildContext context,
  required String title,
  required int duration,
  required MessageType type,
}) {
  Color backgroundColor;
  IconData icon;

  switch (type) {
    case MessageType.success:
      backgroundColor = CupertinoColors.activeGreen;
      icon = HugeIcons.strokeRoundedCheckmarkCircle01;
      break;
    case MessageType.error:
      backgroundColor = CupertinoColors.destructiveRed;
      icon = HugeIcons.strokeRoundedCancelCircle;
      break;
    case MessageType.info:
      backgroundColor = AppBasicsColors.primaryColor;
      icon = HugeIcons.strokeRoundedInformationCircle;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: duration),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.all(15),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          HugeIcon(icon: icon, color: Colors.white, size: 30),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.fade,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// void defaultCustomSnackBar(context, {required String content}) =>
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(content)),
//     );
//
