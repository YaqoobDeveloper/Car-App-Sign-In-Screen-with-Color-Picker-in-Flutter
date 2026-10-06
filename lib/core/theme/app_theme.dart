import 'package:flutter/material.dart';

abstract final class AppColors {
  static const charcoal = Color(0xFF1F2024);
  static const charcoalDeep = Color(0xFF141518);
  static const ink = Color(0xFF1C1D21);
  static const white = Color(0xFFFFFFFF);
  static const field = Color(0xFFF4F4F6);
  static const border = Color(0xFFE8E8EB);
  static const textPrimary = Color(0xFF17181B);
  static const textSecondary = Color(0xFF8A8C91);
  static const hint = Color(0xFFAEB0B5);
  static const star = Color(0xFFF5B63B);
  static const error = Color(0xFFD0503F);
}

abstract final class AppRadius {
  static const double sheet = 32;
  static const double pill = 30;
  static const double tile = 18;
}

abstract final class AppTheme {
  static ThemeData get light {
    OutlineInputBorder pill(Color color, {double width = 1}) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.ink,
        primary: AppColors.ink,
        surface: AppColors.white,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.white,
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.field,
        hintStyle: const TextStyle(color: AppColors.hint, fontSize: 15),
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 60,
          minHeight: 56,
        ),
        border: pill(Colors.transparent),
        enabledBorder: pill(Colors.transparent),
        focusedBorder: pill(AppColors.ink, width: 1.4),
        errorBorder: pill(AppColors.error),
        focusedErrorBorder: pill(AppColors.error, width: 1.4),
        errorStyle: const TextStyle(fontSize: 12, height: 1.4),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.ink.withValues(alpha: 0.55),
          disabledForegroundColor: Colors.white,
          minimumSize: const Size.fromHeight(58),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.ink,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          minimumSize: const Size(0, 40),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.charcoal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.tile),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border),
    );
  }
}
