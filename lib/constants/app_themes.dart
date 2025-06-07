import 'package:flutter/material.dart';

class AppThemes {
  // Light Theme Colors
  static const Color lightPrimary = Colors.blue;
  static const Color lightPrimaryVariant = Colors.blue;
  static const Color lightSecondary = Color(0xFF4CAF50);
  static const Color lightSecondaryVariant = Color(0xFF45A049);
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Colors.white;
  static const Color lightError = Color(0xFFFF5722);
  static const Color lightOnPrimary = Colors.white;
  static const Color lightOnSecondary = Colors.white;
  static const Color lightOnBackground = Color(0xFF2D2D2D);
  static const Color lightOnSurface = Color(0xFF2D2D2D);
  static const Color lightOnError = Colors.white;
  static const Color lightCardBackground = Colors.white;
  static const Color lightBorder = Color(0xFFE9ECEF);
  static const Color lightSubtext = Color(0xFF6C757D);

  // Dark Theme Colors
  static const Color darkPrimary = Colors.blue;
  static const Color darkPrimaryVariant = Colors.blue;
  static const Color darkSecondary = Color(0xFF66BB6A);
  static const Color darkSecondaryVariant = Color(0xFF5CB660);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkError = Color(0xFFCF6679);
  static const Color darkOnPrimary = Color(0xFF000000);
  static const Color darkOnSecondary = Color(0xFF000000);
  static const Color darkOnBackground = Color(0xFFE1E1E1);
  static const Color darkOnSurface = Color(0xFFE1E1E1);
  static const Color darkOnError = Color(0xFF000000);
  static const Color darkCardBackground = Color(0xFF2D2D2D);
  static const Color darkBorder = Color(0xFF404040);
  static const Color darkSubtext = Color(0xFFB3B3B3);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: lightPrimary,
    colorScheme: const ColorScheme.light(
      primary: lightPrimary,
      secondary: lightSecondary,
      surface: lightSurface,
      error: lightError,
      onPrimary: lightOnPrimary,
      onSecondary: lightOnSecondary,
      onSurface: lightOnSurface,
      onError: lightOnError,
    ),
    scaffoldBackgroundColor: lightBackground,
    cardColor: lightCardBackground,
    dividerColor: lightBorder,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: lightOnBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: lightOnBackground),
      titleTextStyle: TextStyle(
        color: lightOnBackground,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightPrimary,
        foregroundColor: lightOnPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: lightPrimary,
      foregroundColor: lightOnPrimary,
      elevation: 4,
    ),
    cardTheme: CardThemeData(
      color: lightCardBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.black.withOpacity(0.1),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: lightBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: lightPrimary, width: 2),
      ),
      hintStyle: const TextStyle(color: lightSubtext),
      labelStyle: const TextStyle(color: lightSubtext),
    ),
    iconTheme: const IconThemeData(color: lightPrimary),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: lightOnBackground,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: lightOnBackground,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(
        color: lightOnBackground,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        color: lightSubtext,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: TextStyle(
        color: lightSubtext,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: lightOnBackground,
      contentTextStyle: const TextStyle(color: lightBackground),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkPrimary,
    colorScheme: const ColorScheme.dark(
      primary: darkPrimary,
      secondary: darkSecondary,
      surface: darkSurface,
      error: darkError,
      onPrimary: darkOnPrimary,
      onSecondary: darkOnSecondary,
      onSurface: darkOnSurface,
      onError: darkOnError,
    ),
    scaffoldBackgroundColor: darkBackground,
    cardColor: darkCardBackground,
    dividerColor: darkBorder,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: darkOnBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: darkOnBackground),
      titleTextStyle: TextStyle(
        color: darkOnBackground,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimary,
        foregroundColor: darkOnPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: darkPrimary,
      foregroundColor: darkOnPrimary,
      elevation: 4,
    ),
    cardTheme: CardThemeData(
      color: darkCardBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.black.withOpacity(0.3),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkPrimary, width: 2),
      ),
      hintStyle: const TextStyle(color: darkSubtext),
      labelStyle: const TextStyle(color: darkSubtext),
    ),
    iconTheme: const IconThemeData(color: darkPrimary),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: darkOnBackground,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: darkOnBackground,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(
        color: darkOnBackground,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        color: darkSubtext,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: TextStyle(
        color: darkSubtext,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: darkOnBackground,
      contentTextStyle: const TextStyle(color: darkBackground),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),
  );

  // Helper methods for accessing theme colors in widgets
  static Color getPrimaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  static Color getCardColor(BuildContext context) {
    return Theme.of(context).cardColor;
  }

  static Color getTextColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  static Color getSubtextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightSubtext
        : darkSubtext;
  }

  static Color getBorderColor(BuildContext context) {
    return Theme.of(context).dividerColor;
  }

  static Color getSurfaceColor(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  static Color getDividerColor(BuildContext context) {
    return Theme.of(context).dividerColor;
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
