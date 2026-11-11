import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Color Palette
  static const Color primaryColor = Color(0xFF059669);
  static const Color secondaryColor = Color(0xFF10B981);
  static const Color tertiaryColor = Color(0xFFF59E0B);
  static const Color neutralColor = Color(0xFF1E293B);
  static const Color backgroundColor = Color(0xFFF8FAFC);

  // Font Families
  static const String headingFontFamily = 'PlusJakartaSans';
  static const String bodyFontFamily = 'Inter';

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: bodyFontFamily,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        surface: backgroundColor,
        onSurface: neutralColor,
        brightness: Brightness.light,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.8),
        ),
        hintStyle: const TextStyle(
          fontFamily: bodyFontFamily,
          color: Color(0xFF94A3B8),
          fontSize: 14,
        ),
      ),
      textTheme: _buildTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: neutralColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: headingFontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: neutralColor,
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    return const TextTheme(
      // Headings using Plus Jakarta Sans
      displayLarge: TextStyle(
        fontFamily: headingFontFamily,
        color: neutralColor,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: TextStyle(
        fontFamily: headingFontFamily,
        color: neutralColor,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: TextStyle(
        fontFamily: headingFontFamily,
        color: neutralColor,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: TextStyle(
        fontFamily: headingFontFamily,
        color: neutralColor,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        fontFamily: headingFontFamily,
        color: neutralColor,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        fontFamily: headingFontFamily,
        color: neutralColor,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        fontFamily: headingFontFamily,
        color: neutralColor,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        fontFamily: headingFontFamily,
        color: neutralColor,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        fontFamily: headingFontFamily,
        color: neutralColor,
        fontWeight: FontWeight.w500,
      ),

      // Body and labels using Inter
      bodyLarge: TextStyle(
        fontFamily: bodyFontFamily,
        color: neutralColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: bodyFontFamily,
        color: neutralColor,
      ),
      bodySmall: TextStyle(
        fontFamily: bodyFontFamily,
        color: neutralColor,
      ),
      labelLarge: TextStyle(
        fontFamily: bodyFontFamily,
        color: neutralColor,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: TextStyle(
        fontFamily: bodyFontFamily,
        color: neutralColor,
      ),
      labelSmall: TextStyle(
        fontFamily: bodyFontFamily,
        color: neutralColor,
      ),
    );
  }
}
