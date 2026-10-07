import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:car_dealership/app.dart';
import 'package:car_dealership/core/theme/app_theme.dart';
import 'package:car_dealership/screens/login_screen.dart';

void main() {
  testWidgets('Original login screen validates empty fields', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const LoginScreen()),
    );

    expect(find.text('Welcome Back'), findsOneWidget);

    await tester.ensureVisible(find.text('Sign In').last);
    await tester.tap(find.text('Sign In').last);
    await tester.pump();

    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('Showroom screen validates sign-in fields', (tester) async {
    await tester.pumpWidget(const CarApp());

    expect(find.text('Forgot Password?'), findsOneWidget);

    final submit = find.byType(FilledButton);
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pump();

    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
    expect(find.text('Please enter your name'), findsNothing);
  });

  testWidgets('Showroom toggle switches to sign-up mode', (tester) async {
    await tester.pumpWidget(const CarApp());

    await tester.ensureVisible(find.text('Sign Up'));
    await tester.tap(find.text('Sign Up'));
    // The pulsing badge never settles, so pump past the toggle animation.
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Full name'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsNothing);

    final submit = find.byType(FilledButton);
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pump();

    expect(find.text('Please enter your name'), findsOneWidget);
  });
}
