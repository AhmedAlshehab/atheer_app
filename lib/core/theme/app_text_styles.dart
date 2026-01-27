import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'package:flutter/services.dart';

class AppTextStyles {
  // Arabic text styles
  static TextStyle arabicTitleLarge = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static TextStyle arabicTitleMedium = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static TextStyle arabicBodyLarge = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.8,
  );
  
  static TextStyle arabicBodyMedium = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.8,
  );
  
  static TextStyle arabicBodySmall = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textFaded,
    height: 1.6,
    fontStyle: FontStyle.italic,
  );
  
  static TextStyle arabicBlessing = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: AppColors.textFaded.withOpacity(0.7),
    height: 1.4,
    fontStyle: FontStyle.italic,
  );
  
  // English text styles
  static TextStyle englishTitleLarge = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  
  static TextStyle englishTitleMedium = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static TextStyle englishBodyMedium = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  
  static TextStyle englishBodySmall = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: AppColors.textLight,
  );
  
  // Counter text styles
  static TextStyle counterText = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  
  static TextStyle counterTextSmall = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
  
  // Tab text styles
  static TextStyle tabTextSelected = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  
  static TextStyle tabTextUnselected = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white.withOpacity(0.8),
  );
}