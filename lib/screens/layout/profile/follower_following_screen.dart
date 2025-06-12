import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_repository/notification_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:zinsta/blocs/user_blocs/follower_following_bloc/follower_bloc.dart';
import 'package:zinsta/components/consts/list_tile.dart';
import 'package:zinsta/components/consts/loading_indicator.dart';
import 'package:zinsta/components/profile_components/empty_follower_following.dart';

class FollowersFollowingsScreen extends StatelessWidget {
  final String userId;

  const FollowersFollowingsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: BlocProvider(
      create: (_) => FollowersBloc(userRepository: FirebaseUserRepository(notificationRepository: OneSignalNotificationRepository())),
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          leadingWidth: 40,
          title: const Text("Friends", style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            tabs: [Tab(text: 'Followers'), Tab(text: 'Followings')],
            dividerColor: Colors.transparent,
          ),
        ),
        body: TabBarView(children: [_FollowersTab(userId: userId), _FollowingTab(userId: userId)]),
      ),
    ),
  );
}

// class _FollowersTab extends StatelessWidget {
//   final String userId;
//
//   const _FollowersTab({required this.userId});
//
//   @override
//   Widget build(BuildContext context) {
//     context.read<FollowersBloc>().add(LoadFollowers(userId));
//
//     return BlocBuilder<FollowersBloc, FollowersState>(
//       builder: (context, state) {
//         if (state is GetFollowerLoading) {
//           return basicLoadingIndicator();
//         } else if (state is GetFollowerLoaded) {
//           if (state.users.isEmpty) {
//             return buildEmptyFollowerFollowingWidget(true);
//           }
//           return ListView.builder(
//             physics: const AlwaysScrollableScrollPhysics(),
//             itemCount: state.users.length,
//             itemBuilder: (context, index) {
//               final user = state.users[index];
//               return buildUserListTileWidget(context, user: user);
//             },
//           );
//         } else if (state is GetFollowerError) {
//           return Center(child: Text('خطأ: ${state.error}'));
//         }
//         return buildEmptyFollowerFollowingWidget(true);
//       },
//     );
//   }
// }

class _FollowersTab extends StatefulWidget {
  final String userId;
  const _FollowersTab({required this.userId});

  @override
  State<_FollowersTab> createState() => _FollowersTabState();
}

class _FollowersTabState extends State<_FollowersTab> {
  @override
  void initState() {
    super.initState();
    context.read<FollowersBloc>().add(LoadFollowers(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowersBloc, FollowersState>(
      builder: (context, state) {
        if (state is GetFollowerLoading) {
          return basicLoadingIndicator();
        } else if (state is GetFollowerLoaded) {
          if (state.users.isEmpty) {
            return buildEmptyFollowerFollowingWidget(true);
          }
          return ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];
              return buildUserListTileWidget(context, user: user);
            },
          );
        } else if (state is GetFollowerError) {
          return Center(child: Text('خطأ: ${state.error}'));
        }
        return buildEmptyFollowerFollowingWidget(true);
      },
    );
  }
}
class _FollowingTab extends StatefulWidget {
  final String userId;
  const _FollowingTab({required this.userId});

  @override
  State<_FollowingTab> createState() => _FollowingTabState();
}

class _FollowingTabState extends State<_FollowingTab> {
  @override
  void initState() {
    super.initState();
    context.read<FollowersBloc>().add(LoadFollowing(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowersBloc, FollowersState>(
      builder: (context, state) {
        if (state is GetFollowerLoading) {
          return basicLoadingIndicator();
        } else if (state is GetFollowingLoaded) {
          if (state.users.isEmpty) {
            return buildEmptyFollowerFollowingWidget(false);
          }
          return ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];
              return buildUserListTileWidget(context, user: user);
            },
          );
        } else if (state is GetFollowingError) {
          return Center(child: Text('خطأ: ${state.error}'));
        }
        return buildEmptyFollowerFollowingWidget(false);
      },
    );
  }
}

// class _FollowingTab extends StatelessWidget {
//   final String userId;
//
//   const _FollowingTab({required this.userId});
//
//   @override
//   Widget build(BuildContext context) {
//     context.read<FollowersBloc>().add(LoadFollowing(userId));
//
//     return BlocBuilder<FollowersBloc, FollowersState>(
//       builder: (context, state) {
//         if (state is GetFollowerLoading) {
//           return basicLoadingIndicator();
//         } else if (state is GetFollowingLoaded) {
//           if (state.users.isEmpty) {
//             return buildEmptyFollowerFollowingWidget(false);
//           }
//           return ListView.builder(
//             itemCount: state.users.length,
//             physics: const AlwaysScrollableScrollPhysics(),
//             itemBuilder: (context, index) {
//               final user = state.users[index];
//               return buildUserListTileWidget(context, user: user);
//             },
//           );
//         } else if (state is GetFollowingError) {
//           return Center(child: Text('خطأ: ${state.error}'));
//         }
//         return buildEmptyFollowerFollowingWidget(false);
//       },
//     );
//   }
// }
