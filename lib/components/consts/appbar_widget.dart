import 'package:flutter/material.dart';
import 'package:zinsta/components/consts/buttons.dart';
import 'package:zinsta/components/consts/strings.dart';

PreferredSizeWidget buildAppBar(
  context, {
  required int index,
  required void Function() onChatPressed,
  required void Function() onNotificationPressed,
}) => AppBar(
  centerTitle: false,
  elevation: 0,
  backgroundColor: Colors.transparent,
  title: index == 0 ? Text(AppStrings.appTitle, style: TextStyle(fontFamily: AppStrings.specialFont)) : SizedBox(),
  actions:
      index == 0
          ? [
            AppButtons.notificationButton(pressed: onNotificationPressed),
            AppButtons.searchButton(context),
            AppButtons.chatButton(pressed: onChatPressed),
          ]
          : [],
);
