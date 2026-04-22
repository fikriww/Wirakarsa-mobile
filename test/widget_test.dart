import 'package:flutter_test/flutter_test.dart';
import 'package:wirapath/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const WirapathApp());
    await tester.pumpAndSettle();

    // Splash screen should show the brand name
    expect(find.text('Wirapath'), findsOneWidget);
  });
}
