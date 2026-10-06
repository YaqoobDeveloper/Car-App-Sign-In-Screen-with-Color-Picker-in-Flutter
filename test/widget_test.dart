import 'package:flutter_test/flutter_test.dart';

import 'package:car_dealership/app.dart';

void main() {
  testWidgets('Login screen validates empty fields', (tester) async {
    await tester.pumpWidget(const CarApp());

    expect(find.text('Welcome Back'), findsOneWidget);

    await tester.ensureVisible(find.text('Sign In').last);
    await tester.tap(find.text('Sign In').last);
    await tester.pump();

    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });
}
