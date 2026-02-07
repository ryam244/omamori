// lib/core/constants/colors.dart

import 'package:flutter/material.dart';

/// Fortune Vault App Color Palette - MINIMAL DESIGN
/// Modern, clean aesthetic with monochrome + single accent
class AppColors {
  AppColors._();

  // Primary Colors - Indigo (single accent color)
  static const Color primary = Color(0xFF3F51B5); // Indigo 700
  static const Color primaryLight = Color(0xFF757DE8); // Indigo 400
  static const Color primaryDark = Color(0xFF002984); // Indigo 900

  // Monochrome palette
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);

  // Secondary/Accent - Minimal approach (same as primary)
  static const Color secondary = Color(0xFF3F51B5);
  static const Color secondaryLight = Color(0xFF757DE8);
  static const Color secondaryDark = Color(0xFF002984);
  static const Color accent = Color(0xFF3F51B5);
  static const Color accentLight = Color(0xFF757DE8);
  static const Color accentDark = Color(0xFF002984);

  // Background Colors
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFFE0E0E0);

  // Fortune Grade Colors (subtle, monochrome-based)
  static const Color fortuneDaikichi = Color(0xFF212121); // 大吉 - Black
  static const Color fortuneKichi = Color(0xFF424242); // 吉 - Dark Gray
  static const Color fortuneChuKichi = Color(0xFF616161); // 中吉 - Gray
  static const Color fortuneShoKichi = Color(0xFF757575); // 小吉 - Gray
  static const Color fortuneKyo = Color(0xFF9E9E9E); // 凶 - Light Gray
  static const Color fortuneDaiKyo = Color(0xFFBDBDBD); // 大凶 - Very Light Gray

  // Semantic Colors (minimal)
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // UI Element Colors
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x0A000000); // Very subtle
  static const Color overlay = Color(0x66000000);
  static const Color disabled = Color(0xFFBDBDBD);

  // Card Colors (flat, no gradients)
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBackgroundDark = Color(0xFF2C2C2C);
  static const Color cardBorder = Color(0xFFE0E0E0);

  // Camera UI Colors
  static const Color cameraGuide = Color(0xFF212121);
  static const Color cameraOverlay = Color(0xCC000000);
  static const Color cameraFocus = Color(0xFF3F51B5); // Primary

  // Solid colors instead of gradients for minimal design
  static const Color fortuneCardBackground = Color(0xFFFAFAFA); // gray50
  static const Color actionTipBackground = Color(0xFFF5F5F5); // gray100

  // Shimmer Effect Colors
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  /// Get fortune color by grade name (monochrome)
  static Color getFortuneColor(String? grade) {
    if (grade == null) return textSecondary;

    final normalized = grade.toLowerCase().trim();
    switch (normalized) {
      case '大吉':
      case 'だいきち':
      case 'daikichi':
        return fortuneDaikichi;
      case '吉':
      case 'きち':
      case 'kichi':
        return fortuneKichi;
      case '中吉':
      case 'ちゅうきち':
      case 'chukichi':
        return fortuneChuKichi;
      case '小吉':
      case 'しょうきち':
      case 'shokichi':
        return fortuneShoKichi;
      case '凶':
      case 'きょう':
      case 'kyo':
        return fortuneKyo;
      case '大凶':
      case 'だいきょう':
      case 'daikyo':
        return fortuneDaiKyo;
      default:
        return textSecondary;
    }
  }
}
