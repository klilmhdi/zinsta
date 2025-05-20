import 'package:flutter/material.dart';

class AppStrings {
  AppStrings._();

  /// Regs
  static RegExp emailRexExp = RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$');

  static RegExp passwordRexExp = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$',
  );

  static RegExp specialCharRexExp = RegExp(r'^(?=.*?[!@#$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^])');

  /// get time ago in Arabic
  static String getArabicTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return "منذ لحظات";
    } else if (difference.inMinutes < 60) {
      return "منذ ${difference.inMinutes} دقيقة";
    } else if (difference.inHours < 24) {
      return "منذ ${difference.inHours} ساعة";
    } else if (difference.inDays < 30) {
      return "منذ ${difference.inDays} يوم";
    } else if (difference.inDays < 365) {
      return "منذ ${(difference.inDays / 30).floor()} شهر";
    } else {
      return "منذ ${(difference.inDays / 365).floor()} سنة";
    }
  }

  /// get time ago in English
  static String getEnglishTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}min";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h";
    } else if (difference.inDays < 30) {
      return "${difference.inDays}d";
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return "${months}m";
    } else {
      final years = (difference.inDays / 365).floor();
      return "$years year${years == 1 ? '' : 's'} ago";
    }
  }

  /// Conditions to check network image via split https
  static bool isNetworkImage(String imageUrl) =>
      imageUrl.startsWith('http') || imageUrl.startsWith('https');

  /// Const strings
  static const String appTitle = "ZInsta";
  static const String basicFont = 'IBM_Plex_Sans';
  static const String specialFont = 'SpecialGothicExpandedOne';

  /// Const Text styles
  static Widget customText(String text) => Padding(
    padding: EdgeInsets.all(8.0),
    child: Text(
      textAlign: TextAlign.start,
      text,
      style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
    ),
  );
}
