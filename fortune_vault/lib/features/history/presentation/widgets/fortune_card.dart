// lib/features/history/presentation/widgets/fortune_card.dart

import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/constants/layout.dart';
import '../../../../models/omikuji_entry.dart';

/// Fortune Card Widget
/// Displays a compact fortune entry in the history list
class FortuneCard extends StatelessWidget {
  final OmikujiEntry entry;
  final VoidCallback? onTap;

  const FortuneCard({
    super.key,
    required this.entry,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppLayout.cardElevation,
      margin: const EdgeInsets.only(bottom: AppLayout.space12),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppLayout.borderRadiusMD,
        child: Padding(
          padding: AppLayout.paddingMD,
          child: Row(
            children: [
              // Image thumbnail
              _buildImageThumbnail(),

              const SizedBox(width: AppLayout.space12),

              // Content
              Expanded(
                child: _buildContent(),
              ),

              // Arrow icon
              const Icon(
                Icons.chevron_right,
                color: AppColors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Image thumbnail
  Widget _buildImageThumbnail() {
    return Container(
      width: AppLayout.fortuneCardImageSize,
      height: AppLayout.fortuneCardImageSize,
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: AppLayout.borderRadiusSM,
        border: Border.all(color: AppColors.divider),
      ),
      child: ClipRRect(
        borderRadius: AppLayout.borderRadiusSM,
        child: Image.file(
          File(entry.imageLocalPath),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.image_not_supported,
              color: AppColors.textHint,
            );
          },
        ),
      ),
    );
  }

  /// Content (summary + metadata)
  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fortune grade badge
        if (entry.parsedJson.fortuneGrade != null) ...[
          _buildFortuneGradeBadge(),
          const SizedBox(height: AppLayout.space4),
        ],

        // Summary (truncated)
        Text(
          entry.parsedJson.summaryOneLine,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: AppLayout.space4),

        // Metadata
        Row(
          children: [
            // Shrine name
            if (entry.shrineName != null && entry.shrineName!.isNotEmpty) ...[
              Icon(
                Icons.place,
                size: AppLayout.iconXS,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppLayout.space4),
              Flexible(
                child: Text(
                  entry.shrineName!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppLayout.space8),
            ],

            // Date
            Icon(
              Icons.calendar_today,
              size: AppLayout.iconXS,
              color: AppColors.textHint,
            ),
            const SizedBox(width: AppLayout.space4),
            Text(
              _formatDate(entry.createdAt),
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Fortune grade badge
  Widget _buildFortuneGradeBadge() {
    final color = AppColors.getFortuneColor(entry.parsedJson.fortuneGrade);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppLayout.space8,
        vertical: AppLayout.space2,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppLayout.radiusXS),
      ),
      child: Text(
        entry.parsedJson.fortuneGrade!,
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textWhite,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Format date
  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}';
  }
}
