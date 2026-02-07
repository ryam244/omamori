// lib/features/home/presentation/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/constants/layout.dart';
import '../../../../core/router/app_router.dart';

/// Home Screen - Entry point of the app
/// Displays main actions: Take Photo, View History
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppLayout.screenPadding,
          child: Column(
            children: [
              const SizedBox(height: AppLayout.space32),

              // App Logo / Title
              _buildHeader(context),

              const SizedBox(height: AppLayout.space48),

              // Main illustration / Empty state
              Expanded(
                child: _buildIllustration(context),
              ),

              const SizedBox(height: AppLayout.space48),

              // Main action buttons
              _buildActionButtons(context),

              const SizedBox(height: AppLayout.space24),
            ],
          ),
        ),
      ),
    );
  }

  /// Header with app title and subtitle
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        // App Icon/Logo (placeholder)
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.fortuneCardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.border,
              width: AppLayout.cardBorderWidth,
            ),
          ),
          child: const Icon(
            Icons.auto_awesome,
            size: 48,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppLayout.space16),

        // App Title
        Text(
          'Fortune Vault',
          style: AppTextStyles.displayMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppLayout.space8),

        // Subtitle
        Text(
          'おみくじを撮って、意味を知ろう',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Illustration / Empty state
  Widget _buildIllustration(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Fortune paper illustration (placeholder)
          Container(
            width: 200,
            height: 280,
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.divider,
                width: 2,
              ),
              boxShadow: AppLayout.shadowSM,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  size: 64,
                  color: AppColors.textHint,
                ),
                const SizedBox(height: AppLayout.space16),
                Text(
                  'おみくじを撮影して\n解析しましょう',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Main action buttons
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Take Photo Button (Primary)
        SizedBox(
          width: double.infinity,
          height: AppLayout.buttonHeightLG,
          child: ElevatedButton.icon(
            onPressed: () => context.push(AppRouter.camera),
            icon: const Icon(Icons.camera_alt, size: AppLayout.iconMD),
            label: const Text('おみくじを撮影する'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textWhite,
              elevation: 4,
              shadowColor: AppColors.primary.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppLayout.radiusMD),
              ),
            ),
          ),
        ),

        const SizedBox(height: AppLayout.space16),

        // View History Button (Secondary)
        SizedBox(
          width: double.infinity,
          height: AppLayout.buttonHeightLG,
          child: OutlinedButton.icon(
            onPressed: () => context.push(AppRouter.history),
            icon: const Icon(Icons.history, size: AppLayout.iconMD),
            label: const Text('履歴を見る'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppLayout.radiusMD),
              ),
            ),
          ),
        ),

        const SizedBox(height: AppLayout.space16),

        // Settings link
        TextButton.icon(
          onPressed: () => context.push(AppRouter.settings),
          icon: const Icon(Icons.settings, size: AppLayout.iconSM),
          label: const Text('設定'),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
