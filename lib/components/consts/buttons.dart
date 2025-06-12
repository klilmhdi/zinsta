import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:user_repository/user_repository.dart';
import 'package:zinsta/blocs/cubits/search_cubit/search_cubit.dart';
import 'package:zinsta/components/consts/animations.dart';
import 'package:zinsta/components/consts/app_color.dart';
import 'package:zinsta/components/consts/shared_perferenced.dart';
import 'package:zinsta/screens/layout/home/search/search_screen.dart';

import '../../blocs/notification_blocs/notificaiton_bloc.dart';
import '../../blocs/user_blocs/follower_following_bloc/follower_bloc.dart';

/// Public buttons
class AppButtons {
  AppButtons._();

  static Widget notificationButton({required void Function() pressed}) =>
      BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          return IconButton(
            onPressed: pressed,
            icon: Stack(
              alignment: Alignment(2.5, -2),
              children: [
                HugeIcon(icon: HugeIcons.strokeRoundedNotification01),
                CircleAvatar(
                  backgroundColor: CupertinoColors.systemRed,
                  radius: 7.8,
                  child: Center(
                    child: Text(
                      "${state is NotificationLoaded ? state.notifications.length : 0}",
                      style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold, fontSize: 8),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );

  static Widget searchButton(BuildContext context) {
    final userRepository = RepositoryProvider.of<UserRepository>(context, listen: false);

    return IconButton(
      onPressed:
          () => Animations().rtlNavigationAnimation(
            context,
            BlocProvider<SearchCubit>(
              create: (_) => SearchCubit(userRepository: userRepository),
              child: const SearchPage(),
            ),
          ),
      icon: HugeIcon(icon: HugeIcons.strokeRoundedUserSearch01),
    );
  }

  static Widget chatButton({required void Function() pressed}) => IconButton(
    onPressed: pressed,
    icon: Stack(
      alignment: Alignment.topRight,
      children: [
        HugeIcon(icon: HugeIcons.strokeRoundedMessageNotification01),
        CircleAvatar(backgroundColor: CupertinoColors.systemRed, radius: 5),
      ],
    ),
  );
}

class LikeButton extends StatefulWidget {
  final bool isLiked;
  final VoidCallback onTap;
  final int likeCount;
  final String postId;

  const LikeButton({
    super.key,
    required this.isLiked,
    required this.onTap,
    required this.likeCount,
    required this.postId,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  late bool _isLiked;
  late int _likeCount;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _likeCount = widget.likeCount;
  }

  @override
  void didUpdateWidget(LikeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLiked != widget.isLiked || oldWidget.likeCount != widget.likeCount) {
      _isLiked = widget.isLiked;
      _likeCount = widget.likeCount;
    }
  }

  Future<void> _animate() async {
    if (_isProcessing) return;
    _isProcessing = true;

    // Update local state immediately
    setState(() {
      _isLiked = !_isLiked;
      _likeCount = _isLiked ? _likeCount + 1 : _likeCount - 1;
    });

    // Trigger the actual like operation
    widget.onTap();

    _isProcessing = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _animate,
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child:
                _isLiked
                    ? Icon(
                      Icons.favorite_rounded,
                      key: const ValueKey('liked'),
                      size: 20,
                      color: CupertinoColors.destructiveRed,
                    )
                    : Icon(Icons.favorite_border_rounded, key: const ValueKey('unliked'), size: 20),
          ),
          const SizedBox(width: 4),
          AnimatedFlipCounter(
            value: _likeCount,
            textStyle: TextStyle(fontWeight: FontWeight.bold, color: _isLiked ? CupertinoColors.destructiveRed : null),
          ),
        ],
      ),
    );
  }
}

// class LikeButton extends StatefulWidget {
//   final bool isLiked;
//   final VoidCallback onTap;
//   final int likeCount;
//   final String postId;
//
//   const LikeButton({
//     super.key,
//     required this.isLiked,
//     required this.onTap,
//     required this.likeCount,
//     required this.postId,
//   });
//
//   @override
//   State<LikeButton> createState() => _LikeButtonState();
// }
//
// class _LikeButtonState extends State<LikeButton> {
//   double _scale = 1.0;
//   bool _isLiked = false;
//   int _likeCount = 0;
//   bool _isProcessing = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _isLiked = widget.isLiked;
//     _likeCount = SharedPrefController().getPostLikesCount(widget.postId);
//   }
//
//   @override
//   void didUpdateWidget(LikeButton oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.isLiked != widget.isLiked || oldWidget.likeCount != widget.likeCount) {
//       _isLiked = widget.isLiked;
//       _likeCount = widget.likeCount;
//     }
//   }
//
//   void _animate() async {
//     if (_isProcessing) return;
//     _isProcessing = true;
//
//     setState(() {
//       _scale = 1.3;
//       _isLiked = !_isLiked;
//       _likeCount = _isLiked ? _likeCount + 1 : _likeCount - 1;
//       SharedPrefController().setPostLikesCount(widget.postId, _likeCount);
//     });
//
//     await Future.delayed(const Duration(milliseconds: 100));
//     setState(() => _scale = 1.0);
//
//     widget.onTap();
//     _isProcessing = false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         _animate();
//         widget.onTap();
//       },
//       child: AnimatedScale(
//         scale: _scale,
//         duration: const Duration(milliseconds: 150),
//         curve: Curves.easeOut,
//         child: Row(
//           children: [
//             _isLiked
//                 ? Icon(Icons.favorite_rounded, size: 20, color: CupertinoColors.destructiveRed)
//                 : HugeIcon(icon: HugeIcons.strokeRoundedFavourite, size: 20),
//             const SizedBox(width: 4),
//             _isLiked
//                 ? AnimatedFlipCounter(
//                   value: _likeCount,
//                   textStyle: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.destructiveRed),
//                 )
//                 : AnimatedFlipCounter(value: _likeCount, textStyle: TextStyle(fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }
// }

