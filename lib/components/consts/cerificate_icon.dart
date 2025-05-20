import 'package:flutter/cupertino.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:zinsta/components/consts/app_color.dart';

Widget buildCertifiedWidget({double? size}) => Container(
  decoration: BoxDecoration(
    color: AppBasicsColors.primaryBlue,
    shape: BoxShape.circle,
    border: Border.all(color: AppBasicsColors.lightBackground, width: 0.06),
  ),
  child: HugeIcon(
    icon: HugeIcons.strokeRoundedCheckmarkCircle03,
    color: CupertinoColors.white,
    size: size ?? 20,
  ),
);
