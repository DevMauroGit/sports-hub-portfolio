// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:sports_hub_ios/main.dart';
import 'package:sports_hub_ios/page/home_page.dart';
import 'package:sports_hub_ios/page/login_page.dart';
import 'package:sports_hub_ios/page/start_page.dart';
import 'package:sports_hub_ios/page/verify_email_page.dart';
import 'package:sports_hub_ios/page/verify_phone_page_start.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(router: GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const StartPage()),
        GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
        GoRoute(path: '/home', builder: (context, state) => const HomePage()),
        GoRoute(path: '/verify-email', builder: (context, state) => const VerifyEmailPage()),
        GoRoute(path: '/verify-phone', builder: (context, state) => const VerifyPhonePageStart()),
      ],
    )));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
