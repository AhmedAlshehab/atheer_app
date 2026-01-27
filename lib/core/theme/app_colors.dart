import 'package:flutter/material.dart';

class AppColors {
  // Primary colors - Dark Green
  static const Color primaryDark = Color(0xFF1B4D3E);
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFF4CAF50);
  
  // Accent colors - Muted Gold
  static const Color accent = Color(0xFFD4AF37);
  static const Color accentLight = Color(0xFFFFD54F);
  static const Color accentDark = Color(0xFFC8A415);
  
  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFBDBDBD);
  static const Color textFaded = Color(0xFF9E9E9E);
  
  // Background colors (Modern Minimalist)
  static const Color background = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFFF5F5F5);
  static const Color cardBackground = Colors.white;

  // --- الألوان التي كانت ناقصة وتسببت في الخطأ ---
  static const Color glassWhite = Color(0x33FFFFFF); // أبيض شفاف للتأثير الزجاجي
  static const Color glassBorder = Color(0x4DFFFFFF); // حدود شفافة
  static const Color milkyWhite = Color(0xFFFDF5E6); // اللون الحليبي للأذكار
  // ----------------------------------------------
  
  // Status colors
  static const Color complete = Color(0xFF4CAF50);
  static const Color incomplete = Color(0xFFF44336);
  static const Color progress = Color(0xFFFF9800);
  
  // Card shadow color
  static const Color cardShadow = Color(0x0A000000);
  
  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1B4D3E), Color(0xFF2E7D32)],
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD4AF37), Color(0xFFFFD54F)],
  );
}