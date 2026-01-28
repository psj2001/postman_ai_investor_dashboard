import 'package:flutter/material.dart';

/// Monday.com inspired color palette for the investor dashboard
class AppColors {
  // Background colors
  static const Color background = Color(0xFFF0F3FE); // Light blue background
  static const Color sectionBackground = Color(0xFFF8F9FA); // Light grey
  static const Color cardBackground = Color(0xFF99AFFB); // Blue cards

  // Primary colors - Professional blue palette
  static const Color primary = Color(0xFF6263FA); //Blue shade
  static const Color primaryLight = Color(0xFF4285F4); // Lighter blue
  static const Color primaryDark = Color(0xFF0D47A1); // Darker blue
  static const Color accent = Color(0xFF34A853); // Google Green
  static const Color accentLight = Color(0xFF81C784); // Light green

  // Text colors
  static const Color white = Color(0xFFFFFFFF); // White
  static const Color textPrimary = Color(0xFF202124); // Dark grey
  static const Color textSecondary = Color(0xFF5F6368); // Medium grey
  static const Color textLight = Color(0xFF9AA0A6); // Light grey
  static const Color textMuted = Color(0xFFBDBDBD); // Very light grey

  // Status colors
  static const Color success = Color(0xFF34A853); // Green
  static const Color warning = Color(0xFFF9AB00); // Amber
  static const Color error = Color(0xFFEA4335); // Red
  static const Color info = Color(0xFF4285F4); // Blue

  // Border and divider
  static const Color border = Color(0xFFE8EAED); // Light border
  static const Color borderLight = Color(0xFFF1F3F4); // Very light border
  static const Color divider = Color(0xFFE8EAED); // Divider color

  // Monday.com-style card accents (for highlight/trust sections)
  static const Color cardLavender = Color(0xFFE8F0FE); // Light blue/lavender
  static const Color cardAmber = Color(0xFFFFF8E1); // Soft yellow/amber
  static const Color cardGreen = Color(0xFFE8F5E8); // Soft green
  static const Color cardPurple = Color(0xFFF3E5F5); // Soft purple
  static const Color metricPurple = Color(
    0xFF6C5CE7,
  ); // Blue/purple for metric cards

  // Gradient colors for premium feel
  static const Color gradientStart = Color(0xFF1A73E8);
  static const Color gradientEnd = Color(0xFF4285F4);

  // Shadow with better opacity
  static BoxShadow get softShadow => BoxShadow(
    color: Colors.black.withValues(alpha: 0.08),
    blurRadius: 16,
    offset: const Offset(0, 4),
  );

  static BoxShadow get mediumShadow => BoxShadow(
    color: Colors.black.withValues(alpha: 0.12),
    blurRadius: 24,
    offset: const Offset(0, 6),
  );

  // Border radius - more modern
  static const double borderRadius = 16.0;
  static const double cardRadiusLarge = 24.0; // For large section cards
  static const double cardRadiusSmall = 12.0; // For smaller elements
}
