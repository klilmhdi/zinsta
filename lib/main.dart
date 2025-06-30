import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:zinsta/src/blocs/bloc_observer.dart';
import 'package:zinsta/src/components/consts/di.dart';
import 'package:zinsta/src/components/consts/shared_perferenced.dart';
import 'package:zinsta/firebase_options.dart';
import 'package:zinsta/src/repo/firebase_user_repository.dart';
import 'package:zinsta/src/repo/onesignal_notification_repository.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// init firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// init shared preferenced
  await SharedPrefController().initPreferences();

  /// init di (injector)
  // await AppInjector.init();

  /// init saved login to GetStream
  // await AppConsumers().handleSavedLogin();

  /// init blocs
  Bloc.observer = MyBlocObserver();

  if (!kIsWeb) {
    /// init notifications
    await OneSignalNotificationRepository().initializeOneSignal();

    /// Splash remove settings
    FlutterNativeSplash.remove();
  }

  /// Set system orientation
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  /// Captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) {
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack!);
    }
  };

  runApp(MainApp(FirebaseUserRepository(notificationRepository: OneSignalNotificationRepository())));
}
