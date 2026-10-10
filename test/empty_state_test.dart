import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/core/widgets/empty_state.dart';

void main() {
  testWidgets('EmptyState displays title and subtitle', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: EmptyState(
          title: 'No Items',
          subtitle: 'Add something',
        ),
      ),
    ));
    expect(find.text('No Items'), findsOneWidget);
    expect(find.text('Add something'), findsOneWidget);
  });
}
