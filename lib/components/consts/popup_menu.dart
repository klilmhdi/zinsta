import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:zinsta/components/consts/app_color.dart';

enum PostAction { edit, delete }

Widget buildPostMenuWidget({required void Function(PostAction action) onSelected}) =>
    PopupMenuButton<PostAction>(
      icon: const HugeIcon(icon: HugeIcons.strokeRoundedMoreVertical),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 8,
      itemBuilder:
          (context) => [
            PopupMenuItem(
              value: PostAction.edit,
              child: Row(
                spacing: 5,
                children: const [
                  HugeIcon(icon: HugeIcons.strokeRoundedPencilEdit02, size: 18),
                  Text("Edit Post", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            PopupMenuItem(
              value: PostAction.delete,
              child: Row(
                spacing: 5,
                children: const [
                  HugeIcon(icon: HugeIcons.strokeRoundedDelete02, size: 18, color: CupertinoColors.systemRed),
                  Text("Delete Post", style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.systemRed)),
                ],
              ),
            ),
          ],
      onSelected: onSelected,
    );
