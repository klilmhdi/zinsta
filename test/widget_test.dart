import 'package:flutter_test/flutter_test.dart';
import 'package:zinsta/app.dart';
import 'package:zinsta/src/repo/firebase_user_repository.dart';
import 'package:zinsta/src/repo/onesignal_notification_repository.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await tester.pumpWidget(MainApp(FirebaseUserRepository(notificationRepository: OneSignalNotificationRepository())));
  });
}
