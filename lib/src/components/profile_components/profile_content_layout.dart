import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinsta/core/models/my_user.dart';
import 'package:zinsta/src/blocs/post_blocs/fetch_user_posts_bloc/fetch_user_posts_bloc.dart';
import 'package:zinsta/src/blocs/user_blocs/follower_following_bloc/follower_bloc.dart';
import 'package:zinsta/src/components/consts/animations.dart';
import 'package:zinsta/src/components/consts/buttons.dart';
import 'package:zinsta/src/components/post_components/empty_post_message.dart';
import 'package:zinsta/src/components/post_components/post_widget.dart';
import 'package:zinsta/src/components/profile_components/profile_details.dart';
import 'package:zinsta/src/screens/layout/profile/edit_profile_screen.dart';
import 'package:zinsta/src/screens/layout/settings/settings_layout.dart';

import '../../blocs/user_blocs/my_user_bloc/my_user_bloc.dart';
import '../consts/loading_indicator.dart';

Widget buildProfileContent(BuildContext context, MyUser user, {required bool isCurrentUser}) {
  // Load initial data
  context.read<FetchUserPostsBloc>().add(LoadUserPosts(userId: user.id));
  if (!isCurrentUser) {
    context.read<FollowersBloc>().add(LoadFollowersCount(user.id));
  }

  return RefreshIndicator(
    onRefresh: () async {
      context.read<FetchUserPostsBloc>().add(LoadUserPosts(userId: user.id));
      if (isCurrentUser) {
        context.read<MyUserBloc>().add(GetMyUser(myUserId: user.id));
      } else {
        context.read<FollowersBloc>().add(LoadFollowersCount(user.id));
      }
    },
    child: BlocBuilder<FetchUserPostsBloc, FetchUserPostsState>(
      builder: (context, postState) {
        return BlocBuilder<FollowersBloc, FollowersState>(
          builder: (context, followersState) {
            final followersCount =
                followersState is FollowersLoaded && followersState.targetUserId == user.id
                    ? followersState.followersCount
                    : 0;
            final followingCount =
                followersState is FollowersLoaded && followersState.targetUserId == user.id
                    ? followersState.followingCount
                    : 0;

            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      profileDetailsWidget(
                        context,
                        background: user.background ?? "",
                        image: user.picture,
                        name: user.name,
                        username: user.username,
                        userId: user.id,
                        bio: user.bio,
                        followerCount: followersCount,
                        followingCount: followingCount,
                        isCurrentUser: isCurrentUser,
                      ),
                      if (!isCurrentUser) FollowAndUnfollowButton(targetUserId: user.id),
                      if (isCurrentUser)
                        ProfileActionButtons(
                          onSettingsPressed: () => Animations().rtlNavigationAnimation(context, SettingLayout()),
                          onEditProfilePressed: () => Animations().rtlNavigationAnimation(context, EditProfileScreen()),
                        ),
                    ],
                  ),
                ),
                if (postState.status == UserPostsStatus.loading)
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: Center(child: basicLoadingIndicator()),
                    ),
                  ),
                if (postState.status == UserPostsStatus.success && postState.posts.isEmpty)
                  SliverToBoxAdapter(
                    child: SizedBox(height: MediaQuery.of(context).size.height * 0.35, child: emptyPostsWidget()),
                  ),
                if (postState.status == UserPostsStatus.success && postState.posts.isNotEmpty)
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final post = postState.posts[index];
                      final postWidget = buildPostWidget(
                        context: context,
                        profilePicture: user.picture,
                        profileName: post.myUser.name,
                        profileUsername: post.myUser.username,
                        profileCreatedAt: post.createAt,
                        postTitle: post.post,
                        postPicture: post.postPicture,
                        isInProfile: true,
                        post: post,
                        author: user,
                      );

                      if (index == 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
                              child: Text(
                                "Posts (${postState.posts.length})",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                            ),
                            postWidget,
                          ],
                        );
                      }

                      return postWidget;
                    }, childCount: postState.posts.length),
                  ),
                if (postState.status == UserPostsStatus.failure)
                  SliverToBoxAdapter(child: Center(child: Text("فشل في تحميل المنشورات"))),
              ],
            );
          },
        );
      },
    ),
  );
}
