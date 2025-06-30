import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zinsta/src/components/profile_components/cerificate_icon.dart';

Widget activeUserChatLayoutWidgets() => Padding(
  padding: const EdgeInsets.all(8.0),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      userAvatarIconsWidget(),
      const SizedBox(height: 4),
      SizedBox(
        width: 60,
        child: Text(
          "Hello World",
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        ),
      ),
    ],
  ),
);

Widget userAvatarIconsWidget({double? radius}) => Stack(
  fit: StackFit.loose,
  clipBehavior: Clip.none,
  children: [
    Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topRight,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage('assets/icons/placeholder_profile.png'),
          radius: radius ?? 26,
        ),
        Positioned(right: -3, top: -3, child: buildCertifiedWidget(size: 16)),
      ],
    ),
    Positioned(
      bottom: 1,
      right: -1,
      child: CircleAvatar(radius: 6, backgroundColor: CupertinoColors.systemGreen),
    ),
  ],
);
