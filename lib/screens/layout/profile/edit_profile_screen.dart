import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:zinsta/blocs/cubits/image_handler_cubit/image_handler_cubit.dart';
import 'package:zinsta/blocs/user_blocs/my_user_bloc/my_user_bloc.dart';
import 'package:zinsta/blocs/user_blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:zinsta/components/consts/app_color.dart';
import 'package:zinsta/components/consts/dialog.dart';
import 'package:zinsta/components/consts/snackbars.dart';
import 'package:zinsta/components/profile_components/profile_editing_form.dart';
import 'package:zinsta/components/profile_components/profile_picture_background_adding.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController bioController;
  late TextEditingController usernameController;

  String? profileImagePath;
  String? backgroundImagePath;

  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = context.read<MyUserBloc>().state.user!;
    nameController = TextEditingController(text: user.name);
    emailController = TextEditingController(text: user.email);
    bioController = TextEditingController(text: user.bio);
    usernameController = TextEditingController(text: user.username);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<MyUserBloc>().state.user!;
    return BlocProvider(
      create: (_) => ImageHandlerCubit(),
      child: BlocListener<ImageHandlerCubit, ImageHandlerState>(
        listener: (context, state) {
          if (state is ImageHandlerSuccess) {
            if (state.imagePath.contains("profile")) {
              profileImagePath = state.imagePath;
            } else {
              backgroundImagePath = state.imagePath;
            }
          } else if (state is ImageHandlerFailure) {
            showCustomSnackBar(context: context, title: state.error, duration: 3, type: MessageType.error);
          }
        },
        child: BlocConsumer<UpdateUserInfoBloc, UpdateUserInfoState>(
          listener: (context, state) {
            if (state is UpdateUserInfoSuccess) {
              showCustomSnackBar(
                context: context,
                title: "Profile editing successfully ✅",
                duration: 3,
                type: MessageType.success,
              );
              Navigator.pop(context);
            } else if (state is UpdateUserInfoFailure) {
              showCustomSnackBar(
                context: context,
                title: "Something happened error, try again!",
                duration: 3,
                type: MessageType.error,
              );
            }

            if (state is UpdateUserInfoLoading) {
              showLoadingDialog(context);
            } else {
              dismissDialog(context);
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                leading: BackButton(),
                backgroundColor: Colors.transparent,
                title: const Text("Edit Profile Info"),
                actions: [
                  IconButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<UpdateUserInfoBloc>().add(
                          EditUserData(
                            userId: user.id,
                            name: nameController.text,
                            username: usernameController.text,
                            email: emailController.text,
                            bio: bioController.text,
                            profileImagePath: profileImagePath,
                            backgroundImagePath: backgroundImagePath,
                          ),
                        );
                      }
                    },
                    icon: const CircleAvatar(
                      backgroundColor: AppBasicsColors.primaryColor,
                      child: Icon(HugeIcons.strokeRoundedCheckmarkCircle01, color: Colors.white),
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    buildProfilePictureBackgroundAddingWidget(
                      onPicturePickedTapped: () {
                        context.read<ImageHandlerCubit>().pickProfileImages(
                          context,
                          userId: user.id.length,
                          uploadCallback: (path, id) {
                            setState(() => profileImagePath = path);
                          },
                        );
                      },
                      onBackgroundPickedTapped: () {
                        context.read<ImageHandlerCubit>().pickProfileImages(
                          context,
                          userId: user.id.length,
                          uploadCallback: (path, id) {
                            setState(() => backgroundImagePath = path);
                          },
                          aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
                        );
                      },
                      profilePicture:
                          profileImagePath != null
                              ? FileImage(File(profileImagePath!))
                              : (user.picture.isNotEmpty
                                      ? NetworkImage(user.picture)
                                      : const AssetImage('assets/icons/placeholder_profile.png'))
                                  as ImageProvider,

                      profileBackground:
                          backgroundImagePath != null
                              ? FileImage(File(backgroundImagePath!))
                              : (user.background != null && user.background!.isNotEmpty
                                      ? NetworkImage(user.background!)
                                      : const AssetImage('assets/images/placeholder_bg.jpg'))
                                  as ImageProvider,
                    ),
                    buildProfileEditingFormWidget(
                      context,
                      formKey: formKey,
                      nameController: nameController,
                      emailController: emailController,
                      usernameController: usernameController,
                      bioController: bioController,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
