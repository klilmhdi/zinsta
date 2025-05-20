import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmer({double? height, double? width}) => Shimmer.fromColors(
  baseColor: Colors.grey[300]!,
  highlightColor: Colors.grey[100]!,
  child: Container(
    color: Colors.white,
    width: width ?? double.infinity,
    height: height ?? double.infinity,
  ),
);
