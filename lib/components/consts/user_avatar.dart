import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zinsta/components/consts/cerificate_icon.dart';
import 'package:zinsta/components/consts/placeholders.dart';
import 'package:zinsta/components/consts/shimmer.dart';

Widget buildUserCertifiedAvatarWidget({
  required String profilePicture,
  double? avatarSize,
  double? certifiedSize,
}) => Stack(
  clipBehavior: Clip.none,
  alignment: Alignment.topRight,
  children: [
    Container(
      width: avatarSize ?? 46,
      height: avatarSize ?? 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: CupertinoColors.systemGrey4.highContrastElevatedColor,
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: profilePicture,
          fit: BoxFit.cover,
          placeholder: (context, url) => buildShimmer(),
          errorWidget: (context, url, error) => buildDefaultAvatar(),
        ),
      ),
    ),
    Positioned(top: -2, right: -2, child: buildCertifiedWidget(size: certifiedSize ?? 16)),
  ],
);