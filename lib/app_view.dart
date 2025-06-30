import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:zinsta/src/blocs/cubits/image_handler_cubit/image_handler_cubit.dart';
import 'package:zinsta/src/blocs/cubits/search_cubit/search_cubit.dart';
import 'package:zinsta/src/blocs/post_blocs/create_post_bloc/create_post_bloc.dart';
import 'package:zinsta/src/blocs/post_blocs/delete_post_bloc/delete_user_bloc.dart';
import 'package:zinsta/src/blocs/post_blocs/edit_post_bloc/edit_post_bloc.dart';
import 'package:zinsta/src/blocs/post_blocs/fetch_user_posts_bloc/fetch_user_posts_bloc.dart';
import 'package:zinsta/src/components/consts/app_style.dart';
import 'package:zinsta/src/components/consts/strings.dart';
import 'package:zinsta/src/repo/firebase_post_repository.dart';
import 'package:zinsta/src/repo/onesignal_notification_repository.dart';
import 'package:zinsta/src/screens/authentication/welcome_screen.dart';

import 'src/blocs/auth_blocs/authentication_bloc/authentication_bloc.dart';
import 'src/blocs/auth_blocs/sign_in_bloc/sign_in_bloc.dart';
import 'src/blocs/cubits/app_cubit/app_cubit.dart';
import 'src/blocs/notification_blocs/notificaiton_bloc.dart';
import 'src/blocs/post_blocs/get_post_bloc/get_post_bloc.dart';
import 'src/blocs/post_blocs/like_comment_cubit/like_comment_cubit.dart';
import 'src/blocs/user_blocs/follower_following_bloc/follower_bloc.dart';
import 'src/blocs/user_blocs/my_user_bloc/my_user_bloc.dart';
import 'src/blocs/user_blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'generated/l10n.dart';
import 'src/screens/layout/layout.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [

        /// BLoCs
        BlocProvider<SignInBloc>(
          create: (context) =>
              SignInBloc(userRepository: context
                  .read<AuthenticationBloc>()
                  .userRepository),
        ),
        BlocProvider<UpdateUserInfoBloc>(
          create: (context) =>
              UpdateUserInfoBloc(userRepository: context
                  .read<AuthenticationBloc>()
                  .userRepository),
        ),
        BlocProvider<MyUserBloc>(
          create:
              (context) =>
          MyUserBloc(myUserRepository: context
              .read<AuthenticationBloc>()
              .userRepository)
            ..add(GetMyUser(myUserId: context
                .read<AuthenticationBloc>()
                .state
                .user!
                .uid)),
        ),
        BlocProvider<FollowersBloc>(
          create:
              (context) =>
          FollowersBloc(userRepository: context
              .read<AuthenticationBloc>()
              .userRepository)
            ..add(LoadFollowersCount(context
                .read<AuthenticationBloc>()
                .state
                .user!
                .uid))..add(LoadFollowing(context
              .read<AuthenticationBloc>()
              .state
              .user!
              .uid))..add(LoadFollowers(context
              .read<AuthenticationBloc>()
              .state
              .user!
              .uid)),
        ),
        BlocProvider<GetPostBloc>(
          create:
              (context) =>
          GetPostBloc(
            postRepository: FirebasePostRepository(notificationRepository: OneSignalNotificationRepository()),
          )
            ..add(GetPosts()),
        ),
        BlocProvider<FetchUserPostsBloc>(
          create:
              (context) =>
              FetchUserPostsBloc(
                postRepository: FirebasePostRepository(notificationRepository: OneSignalNotificationRepository()),
              ),
        ),
        BlocProvider<CreatePostBloc>(
          create:
              (context) =>
              CreatePostBloc(
                postRepository: FirebasePostRepository(notificationRepository: OneSignalNotificationRepository()),
              ),
        ),
        BlocProvider<EditPostBloc>(
          create:
              (context) =>
              EditPostBloc(
                postRepository: FirebasePostRepository(notificationRepository: OneSignalNotificationRepository()),
              ),
        ),
        BlocProvider<DeletePostBloc>(
          create:
              (context) =>
              DeletePostBloc(
                postRepository: FirebasePostRepository(notificationRepository: OneSignalNotificationRepository()),
              ),
        ),
        BlocProvider<NotificationBloc>(
          create: (context) => NotificationBloc(notificationRepository: OneSignalNotificationRepository()),
          // ..add(LoadNotifications(context.read<AuthenticationBloc>().state.user!.uid)),
        ),

        /// Cubits
        BlocProvider<AppCubit>(create: (context) =>
        AppCubit()
          ..setLanguage(languageCode: null)),
        BlocProvider<ImageHandlerCubit>(create: (context) => ImageHandlerCubit()),
        BlocProvider<SearchCubit>(
          create: (context) =>
              SearchCubit(userRepository: context
                  .read<AuthenticationBloc>()
                  .userRepository),
        ),
        BlocProvider<LikesCommentsCubit>(
          create:
              (context) =>
              LikesCommentsCubit(FirebasePostRepository(notificationRepository: OneSignalNotificationRepository())),
        ),
      ],
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppStrings.appTitle,
            theme: AppStyle(themeIndex: state.themeCurrentIndex).currentTheme,
            themeMode: ThemeMode.light,
            locale: Locale(state.languageCode),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                if (state.status == AuthenticationStatus.authenticated) {
                  return const Layout();
                } else {
                  return const WelcomeScreen();
                }
              },
            ),
            // builder:
            //     (context, child) =>
            //     StreamChat(client: StreamChatClient("z3k88gbquy4a", logLevel: Level.INFO), child: child),
          );
        },
      ),
    );
  }
}
