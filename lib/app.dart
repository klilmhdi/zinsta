import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_repository/notification_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:zinsta/blocs/auth_blocs/authentication_bloc/authentication_bloc.dart';

import 'app_view.dart';

class MainApp extends StatelessWidget {
  final UserRepository userRepository;

  const MainApp(this.userRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationBloc>(
          create: (_) => AuthenticationBloc(myUserRepository: userRepository),
        ),
        RepositoryProvider<UserRepository>(
            create: (context) => FirebaseUserRepository(notificationRepository: OneSignalNotificationRepository())),
        RepositoryProvider<OneSignalNotificationRepository>(
          create: (context) => OneSignalNotificationRepository(),
        ),
      ],
      child: const MyAppView(),
    );
  }
}
