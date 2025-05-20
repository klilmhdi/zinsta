import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:post_repository/post_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:zinsta/blocs/cubits/like_comment_cubit/like_comment_cubit.dart';
import 'package:zinsta/blocs/cubits/like_comment_cubit/like_comment_state.dart';
import 'package:zinsta/blocs/post_blocs/delete_post_bloc/delete_user_bloc.dart';
import 'package:zinsta/components/consts/animations.dart';
import 'package:zinsta/components/consts/app_color.dart';
import 'package:zinsta/components/consts/buttons.dart';

import 'package:zinsta/components/consts/dialog.dart';
import 'package:zinsta/components/consts/popup_menu.dart';
import 'package:zinsta/components/consts/shimmer.dart';
import 'package:zinsta/components/consts/strings.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:zinsta/components/consts/user_avatar.dart';
import 'package:zinsta/screens/layout/post/post_screen.dart';

import '../consts/comment_widget.dart';

Widget buildPostWidget({
  required BuildContext context,
  required String profilePicture,
  required String profileName,
  required String profileUsername,
  required DateTime profileCreatedAt,
  required String postTitle,
  required String postPicture,
  required bool isInProfile,
  required Post post,
  required MyUser author,
}) => Container(
  width: double.infinity,
  decoration: BoxDecoration(color: Theme.of(context).cardColor),
  margin: const EdgeInsets.symmetric(vertical: 2.0),
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _profileDetailsWidget(
          context: context,
          profilePicture: profilePicture,
          profileName: profileName,
          profileUsername: profileUsername,
          profileCreatedAt: profileCreatedAt,
          isInProfile: isInProfile,
          post: post,
        ),
        _postBodyWidget(context: context, postText: postTitle, postPicture: postPicture),
        Divider(thickness: 4, color: Theme.of(context).dividerColor),
        BlocBuilder<LikesCommentsCubit, LikesCommentsState>(
          builder: (context, state) {
            return buildReactButtonsWidget(context, post, author);
          },
        ),
      ],
    ),
  ),
);

Widget _profileDetailsWidget({
  required BuildContext context,
  required String profilePicture,
  required String profileName,
  required String profileUsername,
  required DateTime profileCreatedAt,
  required bool isInProfile,
  required Post post,
}) => Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Row(
      children: [
        buildUserCertifiedAvatarWidget(profilePicture: profilePicture),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  profileName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(width: 20),
              ],
            ),
            RichText(
              text: TextSpan(
                text: "@",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: CupertinoColors.systemGrey.highContrastColor,
                ),
                children: [
                  TextSpan(
                    text: profileUsername,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: CupertinoColors.systemGrey.highContrastColor,
                      decoration: TextDecoration.underline,
                      decorationColor: CupertinoColors.systemGrey,
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 5)),
                  const TextSpan(text: "○ "),
                  WidgetSpan(child: Visibility(visible: post.isEdited, child: _editedText())),
                  TextSpan(
                    text: AppStrings.getEnglishTimeAgo(profileCreatedAt),
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: CupertinoColors.systemGrey.highContrastColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
    isInProfile == true
        ? buildPostMenuWidget(
          onSelected: (action) {
            if (action == PostAction.edit) {
              Animations().rtlNavigationAnimation(
                context,
                PostScreen(post.myUser, postToEdit: post),
              );
            } else if (action == PostAction.delete) {
              customDialog(
                context,
                title: "Delete post!",
                subtitle: "Are you sure wanna delete this post?",
                outlineButtonText: "Cancel",
                customButtonText: "Delete",
                icon: HugeIcons.strokeRoundedDelete01,
                customButtonFunction:
                    () async => context.read<DeletePostBloc>().add(SubmitDeletePost(post)),
              );
            }
          },
        )
        : const SizedBox(),
  ],
);

Widget _postBodyWidget({
  required BuildContext context,
  required String postText,
  required String postPicture,
}) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 5.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (postText.isNotEmpty) ...[
        Text(postText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 10),
      ],
      if (postPicture.isNotEmpty) ...[
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: postPicture,
            fit: BoxFit.contain,
            width: double.infinity,
            placeholder: (context, url) => buildShimmer(height: 200),
            errorWidget:
                (context, url, error) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: Center(child: HugeIcon(icon: HugeIcons.strokeRoundedCameraOff02)),
                ),
          ),
        ),
      ],
    ],
  ),
);

Widget buildReactButtonsWidget(BuildContext context, Post post, MyUser currentUser) {
  final isLiked = post.likes.any((user) => user.id == currentUser.id);
  final likeCount = post.likes.length;
  final commentsCount = post.comments.length;

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      LikeButton(
        isLiked: isLiked,
        onTap: () => context.read<LikesCommentsCubit>().toggleLike(post, currentUser),
        likeCount: likeCount,
      ),
      InkWell(
        onTap:
            () => showModalBottomSheet(
              context: context,
              isDismissible: false,
              enableDrag: true,
              showDragHandle: true,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => CommentBottomSheet(post: post, currentUser: currentUser),
            ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 4,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedComment03,
              size: 18,
              color: AppBasicsColors.primaryBlue,
            ),
            AnimatedFlipCounter(
              value: commentsCount,
              textStyle: TextStyle(fontWeight: FontWeight.bold, color: AppBasicsColors.primaryBlue),
            ),
          ],
        ),
      ),
      HugeIcon(
        icon: HugeIcons.strokeRoundedShare05,
        size: 18,
        color: AppBasicsColors.secondaryColor,
      ),
      HugeIcon(
        icon: HugeIcons.strokeRoundedAllBookmark,
        size: 18,
        color: AppBasicsColors.primaryColor,
      ),
    ],
  );
}

Widget _editedText() => Row(
  children: [
    RichText(
      text: TextSpan(
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: CupertinoColors.systemGrey.highContrastColor,
        ),
        children: const [TextSpan(text: "Edited"), TextSpan(text: " ○ ")],
      ),
    ),
  ],
);
