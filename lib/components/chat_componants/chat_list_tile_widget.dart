import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zinsta/components/chat_componants/active_users.dart';
import 'package:zinsta/components/consts/animations.dart';

import '../../screens/layout/home/chat/chat_message_page.dart';

Widget chatListTileWidget(
  context, {
  required String id,
  required String profilePicture,
  required String name,
}) => Padding(
  padding: const EdgeInsets.all(5.0),
  child: ListTile(
    onTap: () => Animations().rtlNavigationAnimation(context, ChatMessagePage(id: id)),
    leading: userAvatarIconsWidget(radius: 20),
    title: Text("Name", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
    subtitle: const Text(
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, overflow: TextOverflow.ellipsis),
    ),
    trailing: const CircleAvatar(
      backgroundColor: CupertinoColors.systemRed,
      radius: 15,
      child: Text('9+', style: TextStyle(color: CupertinoColors.white, fontSize: 12)),
    ),
  ),
);
