import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// App color constants
class AppColors {
  static const Color primaryPurple = Color(0xFF6A3DE8);
  static const Color primaryTeal = Color(0xFF00BCD4);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2E);
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF0F0F0);
  static const Color darkText = Color(0xFF121212);
  static const Color lightText = Color(0xFFF5F5F5);
  static const Color greyText = Color(0xFF9E9E9E);
}

// Animation durations
class AppDurations {
  static const Duration fast = Duration(milliseconds: 300);
  static const Duration medium = Duration(milliseconds: 500);
  static const Duration slow = Duration(milliseconds: 800);
}

// Text styles
class AppTextStyles {
  static TextStyle get headingStyle => GoogleFonts.montserrat(
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      );
  static TextStyle get bodyStyle => GoogleFonts.outfit(
        fontWeight: FontWeight.normal,
      );
  static TextStyle get accentStyle => GoogleFonts.cinzel(
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
      );
}

// Light Theme
ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  fontFamily: GoogleFonts.outfit().fontFamily,
  primaryColor: AppColors.primaryPurple,
  scaffoldBackgroundColor: AppColors.lightBackground,
  colorScheme: ColorScheme.light(
    primary: AppColors.primaryPurple,
    secondary: AppColors.primaryTeal,
    tertiary: AppColors.accentGreen,
    surface: AppColors.lightSurface,
    error: Colors.redAccent,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.darkText,
  ),
  cardTheme: CardThemeData(
    color: AppColors.lightCard,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.lightCard,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: AppColors.primaryPurple, width: 2),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryPurple,
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  ),
);

// Dark Theme
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  fontFamily: GoogleFonts.outfit().fontFamily,
  useMaterial3: true,
  primaryColor: AppColors.primaryPurple,
  scaffoldBackgroundColor: AppColors.darkBackground,
  colorScheme: ColorScheme.dark(
    primary: AppColors.primaryPurple,
    secondary: AppColors.primaryTeal,
    tertiary: AppColors.accentGreen,
    surface: AppColors.darkSurface,
    error: Colors.redAccent,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.lightText,
  ),
  cardTheme: CardThemeData(
    color: AppColors.darkCard,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.darkSurface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: AppColors.primaryPurple, width: 2),
    ),
    hintStyle: TextStyle(color: AppColors.greyText),
    labelStyle: TextStyle(color: AppColors.greyText),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryPurple,
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  ),
);