import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/core/widgets/gold_button.dart';

void main() {
  testWidgets('GoldButton renders', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: GoldButton(
          label: 'Press',
          onPressed: () {},
        ),
      ),
    ));
    expect(find.text('Press'), findsOneWidget);
  });
}
