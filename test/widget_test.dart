import 'package:flutter_test/flutter_test.dart';
import 'package:notification_repository/notification_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:zinsta/app.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await tester.pumpWidget(MainApp(FirebaseUserRepository(notificationRepository: OneSignalNotificationRepository())));
  });
}
