import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this import
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.poppinsTextTheme();

    return ThemeData(
      useMaterial3: true,
      // Remove fontFamily from here since we're using GoogleFonts.textTheme
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.cardBackground,
        background: AppColors.background,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
      ),
      scaffoldBackgroundColor: AppColors.background,
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppColors.cardRadiusLarge),
          ),
        ),
        shadowColor: const Color.fromRGBO(0, 0, 0, 0.08),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.sectionBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.cardRadiusSmall),
          borderSide: BorderSide(color: AppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.cardRadiusSmall),
          borderSide: BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.cardRadiusSmall),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.cardRadiusSmall),
          borderSide: BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.cardRadiusSmall),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: GoogleFonts.poppins(
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: GoogleFonts.poppins(
          color: AppColors.textLight,
          fontSize: 14,
        ),
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          height: 1.2,
          letterSpacing: -0.5,
        ),
        displayMedium: baseTextTheme.displayMedium?.copyWith(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.3,
          letterSpacing: -0.25,
        ),
        displaySmall: baseTextTheme.displaySmall?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.3,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.4,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
          height: 1.4,
        ),
        titleSmall: baseTextTheme.titleSmall?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
          height: 1.4,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
          height: 1.5,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
        bodySmall: baseTextTheme.bodySmall?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.textLight,
          height: 1.5,
        ),
        labelLarge: baseTextTheme.labelLarge?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
          height: 1.4,
        ),
        labelMedium: baseTextTheme.labelMedium?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
          height: 1.4,
        ),
        labelSmall: baseTextTheme.labelSmall?.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.textMuted,
          height: 1.4,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          fixedSize: const Size(200, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColors.cardRadiusSmall),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  static ThemeData? get darkTheme => null;
}
