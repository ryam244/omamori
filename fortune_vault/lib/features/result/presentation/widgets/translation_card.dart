// lib/features/result/presentation/widgets/translation_card.dart

import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/constants/layout.dart';

/// Translation Card - 現代語訳
/// Displays the modern Japanese translation of the fortune
class TranslationCard extends StatelessWidget {
  final String translation;
  final List<String> keywords;

  const TranslationCard({
    super.key,
    required this.translation,
    this.keywords = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppLayout.paddingLG,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppLayout.borderRadiusLG,
        border: Border.all(
          color: AppColors.border,
          width: AppLayout.cardBorderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Row(
            children: [
              const Icon(
                Icons.translate,
                size: AppLayout.iconSM,
                color: AppColors.accent,
              ),
              const SizedBox(width: AppLayout.space8),
              Text(
                '現代語訳',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.accent,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppLayout.space16),

          // Translation text
          Text(
            translation,
            style: AppTextStyles.fortuneTranslation,
          ),

          // Keywords (if available)
          if (keywords.isNotEmpty) ...[
            const SizedBox(height: AppLayout.space20),
            const Divider(),
            const SizedBox(height: AppLayout.space12),
            Wrap(
              spacing: AppLayout.space8,
              runSpacing: AppLayout.space8,
              children: keywords.map((keyword) => _buildKeywordChip(keyword)).toList(),
            ),
          ],
        ],
      ),
    );
  }

  /// Keyword chip
  Widget _buildKeywordChip(String keyword) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppLayout.space12,
        vertical: AppLayout.space4,
      ),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppLayout.radiusSM),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
        ),
      ),
      child: Text(
        keyword,
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.accent,
        ),
      ),
    );
  }
}
