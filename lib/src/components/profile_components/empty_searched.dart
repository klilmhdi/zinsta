import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

Widget buildEmptySearcherWidget() => const Center(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    spacing: 8,
    children: [
      HugeIcon(icon: HugeIcons.strokeRoundedListView, size: 30),
      Text('No users found', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
    ],
  ),
);
