import 'package:flutter_test/flutter_test.dart';
import 'package:tabdila/main.dart';

void main() {
  testWidgets('App sub-components smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Note: TabdilaApp requires some providers and initialization if we were doing a full test,
    // but for a simple pump we'll just check if it builds.
    await tester.pumpWidget(const TabdilaApp());

    // Basic check - since the app starts with a Splash or Home, we just check it doesn't crash on build.
    expect(tester.takeException(), isNull);
  });
}
