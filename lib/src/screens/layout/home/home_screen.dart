import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/my_user.dart';
import 'package:zinsta/src/blocs/post_blocs/get_post_bloc/get_post_bloc.dart';
import 'package:zinsta/src/blocs/user_blocs/my_user_bloc/my_user_bloc.dart';
import 'package:zinsta/src/components/consts/loading_indicator.dart';
import 'package:zinsta/src/components/post_components/empty_post_message.dart';
import 'package:zinsta/src/components/post_components/post_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => context.read<GetPostBloc>().add(GetPosts()),
      child: BlocBuilder<GetPostBloc, GetPostState>(
        builder: (context, state) {
          if (state is GetPostSuccess) {
            if (state.posts.isEmpty) {
              return emptyPostsWidget();
            }
            return Center(
              child: ListView.builder(
                itemCount: state.posts.length,
                shrinkWrap: true,
                addAutomaticKeepAlives: true,
                itemBuilder: (context, int i) {
                  final user = state.posts[i].myUser;

                  return buildPostWidget(
                    context: context,
                    postTitle: state.posts[i].post,
                    postPicture: state.posts[i].postPicture,
                    profileUsername: state.posts[i].myUser.username,
                    profilePicture: user.picture,
                    profileName: state.posts[i].myUser.name,
                    profileCreatedAt: state.posts[i].createAt,
                    post: state.posts[i],
                    isInProfile: false,
                    author: context.read<MyUserBloc>().state.user ?? MyUser.empty,
                  );
                },
              ),
            );
          } else if (state is GetPostLoading) {
            return basicLoadingIndicator();
          } else {
            return basicLoadingIndicator();
          }
        },
      ),
    );
  }
}
