import 'package:flutter/material.dart';

/// Monday.com inspired color palette for the investor dashboard
class AppColors {
  // Background colors
  static const Color background = Color(0xFFFFFFFF); // Pure white
  static const Color sectionBackground = Color(0xFFF7F8FA); // Light grey

  // Primary colors
  static const Color primary = Color(0xFF0073EA); // Blue
  static const Color accent = Color(0xFF00C875); // Green

  // Text colors
  static const Color textPrimary = Color(0xFF323338); // Dark grey
  static const Color textSecondary = Color(0xFF676879);
  static const Color textLight = Color(0xFF9A9AA7);

  // Border and divider
  static const Color border = Color(0xFFE4E7EB);
  static const Color divider = Color(0xFFE4E7EB);

  // Monday.com-style card accents (for highlight/trust sections)
  static const Color cardLavender = Color(0xFFE8E4F9); // Light blue/lavender
  static const Color cardAmber = Color(0xFFFFF4E6);   // Soft yellow/amber
  static const Color cardGreen = Color(0xFFE6F7F0);   // Soft green
  static const Color metricPurple = Color(0xFF6C5CE7); // Blue/purple for metric cards

  // Shadow
  static BoxShadow get softShadow => BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 12,
        offset: const Offset(0, 2),
      );

  // Border radius
  static const double borderRadius = 14.0;
  static const double cardRadiusLarge = 20.0; // For large section cards (monday.com style)
}
