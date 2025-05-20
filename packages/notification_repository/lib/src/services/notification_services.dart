import 'package:flutter/cupertino.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationServices {
  static Future<void> init() async {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize("dad71c80-52d8-4983-81b2-af2487b5bc52");
    OneSignal.Notifications.requestPermission(true);
    FirebaseMessaging.instance.getToken().then((value) => debugPrint("-------- FCM token: $value"));
  }
}
