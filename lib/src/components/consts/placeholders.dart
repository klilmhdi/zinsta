import 'package:flutter/material.dart';

Widget buildDefaultAvatar({double? height, double? width}) =>
    Image.asset('assets/icons/placeholder_profile.png', fit: BoxFit.cover, width: width, height: height);

Widget buildDefaultBackground() =>
    Image.asset('assets/images/placeholder_bg.jpg', fit: BoxFit.cover);
