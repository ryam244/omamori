// lib/features/result/presentation/widgets/action_tip_card.dart

import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/constants/layout.dart';

/// Action Tip Card - 今日の一手
/// Displays actionable advice based on the fortune
class ActionTipCard extends StatelessWidget {
  final String actionTip;

  const ActionTipCard({
    super.key,
    required this.actionTip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppLayout.paddingLG,
      decoration: BoxDecoration(
        color: AppColors.actionTipBackground,
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
                Icons.lightbulb,
                size: AppLayout.iconSM,
                color: AppColors.accent,
              ),
              const SizedBox(width: AppLayout.space8),
              Text(
                '今日の一手',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.accent,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppLayout.space16),

          // Action tip text
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: AppLayout.space12),
              Expanded(
                child: Text(
                  actionTip,
                  style: AppTextStyles.actionTip,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
