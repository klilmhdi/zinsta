import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinsta/core/repo/user_repo.dart';
import 'package:zinsta/src/blocs/auth_blocs/authentication_bloc/authentication_bloc.dart';
import 'package:zinsta/src/repo/firebase_user_repository.dart';
import 'package:zinsta/src/repo/onesignal_notification_repository.dart';

import 'app_view.dart';

class MainApp extends StatelessWidget {
  final UserRepository userRepository;

  const MainApp(this.userRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationBloc>(create: (_) => AuthenticationBloc(myUserRepository: userRepository)),
        RepositoryProvider<UserRepository>(
          create: (context) => FirebaseUserRepository(notificationRepository: OneSignalNotificationRepository()),
        ),
        RepositoryProvider<OneSignalNotificationRepository>(create: (context) => OneSignalNotificationRepository()),
      ],
      child: const MyAppView(),
    );
  }
}
