import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wirapath/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const WirapathApp());
    await tester.pumpAndSettle();

    // Splash screen should show the logo images
    expect(find.byType(Image), findsNWidgets(2));
  });
}