/// Basic button
class BasicButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String title;

  const BasicButton({super.key, required this.onPressed, required this.title});

  @override
  State<BasicButton> createState() => _BasicButtonState();
}

class _BasicButtonState extends State<BasicButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateButton(Function() action) => _controller.forward().then((_) {
    _controller.reverse();
    action();
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: ElevatedButton(
        onPressed: () => _animateButton(widget.onPressed),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppBasicsColors.primaryColor,
          foregroundColor: CupertinoColors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        child: Center(child: Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
      ),
    );
  }
}

/// Follow and Unfollow buttons with animation
class FollowAndUnfollowButton extends StatefulWidget {
  final String targetUserId;

  const FollowAndUnfollowButton({super.key, required this.targetUserId});

  @override
  _FollowAndUnfollowButtonState createState() => _FollowAndUnfollowButtonState();
}

class _FollowAndUnfollowButtonState extends State<FollowAndUnfollowButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final pref = SharedPrefController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleFollow() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;
    // Get current counts
    final currentFollowers = pref.getUserFollowersCount(widget.targetUserId);
    final currentFollowing = pref.getUserFollowingCount(currentUserId);

    // Update local state immediately
    pref.setUserFollowersCount(widget.targetUserId, currentFollowers + 1);
    pref.setUserFollowingCount(currentUserId, currentFollowing + 1);
    context.read<FollowersBloc>().add(FollowUser(widget.targetUserId));
    context.read<NotificationBloc>().add(
      SendFollowNotification(senderId: currentUserId, receiverId: widget.targetUserId),
    );
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> _handleUnfollow() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    // Get current counts
    final currentFollowers = pref.getUserFollowersCount(widget.targetUserId);
    final currentFollowing = pref.getUserFollowingCount(currentUserId);

    // Update local state immediately
    pref.setUserFollowersCount(widget.targetUserId, currentFollowers - 1);
    pref.setUserFollowingCount(currentUserId, currentFollowing - 1);
    context.read<FollowersBloc>().add(UnfollowUser(widget.targetUserId));
    await Future.delayed(const Duration(seconds: 2));
  }

  Widget _buildFollowButton() {
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) {
        _animationController.reverse();
        _handleFollow();
      },
      onTapCancel: () => _animationController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppBasicsColors.primaryBlue, AppBasicsColors.secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                HugeIcon(icon: HugeIcons.strokeRoundedUserAdd02, color: CupertinoColors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Follow',
                  style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnfollowOptions() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTapDown: (_) => _animationController.forward(),
            onTapUp: (_) => _animationController.reverse(),
            onTapCancel: () => _animationController.reverse(),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                height: 48,
                decoration: BoxDecoration(color: CupertinoColors.systemGrey5, borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HugeIcon(icon: HugeIcons.strokeRoundedMessage02, color: CupertinoColors.black, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Message',
                        style: TextStyle(color: CupertinoColors.black, fontSize: 14.6, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTapDown: (_) => _animationController.forward(),
            onTapUp: (_) => _animationController.reverse(),
            onTapCancel: () => _animationController.reverse(),
            onTap: _handleUnfollow,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: CupertinoColors.destructiveRed.darkColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HugeIcon(icon: HugeIcons.strokeRoundedUserRemove02, color: CupertinoColors.white, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Unfollow',
                        style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowersBloc, FollowersState>(
      builder: (context, state) {
        if (state is FollowersLoaded && state.targetUserId == widget.targetUserId) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: state.isFollowing ? _buildUnfollowOptions() : _buildFollowButton(),
            ),
          );
        }
        return const SizedBox(height: 48, child: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

/// Edit profile and Settings buttons
class ProfileActionButtons extends StatefulWidget {
  final VoidCallback onSettingsPressed;
  final VoidCallback onEditProfilePressed;

  const ProfileActionButtons({super.key, required this.onSettingsPressed, required this.onEditProfilePressed});

  @override
  _ProfileActionButtonsState createState() => _ProfileActionButtonsState();
}

class _ProfileActionButtonsState extends State<ProfileActionButtons> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateButton(Function() action) => _controller.forward().then((_) {
    _controller.reverse();
    action();
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: ElevatedButton(
                onPressed: () => _animateButton(widget.onSettingsPressed),
                style: ElevatedButton.styleFrom(
                  foregroundColor: CupertinoColors.black,
                  backgroundColor: CupertinoColors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: Row(
                  spacing: 5,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HugeIcon(icon: HugeIcons.strokeRoundedSettings02, size: 20, color: CupertinoColors.black),
                    Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: ElevatedButton(
                onPressed: () => _animateButton(widget.onEditProfilePressed),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppBasicsColors.primaryBlue,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: Row(
                  spacing: 5,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HugeIcon(icon: HugeIcons.strokeRoundedUserSettings02, size: 20, color: CupertinoColors.white),
                    Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
