import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:zinsta/src/components/consts/strings.dart';

Widget buildTitleIconWidget({required String title, required IconData icon}) => Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  mainAxisAlignment: MainAxisAlignment.start,
  children: [SizedBox(width: 10), HugeIcon(icon: icon), AppStrings.customText(title)],
);
