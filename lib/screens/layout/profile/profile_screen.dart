import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:zinsta/blocs/user_blocs/my_user_bloc/my_user_bloc.dart';
import 'package:zinsta/components/consts/loading_indicator.dart';
import 'package:zinsta/components/profile_components/profile_content_layout.dart';

class ProfileScreen extends StatelessWidget {
  final bool isCurrentUser;
  final MyUser? user;

  const ProfileScreen({super.key, required this.isCurrentUser, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isCurrentUser
              ? _buildCurrentUserProfile(context)
              : _buildRemoteUserProfile(context, user!),
    );
  }

  Widget _buildCurrentUserProfile(BuildContext context) => BlocBuilder<MyUserBloc, MyUserState>(
    builder: (context, userState) {
      if (userState.status == MyUserStatus.success) {
        return buildProfileContent(context, userState.user!, isCurrentUser: isCurrentUser);
      } else if (userState.status == MyUserStatus.loading) {
        return basicLoadingIndicator();
      }
      return Center(child: Text("Error"));
    },
  );

  Widget _buildRemoteUserProfile(BuildContext context, MyUser user) =>
      buildProfileContent(context, user, isCurrentUser: isCurrentUser);
}
