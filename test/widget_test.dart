import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/providers/birthdays_provider.dart';

void main() {
  testWidgets('App launches and shows birthday screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => BirthdaysProvider(),
        child: const BirthdayApp(),
      ),
    );
    await tester.pump();
    expect(find.text('Дни рождения'), findsOneWidget);
  });
}
