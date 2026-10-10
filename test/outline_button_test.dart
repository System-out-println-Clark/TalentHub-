import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/core/widgets/outline_button.dart';

void main() {
  testWidgets('OutlineButton renders', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: OutlineButton(
          label: 'Outline',
          onPressed: () {},
        ),
      ),
    ));
    expect(find.text('Outline'), findsOneWidget);
  });
}
