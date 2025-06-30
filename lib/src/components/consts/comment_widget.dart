import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:zinsta/core/models/my_user.dart';
import 'package:zinsta/core/models/post.dart';
import 'package:zinsta/src/components/consts/app_color.dart';
import 'package:zinsta/src/components/consts/loading_indicator.dart';
import 'package:zinsta/src/components/consts/snackbars.dart';
import 'package:zinsta/src/components/consts/strings.dart';
import 'package:zinsta/src/components/consts/text_form_field.dart';
import 'package:zinsta/src/components/profile_components/user_avatar.dart';

import '../../blocs/post_blocs/like_comment_cubit/like_comment_cubit.dart';
import '../../blocs/post_blocs/like_comment_cubit/like_comment_state.dart';

class CommentBottomSheet extends StatelessWidget {
  final Post post;
  final MyUser currentUser;

  const CommentBottomSheet({super.key, required this.post, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    final commentController = TextEditingController();

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        color: Theme.of(context).cardColor,
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.55,
        child: BlocConsumer<LikesCommentsCubit, LikesCommentsState>(
          listener: (context, state) {
            if (state is CommentsSuccessState) {
              commentController.clear();
              FocusScope.of(context).unfocus();
            } else if (state is CommentsFailedState) {
              showCustomSnackBar(
                context: context,
                title: "فشل إرسال التعليق: ${state.error}",
                duration: 3,
                type: MessageType.error,
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is CommentsLoadingState;
            if (state is CommentsLoadingState) {
              basicLoadingIndicator();
            }

            return Column(
              children: [
                const Text("Comments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: post.comments.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final comment = post.comments[index];
                      return ListTile(
                        leading: buildUserCertifiedAvatarWidget(profilePicture: comment.author.picture),
                        title: Text(comment.author.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(comment.text, style: const TextStyle(fontWeight: FontWeight.w500)),
                        trailing: Text(
                          "${AppStrings.getEnglishTimeAgo(comment.createdAt)} ago",
                          style: const TextStyle(fontSize: 13, color: AppBasicsColors.softViolet),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: buildTextFormFieldWidget(
                        context,
                        controller: commentController,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        hintText: 'Write a comment...',
                      ),
                    ),
                    isLoading
                        ? const CupertinoActivityIndicator()
                        : IconButton(
                          icon: const HugeIcon(icon: HugeIcons.strokeRoundedSent02),
                          onPressed: () {
                            if (commentController.text.trim().isNotEmpty) {
                              context.read<LikesCommentsCubit>().addComment(
                                context,
                                post: post,
                                author: currentUser,
                                text: commentController.text.trim(),
                              );
                            }
                          },
                        ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
