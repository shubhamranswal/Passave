import 'package:flutter/material.dart';

class PassaveTheme {
  static const Color primary = Color(0xFF4C7DFF);
  static const Color secondary = Color(0xFF22C55E);
  static const Color danger = Color(0xFFEF4444);

  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Colors.white;
  static const Color textPrimaryLight = Color(0xFF111827);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color dividerLight = Color(0xFFE5E7EB);

  static const Color backgroundDark = Color(0xFF0F1218);
  static const Color surfaceDark = Color(0xFF161A22);
  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color dividerDark = Color(0xFF1F2430);

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundDark,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      background: backgroundDark,
      surface: surfaceDark,
      error: danger,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundDark,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      iconTheme: IconThemeData(color: textPrimaryDark),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
          color: textPrimaryDark, fontSize: 24, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(
          color: textPrimaryDark, fontSize: 20, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(
          color: textPrimaryDark, fontSize: 16, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(color: textSecondaryDark, fontSize: 14),
      labelSmall: TextStyle(color: textSecondaryDark, fontSize: 13),
    ),
    cardTheme: CardTheme(
      color: surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: textSecondaryDark),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    dividerColor: dividerDark,
  );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundLight,
    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: secondary,
      background: backgroundLight,
      surface: surfaceLight,
      error: danger,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundLight,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
      ),
      iconTheme: IconThemeData(color: textPrimaryLight),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
          color: textPrimaryLight, fontSize: 24, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(
          color: textPrimaryLight, fontSize: 20, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(
          color: textPrimaryLight, fontSize: 16, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(color: textSecondaryLight, fontSize: 14),
      labelSmall: TextStyle(color: textSecondaryLight, fontSize: 13),
    ),
    cardTheme: CardTheme(
      color: surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: dividerLight),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: dividerLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
      hintStyle: const TextStyle(color: textSecondaryLight),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    dividerColor: dividerLight,
  );
}
