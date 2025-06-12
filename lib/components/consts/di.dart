import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' hide User;
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';
import 'package:zinsta/components/consts/shared_perferenced.dart';
import 'package:zinsta/services/token_service.dart';
import 'package:zinsta/services/user_auth_repo.dart';
import 'package:zinsta/services/user_chat_repo.dart';
import 'package:zinsta/services/user_controller.dart';

import '../../services/getstream_logger.dart';

GetIt locator = GetIt.instance;

@pragma('vm:entry-point')
Future<void> _backgroundVoipCallHandler() async {

  WidgetsFlutterBinding.ensureInitialized();
  final apiKey = SharedPrefController().environment;

  StreamVideo(
    apiKey.toString(),
    user: User(info: SharedPrefController().userCredentials!.userInfo),
    userToken: SharedPrefController().userCredentials!.token.rawValue,
    options: const StreamVideoOptions(
      logPriority: Priority.verbose,
      muteAudioWhenInBackground: true,
      muteVideoWhenInBackground: true,
      keepConnectionsAliveWhenInBackground: true,
    ),
    pushNotificationManagerProvider: StreamVideoPushNotificationManager.create(
      iosPushProvider: const StreamVideoPushProvider.apn(name: 'flutter-apn'),
      androidPushProvider: const StreamVideoPushProvider.firebase(
        name: 'flutter-firebase', // this value is wrong
      ),
      pushParams: StreamVideoPushParams(
        appName: "GetStream Flutter Example",
        ios: const IOSParams(iconName: 'IconMask'),
        android: const AndroidParams(),
        missedCallNotification: const NotificationParams(
          showNotification: true,
          subtitle: 'Missed Call',
          callbackText: 'Call Back',
        ),
        textDecline: "Decline",
        type: 0,
        nameCaller: "callerName",
      ),
      registerApnDeviceToken: true,
    ),
  );
}

/// This class is responsible for registering dependencies
/// and injecting them into the app.
class AppInjector {
  // Register dependencies
  static Future<void> init({EnvEnum? forceEnvironment}) async {
    // App Preferences
    final prefs = SharedPrefController();

    if (forceEnvironment != null) {
      await SharedPrefController().setEnvEnum(forceEnvironment);
    }

    locator.registerSingleton<SharedPrefController>(prefs);

    // Repositories
    locator.registerSingleton(const TokenService());

    locator.registerFactoryParam<UserAuthRepository, User, TokenResponse>((user, tokenResponse) {
      debugPrint(
        ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>tokenResponse.apiKey: ${tokenResponse.apiKey}",
      );
      registerStreamChat(tokenResponse.apiKey);

      // We need to register the video client here because we need it to
      // initialise the user auth repo.
      registerStreamVideo(tokenResponse, user, SharedPrefController().environment);

      return UserAuthRepository(videoClient: locator(), tokenService: locator());
    });

    // App wide Controller
    locator.registerLazySingleton<UserAuthController>(
      dispose: (controller) => controller.dispose(),
      () => UserAuthController(prefs: locator(), tokenService: locator()),
    );
  }

  static void registerStreamChat(String apiKey) {
    locator.registerSingleton<StreamChatClient>(
      _initStreamChat(apiKey),
      dispose: (client) => client.dispose(),
    );

    locator.registerLazySingleton<UserChatRepository>(
      () => UserChatRepository(chatClient: locator(), tokenService: locator()),
    );
  }

  static StreamVideo registerStreamVideo(
    TokenResponse tokenResponse,
    User user,
    EnvEnum environment,
  ) {
    _setupLogger();

    return locator.registerSingleton(
      dispose: (_) => StreamVideo.reset(),
      _initStreamVideo(
        tokenResponse.apiKey,
        user,
        initialToken: tokenResponse.token,
        tokenLoader: switch (user.type) {
          UserType.authenticated => (String userId) {
            final tokenService = locator<TokenService>();
            return tokenService
                .loadToken(userId: userId, environment: environment)
                .then((response) => response.token);
          },
          _ => null,
        },
      ),
    );
  }

  static Future<void> reset() => locator.reset();
}

StreamLog _setupLogger() {
  const consoleLogger = ConsoleStreamLogger();
  final children = <StreamLogger>[consoleLogger];
  FileStreamLogger? fileLogger;
  if (!kIsWeb) {
    fileLogger = FileStreamLogger(
      AppFileLogConfig('1.0.0'),
      sender: (logFile) async {
        consoleLogger.log(
          Priority.debug,
          'Flutter GetStream Test',
          () => '[send] logFile: $logFile(${logFile.existsSync()})',
        );
        await Share.shareXFiles(
          [XFile(logFile.path)],
          subject: 'Share Logs',
          text: 'Flutter GetStream Test Logs',
        );
      },
      console: consoleLogger,
    );
    children.add(fileLogger);
  }
  return StreamLog()..logger = CompositeStreamLogger(children);
}

StreamChatClient _initStreamChat(String apiKey) {
  final streamChatClient = StreamChatClient(apiKey, logLevel: Level.INFO);

  return streamChatClient;
}

StreamVideo _initStreamVideo(
  String apiKey,
  User user, {
  String? initialToken,
  TokenLoader? tokenLoader,
}) {
  if (initialToken == null || initialToken.isEmpty) {
    debugPrint("Invalid token: Token is missing or expired.");
    throw Exception("Invalid token");
  }

  debugPrint(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Initial token: $initialToken");
  final streamVideoClient = StreamVideo(
    apiKey,
    user: user,
    tokenLoader: tokenLoader,
    options: const StreamVideoOptions(
      logPriority: Priority.verbose,
      keepConnectionsAliveWhenInBackground: true,
    ),
    pushNotificationManagerProvider: StreamVideoPushNotificationManager.create(
      iosPushProvider: const StreamVideoPushProvider.apn(name: 'flutter-apn'),
      androidPushProvider: const StreamVideoPushProvider.firebase(
        name: 'flutter-firebase', // this value is wrong
      ),
      pushParams: StreamVideoPushParams(
        appName: "GetStream Flutter Example",
        ios: const IOSParams(iconName: 'IconMask'),
        android: const AndroidParams(),
        missedCallNotification: const NotificationParams(
          showNotification: true,
          subtitle: 'Missed Call',
          callbackText: 'Call Back',
        ),
        textDecline: "Decline",
        type: 0,
        nameCaller: user.name,
        handle: user.id.substring(0, 4),
        avatar: user.image,
      ),
      // backgroundVoipCallHandler: _backgroundVoipCallHandler,
    ),
  );

  return streamVideoClient;
}
