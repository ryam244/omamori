// lib/features/result/presentation/widgets/summary_card.dart

import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/constants/layout.dart';

/// Summary Card - 一言要約
/// Displays the one-line fortune summary with fortune grade
class SummaryCard extends StatelessWidget {
  final String summary;
  final String? fortuneGrade;

  const SummaryCard({
    super.key,
    required this.summary,
    this.fortuneGrade,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppLayout.paddingLG,
      decoration: BoxDecoration(
        color: AppColors.fortuneCardBackground,
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
                Icons.auto_awesome,
                size: AppLayout.iconSM,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppLayout.space8),
              Text(
                '一言で言うと',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppLayout.space16),

          // Fortune grade badge (if available)
          if (fortuneGrade != null) ...[
            _buildFortuneGradeBadge(),
            const SizedBox(height: AppLayout.space12),
          ],

          // Summary text
          Text(
            summary,
            style: AppTextStyles.fortuneSummary,
          ),
        ],
      ),
    );
  }

  /// Fortune grade badge (大吉, 吉, etc.)
  Widget _buildFortuneGradeBadge() {
    final color = AppColors.getFortuneColor(fortuneGrade);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppLayout.space12,
        vertical: AppLayout.space4,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppLayout.radiusSM),
      ),
      child: Text(
        fortuneGrade!,
        style: AppTextStyles.fortuneGrade,
      ),
    );
  }
}
