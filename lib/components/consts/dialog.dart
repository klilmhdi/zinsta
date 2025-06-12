import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:zinsta/components/consts/app_color.dart';
import 'package:zinsta/components/consts/loading_indicator.dart';

void customDialog(BuildContext context, {
  required String title,
  required String subtitle,
  required String outlineButtonText,
  required String customButtonText,
  required IconData icon,
  required Future<void> Function() customButtonFunction,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(subtitle),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        icon: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(shape: BoxShape.circle, color: CupertinoColors.destructiveRed),
          child: Center(child: HugeIcon(icon: icon, color: CupertinoColors.white, size: 30)),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              side: WidgetStatePropertyAll(BorderSide(width: 2, color: AppBasicsColors.darkCardColor)),
            ),
            child: Text(outlineButtonText),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: const WidgetStatePropertyAll(AppBasicsColors.primaryColor),
              shape: WidgetStatePropertyAll(ContinuousRectangleBorder(borderRadius: BorderRadius.circular(14))),
            ),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await customButtonFunction();
            },
            child: Text(customButtonText, style: TextStyle(color: CupertinoColors.white)),
          ),
        ],
      );
    },
  );
}

void showLoadingDialog(BuildContext context) =>
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: basicLoadingIndicator()),
    );

void dismissDialog(BuildContext context) {
  if (Navigator.canPop(context)) Navigator.pop(context);
}
