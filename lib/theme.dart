import 'package:akontaa/app_colors.dart';
import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFFBB86FC),
  scaffoldBackgroundColor: Colors.transparent,
  colorScheme: ColorScheme.dark(
    primary: const Color(0xFFBB86FC),
    secondary: AppColors.green,
    surface: AppColors.background,
    error: AppColors.red,
    onPrimary: Colors.black,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onError: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  cardTheme: CardThemeData(
    color: AppColors.background,
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.green,
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    headlineSmall: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    titleLarge: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: AppColors.background.withOpacity(0.5),
  ),
);
