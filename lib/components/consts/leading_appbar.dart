import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

Widget buildLeadingAppbarWidget(context) => IconButton(
  onPressed: () => Navigator.pop(context),
  icon: HugeIcon(icon: HugeIcons.strokeRoundedArrowLeft01),
);
