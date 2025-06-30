// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import 'package:rxdart/rxdart.dart';
// // import 'package:stream_video_flutter/stream_video_flutter.dart' hide ConnectionState;
// import 'package:zinsta/components/consts/shared_perferenced.dart';
// import 'package:zinsta/components/consts/di.dart';
// // import 'package:zinsta/services/token_service.dart';
// // import 'package:zinsta/services/user_controller.dart';
//
// import '../../firebase_options.dart';
//
// @pragma('vm:entry-point') // Required for Flutter on Android
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   debugPrint('Handling a background message: ${message.messageId}');
//
//   // Handle the message
//   // await AppInjector.init();
//
//   try {
//     // final prefs = locator.get<AppPreferences>();
//     final prefs = SharedPrefController();
//
//     // final credentials = prefs.userCredentials;
//     // if (credentials == null) return;
//
//     // final tokenResponse = await locator.get<TokenService>().loadToken(
//     //   userId: credentials.userInfo.id,
//     //   environment: prefs.environment,
//     // );
//
//     // final streamVideo = AppInjector.registerStreamVideo(
//     //   tokenResponse,
//     //   User(info: credentials.userInfo),
//     //   prefs.environment,
//     // );
//
//     // streamVideo.observeCallDeclinedCallKitEvent();
//     // await AppConsumers().handleRemoteMessage(message);
//   } catch (e, stk) {
//     debugPrint('Error handling remote message: $e');
//     debugPrint(stk.toString());
//   }
//
//   // Reset dependencies to clean up
//   // return AppInjector.reset();
// }
//
// class AppConsumers {
//   /// public variables
//   final compositeSubscription = CompositeSubscription();
//
//   final Map<String, dynamic> serviceAccountJson = {
//     "type": "service_account",
//     "project_id": "getstream-flutter-example",
//     "private_key_id": "7e9314f3d4876db7ea092629ecd5ef0546d691ec",
//     "private_key":
//         "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC6QcGXY3tfSqbf\nCNTpFKkIlRer/uQyceZFv0z8C0i0h0UHd0ykCNfdufTF2TfVzZlrAyy+RiZI591w\nh9odh4kYGz0Kg++BRdR6XYtr68nYrC+hGt/sBnRo6J8i+P/j3Pf5/JenPDu+AwVL\nvnqKeY8zPLhW1DfqGMLOL0F2tyWEjkY1H/xujfT+iyzP7Ks3NJIuskkiZspWvcmm\nmOPQ2r9JbMAiMF7/k2r/T3kpTG4EkqpMIkTCUtALviMWCWRHyednCTO5u1fkP7oq\nwvWuKJT2rI0qGQtFVu8QAoPGc6RPsMH2ILLcNqc0+WfBee7EmIQuSkIEXNVyUrUp\nJBGCDBY/AgMBAAECggEAB6C3b/s+nSdiAgKnht2vBH2SnlQ47+XvduNxkmWQkr5W\nVW5UfT1GXQLAThjb3OouyY3COyuFSflmRLU+QK3k6F3+ic2mpvfUo/0lhoP9zkDh\nMc6T5WOS8zfRZtFQEQjxPxrR8nhRhrH5+WExrzX/ICtxJsEtZiZMAPZyI/EaFaEU\nuOZupifUJMeE2MpkWuuP3YqRQaDgd8Lg5dKQ04GASyYXAZLVFdyR5HS9UCkE7AYx\nH3hoRZSk6PiJFPvGK9CRKw0x1EhhIBR0SfPwF9MvhoDwszBqTsrsOuQUYITPwAr7\nFDvXbTNvWPW1y0xHdjptiynMceFbcyyTNLOMvrJ22QKBgQDsPjSqCr14Ox0GgIN/\n99qB9LC7ZfxpW6fAKls+XWLff6TjROMHiIx5VBL8sxaXLljSdQNI0dHr+hmqBeXW\novhbWUkGfPmxvdil5vkfKnvoUpjjv4MPNGz0FolHPnJC48Dl3Y4d8n4SwFE6tcIW\njMrnzauYHY38gh6gc3NElw0I+QKBgQDJ1WINRZ9xbIAkw+GZ71xXWbt3mWs5CMx0\ns7bXaJL3RQk2DV/IbSqxftrr+8WOX8hNpeq77b7TlVai2r0ag7rlPurUQjiT9QY3\nIWcc+gGjDYkVh7VzTNxcGgx9xhYdyzTzz0uEdJ2f4++M63jXWSZSbS10xHEQ5eZZ\nyEa9pNVe9wKBgQDCnZg7ALAHbQNDSPmLoT5T0qUJLEIc9VGjYAFcxgfewMOwKh6x\nJQ88IEOoA0y37IlljtnO0nMR6C3eQA+Qmx7n+gzLmIcGorPoL/fIcfIzeF/VNv6b\ntv+OsUYT9+CfNArEEpmyGAM+JUqFiBhFBWVeQrN6k9ZVT0g1vAYYWit12QKBgB2W\n8vEPK/js9zxsmz5+IQONXDaEf3u1FoRldIDQC/vEWz1ZaJlxp7it6FqAZs4grLT1\nhhxXForecf0eJGsmtNe3CaZkrvbCDU83zm4pGORWr6pAYxGsSwIVr48g400q5XB5\nC5E3p4QxXoVCYEzx/PRInUlpI0pe6g5vli9nYwCxAoGBALTAyJ+QxgafdamebkHw\noUZo7dpX5oOyR8VvAoXnJXOk3dqeSu8+0fYFLrt0bkZcxTkkbE5/MfmhcF81rVAf\n/6ZWjGIDbMUV0fq6pCJuw6f9nw7LxkOa0zo0lRp53OdhZ+26HrcTCXXylvNjEOsb\nYFEFcjoG/wn3bpsXPleF3lo5\n-----END PRIVATE KEY-----\n",
//     "client_email": "firebase-adminsdk-qhdst@getstream-flutter-example.iam.gserviceaccount.com",
//     "client_id": "112290239843924678140",
//     "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//     "token_uri": "https://oauth2.googleapis.com/token",
//     "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//     "client_x509_cert_url":
//         "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-qhdst%40getstream-flutter-example.iam.gserviceaccount.com",
//     "universe_domain": "googleapis.com",
//   };
//
//   /// save login
//   Future<void> handleSavedLogin() async {
//     final prefs = SharedPrefController();
//     // final credentials = prefs.userCredentials;
//     //
//     // if (credentials == null || credentials.userInfo.id.isEmpty) {
//     //   print("No saved user credentials found.");
//     //   return;
//     // }
//
//     // final authController = locator.get<UserAuthController>();
//     // await authController.login(User(info: credentials.userInfo), prefs.environment);
//     print("User auto-logged in with credentials from SharedPreferences.");
//   }
//
//   /// remote message
//   // Future<bool> handleRemoteMessage(RemoteMessage message) async {
//     // final streamVideo = locator.get<StreamVideo>();
//     // return streamVideo.handleVoipPushNotification(message.data);
//   // }
//
//   /// consume incoming call
//   // Future<void> consumeIncomingCall(context) async {
//   //   if (!locator.isRegistered<StreamVideo>()) return;
//   //
//   //   final streamVideo = locator.get<StreamVideo>();
//   //   final calls = await streamVideo.pushNotificationManager?.activeCalls();
//   //
//   //   if (calls == null || calls.isEmpty) return;
//   //
//   //   final callResult = await streamVideo.consumeIncomingCall(
//   //     uuid: calls.first.uuid!,
//   //     cid: calls.first.callCid!,
//   //   );
//   //
//   //   callResult.fold(
//   //     success: (result) async {
//   //       final call = result.data;
//   //       await call.accept();
//   //
//   //       final extra = (call: result.data, connectOptions: null);
//   //
//   //       Navigator.push(
//   //         context,
//   //         MaterialPageRoute(builder: (context) => CallScreen(call: extra.call)),
//   //       );
//   //     },
//   //     failure: (error) {
//   //       debugPrint('*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Error consuming incoming call: $error');
//   //     },
//   //   );
//   // }
//
//   /// push notification
//   void initPushNotificationManagerIfAvailable(BuildContext context) {
//     // if (!locator.isRegistered<StreamVideo>()) return;
//
//     _observeFcmMessages();
//     observeCallKitEvents(context);
//   }
//
//   /// observer callkit
//   void observeCallKitEvents(context) {
//     // final streamVideo = locator.get<StreamVideo>();
//
//     // StreamVideo.instance.pushNotificationManager?.endAllCalls();
//
//     // compositeSubscription.add(
//     //   streamVideo.observeCoreCallKitEvents(
//     //     onCallAccepted: (callToJoin) {
//     //       Navigate to the call screen.
//           // final extra = (call: callToJoin, connectOptions: null);
//
//           // Navigator.of(
//           //   context,
//           //   rootNavigator: true,
//           // ).push(MaterialPageRoute(builder: (context) => CallScreen(call: extra.call)));
//         // },
//       // ),
//     // );
//   }
//
//   /// private functions
//   // observer FCM
//   _observeFcmMessages() {
//     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//     // compositeSubscription.add(FirebaseMessaging.onMessage.listen(handleRemoteMessage));
//   }
// }
