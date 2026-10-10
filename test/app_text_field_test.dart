import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/core/widgets/text_field.dart';

void main() {
  testWidgets('AppTextField renders with hint', (WidgetTester tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: AppTextField(
          hintText: 'Enter',
          controller: TextEditingController(),
        ),
      ),
    ));
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.text('Enter'), findsOneWidget);
  });
}
