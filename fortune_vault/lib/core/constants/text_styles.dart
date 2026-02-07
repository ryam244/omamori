// lib/core/constants/text_styles.dart

import 'package:flutter/material.dart';
import 'colors.dart';

/// Fortune Vault App Text Styles
/// Japanese-inspired typography with modern readability
class AppTextStyles {
  AppTextStyles._();

  // Base Font Family
  static const String fontFamily = 'NotoSansJP'; // Can be changed to custom font

  // Display Styles (Very Large)
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.3,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.3,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  // Headline Styles (Large)
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  // Title Styles (Medium-Large)
  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.1,
    color: AppColors.textPrimary,
  );

  // Body Styles (Regular Text)
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.7,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.7,
    letterSpacing: 0.25,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0.4,
    color: AppColors.textSecondary,
  );

  // Label Styles (Small, Buttons)
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.1,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.5,
    color: AppColors.textSecondary,
  );

  // Special Purpose Styles

  /// For one-line fortune summary (一言要約)
  static const TextStyle fortuneSummary = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    height: 1.4,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  /// For modern translation body (現代語訳)
  static const TextStyle fortuneTranslation = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.8,
    letterSpacing: 0.3,
    color: AppColors.textPrimary,
  );

  /// For action tip (今日の一手)
  static const TextStyle actionTip = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.7,
    letterSpacing: 0.2,
    color: AppColors.accent,
  );

  /// For fortune grade badge (大吉, 吉, etc.)
  static const TextStyle fortuneGrade = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: 1.0,
    color: AppColors.textWhite,
  );

  /// For OCR raw text display
  static const TextStyle ocrText = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.8,
    letterSpacing: 0.2,
    fontFamily: 'monospace',
    color: AppColors.textSecondary,
  );

  /// For shrine/temple name
  static const TextStyle shrineName = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.5,
    color: AppColors.textSecondary,
  );

  /// For date display
  static const TextStyle dateText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,
    letterSpacing: 0.4,
    color: AppColors.textHint,
  );

  /// Button text
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
    color: AppColors.textWhite,
  );

  /// Error message
  static const TextStyle error = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.25,
    color: AppColors.error,
  );
}
