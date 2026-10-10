import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/core/widgets/live_badge.dart';

void main() {
  testWidgets('LiveBadge shows LIVE text', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: LiveBadge()),
    ));
    expect(find.text('LIVE'), findsOneWidget);
    // Pump for a few frames to ensure animation runs without error.
    await tester.pump(const Duration(seconds: 1));
  });
}
