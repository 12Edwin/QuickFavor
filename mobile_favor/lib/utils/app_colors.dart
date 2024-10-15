import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF34344E);
  static const Color secondaryColor = Color(0xFF566981);
  static const Color secondaryColor2 = Color(0xFF89A7B1);
  static const Color backgroundColor = Color(0xFFCBDAD5);
  static const Color fontColor = Color(0xFF000000);
  static const Color success = Color(0xFF00C853);
  static const Color warning = Color(0xFFFFD600);
  static const Color danger = Color(0xFFFF1744);
  static const Color info = Color(0xFF00B0FF);
  static const Color disabled = Color(0xFFBDBDBD);
  static const String fontFamily = 'Montserrat';
}

ThemeData appTheme() {
  return ThemeData(
    primaryColor: AppColors.primaryColor,
    secondaryHeaderColor: AppColors.secondaryColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: AppColors.primaryColor,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        color: AppColors.primaryColor,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: TextStyle(
        color: AppColors.primaryColor,
        fontWeight: FontWeight.w500
      ),
      titleLarge: TextStyle(
        color: AppColors.primaryColor,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: TextStyle(
        color: AppColors.primaryColor,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        color: AppColors.primaryColor,
        fontWeight: FontWeight.w500,
      ),
      labelLarge: TextStyle(
        color: AppColors.primaryColor,
        fontWeight: FontWeight.w600,
      ),
    ),
    fontFamily: AppColors.fontFamily,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.backgroundColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryColor,
      ),
    ),
  );
}