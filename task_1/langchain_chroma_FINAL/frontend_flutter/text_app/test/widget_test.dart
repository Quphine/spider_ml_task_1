// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:text_app/main.dart';

void main() {
  testWidgets('Quphine\'s first app UI test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Home()));
    expect(find.text("Quphine's first App!"), findsOneWidget);
    expect(find.byIcon(Icons.local_florist), findsOneWidget);
    expect(find.text('Click'), findsOneWidget);
    await tester.tap(find.text('Click'));
    await tester.pump();
  });
}