import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headings - Playfair Display
  // Used for screen titles, wordmarks, and high-impact labels
  static final TextStyle displayLarge = GoogleFonts.playfairDisplay(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static final TextStyle displayMedium = GoogleFonts.playfairDisplay(
    fontSize: 24,
    fontWeight: FontWeight.semiBold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static final TextStyle displaySmall = GoogleFonts.playfairDisplay(
    fontSize: 20,
    fontWeight: FontWeight.medium,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  // Body - Inter
  // Used for general content, descriptions, and labels
  static final TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static final TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static final TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // UI Labels - Inter
  // Used for buttons, tabs, and metadata
  static final TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.semiBold,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static final TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.bold,
    color: AppColors.gold,
    letterSpacing: 1.2,
    textCase: TextCase.upperCase, // For eyebrow labels: "TALENTHUB+ · EST. 2026"
  );
}
