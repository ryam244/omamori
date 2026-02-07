// lib/core/constants/colors.dart

import 'package:flutter/material.dart';

/// Fortune Vault App Color Palette
/// Japanese shrine/temple aesthetic with modern design
class AppColors {
  AppColors._();

  // Primary Colors - Traditional Japanese Red (朱色)
  static const Color primary = Color(0xFFD32F2F);
  static const Color primaryLight = Color(0xFFFF6659);
  static const Color primaryDark = Color(0xFF9A0007);

  // Secondary Colors - Gold/Amber (金色)
  static const Color secondary = Color(0xFFFFA726);
  static const Color secondaryLight = Color(0xFFFFD95B);
  static const Color secondaryDark = Color(0xFFC77800);

  // Accent Colors - Indigo (藍色)
  static const Color accent = Color(0xFF3949AB);
  static const Color accentLight = Color(0xFF6F74DD);
  static const Color accentDark = Color(0xFF00227B);

  // Background Colors
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFFE0E0E0);

  // Fortune Grade Colors (運勢)
  static const Color fortuneDaikichi = Color(0xFFFFD700); // 大吉 - Gold
  static const Color fortuneKichi = Color(0xFFFF9800); // 吉 - Orange
  static const Color fortuneChuKichi = Color(0xFFFFC107); // 中吉 - Amber
  static const Color fortuneShoKichi = Color(0xFFFFEB3B); // 小吉 - Yellow
  static const Color fortuneKyo = Color(0xFF9E9E9E); // 凶 - Grey
  static const Color fortuneDaiKyo = Color(0xFF616161); // 大凶 - Dark Grey

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // UI Element Colors
  static const Color divider = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1F000000);
  static const Color overlay = Color(0x66000000);
  static const Color disabled = Color(0xFFBDBDBD);

  // Card Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBackgroundDark = Color(0xFF2C2C2C);
  static const Color cardBorder = Color(0xFFE0E0E0);

  // Camera UI Colors
  static const Color cameraGuide = Color(0xFFFFFFFF);
  static const Color cameraOverlay = Color(0xCC000000);
  static const Color cameraFocus = Color(0xFFFFD700);

  // Gradient Colors for Cards
  static const LinearGradient fortuneCardGradient = LinearGradient(
    colors: [Color(0xFFFFF8E1), Color(0xFFFFECB3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient actionTipGradient = LinearGradient(
    colors: [Color(0xFFE8EAF6), Color(0xFFC5CAE9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shimmer Effect Colors
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  /// Get fortune color by grade name
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
