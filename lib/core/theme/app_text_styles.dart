import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headings (Playfair Display)
  static final TextStyle heading1 = GoogleFonts.playfairDisplay(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static final TextStyle heading2 = GoogleFonts.playfairDisplay(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body (Inter)
  static final TextStyle body = GoogleFonts.inter(
    fontSize: 16,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static final TextStyle bodySecondary = GoogleFonts.inter(
    fontSize: 14,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static final TextStyle button = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static final TextStyle caption = GoogleFonts.inter(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
}
