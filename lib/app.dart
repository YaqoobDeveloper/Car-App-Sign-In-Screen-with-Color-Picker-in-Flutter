import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/showroom_login_screen.dart';

class CarApp extends StatelessWidget {
  const CarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Dealership',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const ShowroomLoginScreen(),
    );
  }
}
