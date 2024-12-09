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
      bodySmall:
          TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w500),
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
  ).copyWith(
    extensions: <ThemeExtension<dynamic>>[
      CustomColors(
        success: AppColors.success,
        warning: AppColors.warning,
        info: AppColors.info,
        danger: AppColors.danger,
      ),
    ],
  );
}


class CustomColors extends ThemeExtension<CustomColors> {
  final Color? success;
  final Color? warning;
  final Color? info;
  final Color? danger;

  CustomColors({this.success, this.warning, this.info, this.danger});

  @override
  CustomColors copyWith({Color? success, Color? warning, Color? info}) {
    return CustomColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      danger: danger ?? danger,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      success: Color.lerp(success, other.success, t),
      warning: Color.lerp(warning, other.warning, t),
      info: Color.lerp(info, other.info, t),
      danger: Color.lerp(danger, other.danger, t),
    );
  }
}