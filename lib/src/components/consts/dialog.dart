import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zinsta/src/components/consts/app_color.dart';
import 'package:zinsta/src/components/consts/loading_indicator.dart';

void customDialog(BuildContext context, {
  required String title,
  required String subtitle,
  required String outlineButtonText,
  required String customButtonText,
  required Future<void> Function() customButtonFunction,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        content: Text(subtitle, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ButtonStyle(
              side: WidgetStatePropertyAll(BorderSide(color: Colors.transparent)),
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
