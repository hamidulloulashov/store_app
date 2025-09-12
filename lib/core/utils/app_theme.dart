import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_app/core/utils/app_colors.dart';
class AppThemes {
  static ThemeData _baseTheme(
    ColorScheme colorScheme,
    Color scaffoldBg,
    Color bodyColor,
    Color displayColor,
    AppBarTheme appBarTheme,
  ) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBg,
      appBarTheme: appBarTheme,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
      ).apply(
        bodyColor: bodyColor,
        displayColor: displayColor,
      ),
      iconTheme: IconThemeData(color: AppColors.reting),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.reting,
        foregroundColor: bodyColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.reting,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
  static final lightTheme = _baseTheme(
    const ColorScheme.light(
      primary: AppColors.white,
      surface: AppColors.white,
      background: AppColors.white,
      onPrimary: AppColors.containerBlack,
      onSurface: AppColors.containerBlack,
      onBackground: AppColors.containerBlack,
    ),
    AppColors.white,
    AppColors.containerBlack,
    AppColors.containerBlack,
    const AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.containerBlack,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
  );

  static final darkTheme = _baseTheme(
    const ColorScheme.dark(
      primary: AppColors.containerBlack,
      surface: AppColors.containerBlack,
      background: AppColors.containerBlack,
      onPrimary: AppColors.white,
      onSurface: AppColors.white,
      onBackground: AppColors.white,
    ),
    AppColors.containerBlack,
    AppColors.white,
    AppColors.white,
    const AppBarTheme(
      backgroundColor: AppColors.containerBlack,
      foregroundColor: AppColors.white,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    ),
  );
}
