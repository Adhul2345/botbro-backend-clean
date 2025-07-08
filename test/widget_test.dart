import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:botbro/main.dart'; // make sure this is your correct path

void main() {
  testWidgets('Loads splash screen initially', (WidgetTester tester) async {
    await tester.pumpWidget(const BotBroApp(startScreen: 'splash_screen'));

    expect(
      find.text('🤖 BotBro'),
      findsOneWidget,
    ); // Based on your splash screen text
  });
}
