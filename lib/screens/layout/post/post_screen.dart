import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:post_repository/post_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:zinsta/blocs/post_blocs/edit_post_bloc/edit_post_bloc.dart';
import 'package:zinsta/blocs/post_blocs/edit_post_bloc/edit_post_event.dart';
import 'package:zinsta/components/consts/app_color.dart';
import 'package:zinsta/components/consts/dialog.dart';
import 'package:zinsta/components/consts/shimmer.dart';
import 'package:zinsta/components/consts/snackbars.dart';

import '../../../blocs/cubits/image_handler_cubit/image_handler_cubit.dart';
import '../../../blocs/post_blocs/create_post_bloc/create_post_bloc.dart';

class PostScreen extends StatefulWidget {
  final MyUser myUser;
  final Post? postToEdit;

  const PostScreen(this.myUser, {this.postToEdit, super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late Post post;
  final TextEditingController _controller = TextEditingController();
  XFile? _selectedImage;

  bool get isEditMode => widget.postToEdit != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      final existingPost = widget.postToEdit!;
      post = existingPost;
      _controller.text = existingPost.post;
      if (existingPost.postPicture.isNotEmpty) {
        _selectedImage = XFile(existingPost.postPicture);
      }
    } else {
      post = Post.empty.copyWith(myUser: widget.myUser);
    }
  }

  void _handlePostAction() {
    final updatedPost = post.copyWith(
      post: _controller.text.trim(),
      postPicture: _selectedImage?.path ?? '',
    );

    if (isEditMode) {
      context.read<EditPostBloc>().add(SubmitEditPost(updatedPost));
    } else {
      context.read<CreatePostBloc>().add(CreatePost(updatedPost));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CreatePostBloc, CreatePostState>(
          listener: (context, state) {
            if (state is CreatePostLoading) {
              showLoadingDialog(context);
            } else {
              dismissDialog(context);
            }

            if (state is CreatePostSuccess) {
              Navigator.pop(context, true);
              showCustomSnackBar(
                context: context,
                title: "Post uploaded successfully ✅",
                duration: 3,
                type: MessageType.success,
              );
            }
          },
        ),
        BlocListener<EditPostBloc, EditPostState>(
          listener: (context, state) {
            if (state is EditPostLoading) {
              showLoadingDialog(context);
            } else {
              dismissDialog(context);
            }

            if (state is EditPostSuccess) {
              Navigator.pop(context, true);
              showCustomSnackBar(
                context: context,
                title: "Post updated successfully ✏️",
                duration: 3,
                type: MessageType.success,
              );
            } else if (state is EditPostFailure) {
              showCustomSnackBar(
                context: context,
                title: state.error,
                type: MessageType.error,
                duration: 3,
              );
            }
          },
        ),
        BlocListener<ImageHandlerCubit, ImageHandlerState>(
          listener: (context, state) {
            if (state is ImageHandlerSuccess) {
              setState(() {
                _selectedImage = XFile(state.imagePath);
              });
            } else if (state is ImageHandlerFailure) {
              showCustomSnackBar(
                context: context,
                title: state.error,
                duration: 3,
                type: MessageType.error,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Text(
            isEditMode ? 'Edit Your Post' : 'Create a Post!',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          actions: [
            BlocBuilder<ImageHandlerCubit, ImageHandlerState>(
              builder: (context, state) {
                return IconButton(
                  onPressed:
                      () => context.read<ImageHandlerCubit>().pickProfileImages(
                        context,
                        userId: widget.myUser.id.length,
                        uploadCallback: (path, userId) {},
                      ),
                  icon: const CircleAvatar(
                    backgroundColor: AppBasicsColors.primaryBlue,
                    radius: 19,
                    child: Icon(
                      HugeIcons.strokeRoundedCameraSmile01,
                      color: CupertinoColors.white,
                      size: 18,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              onPressed: _handlePostAction,
              icon: const CircleAvatar(
                backgroundColor: AppBasicsColors.primaryColor,
                radius: 19,
                child: Icon(HugeIcons.strokeRoundedSent, color: CupertinoColors.white, size: 18),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  maxLines: 10,
                  minLines: 5,
                  decoration: const InputDecoration(
                    hintText: "Enter Your Post Here...",
                    border: InputBorder.none,
                  ),
                ),
                if (_selectedImage != null) ...[
                  SizedBox(
                    height: 600,
                    width: double.infinity,
                    child:
                        _selectedImage!.path.startsWith('http')
                            ? CachedNetworkImage(
                              imageUrl: _selectedImage!.path,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => buildShimmer(height: 200),
                            )
                            : Image.file(File(_selectedImage!.path), fit: BoxFit.contain),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
