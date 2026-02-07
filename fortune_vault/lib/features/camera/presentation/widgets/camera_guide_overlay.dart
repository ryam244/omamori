// lib/features/camera/presentation/widgets/camera_guide_overlay.dart

import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/layout.dart';
import '../../../../core/constants/text_styles.dart';

/// Camera Guide Overlay Widget
/// Displays a guide frame and tips for capturing omikuji
class CameraGuideOverlay extends StatelessWidget {
  final VoidCallback? onFlashToggle;
  final bool isFlashOn;
  final VoidCallback? onGalleryPick;

  const CameraGuideOverlay({
    super.key,
    this.onFlashToggle,
    this.isFlashOn = false,
    this.onGalleryPick,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Semi-transparent overlay outside the guide frame
        _buildDarkOverlay(),

        // Guide frame in the center
        Center(
          child: _buildGuideFrame(),
        ),

        // Top controls (flash, close)
        Positioned(
          top: MediaQuery.of(context).padding.top + AppLayout.space16,
          left: AppLayout.space16,
          right: AppLayout.space16,
          child: _buildTopControls(context),
        ),

        // Bottom tips and gallery button
        Positioned(
          bottom: AppLayout.space24,
          left: AppLayout.space16,
          right: AppLayout.space16,
          child: _buildBottomControls(context),
        ),
      ],
    );
  }

  /// Dark overlay outside the guide frame
  Widget _buildDarkOverlay() {
    return Container(
      color: AppColors.cameraOverlay,
    );
  }

  /// Guide frame with corners
  Widget _buildGuideFrame() {
    return Container(
      width: AppLayout.cameraGuideSize.width,
      height: AppLayout.cameraGuideSize.height,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.cameraGuide,
          width: AppLayout.cameraGuideFrameThickness,
        ),
        borderRadius: BorderRadius.circular(AppLayout.radiusMD),
      ),
      child: Stack(
        children: [
          // Top-left corner
          _buildCorner(Alignment.topLeft),
          // Top-right corner
          _buildCorner(Alignment.topRight),
          // Bottom-left corner
          _buildCorner(Alignment.bottomLeft),
          // Bottom-right corner
          _buildCorner(Alignment.bottomRight),

          // Center guide text
          Center(
            child: Container(
              padding: AppLayout.paddingMD,
              decoration: BoxDecoration(
                color: AppColors.overlay,
                borderRadius: BorderRadius.circular(AppLayout.radiusSM),
              ),
              child: Text(
                'おみくじを枠内に\n収めてください',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textWhite,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Corner accent line
  Widget _buildCorner(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: AppLayout.cameraGuideCornerLength,
        height: AppLayout.cameraGuideCornerLength,
        decoration: BoxDecoration(
          border: Border(
            top: alignment.y < 0
                ? BorderSide(
                    color: AppColors.cameraFocus,
                    width: 3,
                  )
                : BorderSide.none,
            bottom: alignment.y > 0
                ? BorderSide(
                    color: AppColors.cameraFocus,
                    width: 3,
                  )
                : BorderSide.none,
            left: alignment.x < 0
                ? BorderSide(
                    color: AppColors.cameraFocus,
                    width: 3,
                  )
                : BorderSide.none,
            right: alignment.x > 0
                ? BorderSide(
                    color: AppColors.cameraFocus,
                    width: 3,
                  )
                : BorderSide.none,
          ),
        ),
      ),
    );
  }

  /// Top controls (flash, close)
  Widget _buildTopControls(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Flash toggle
        if (onFlashToggle != null)
          IconButton(
            onPressed: onFlashToggle,
            icon: Icon(
              isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: AppColors.textWhite,
              size: AppLayout.iconLG,
            ),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.overlay,
            ),
          ),
        const Spacer(),
        // Close button
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.close,
            color: AppColors.textWhite,
            size: AppLayout.iconLG,
          ),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.overlay,
          ),
        ),
      ],
    );
  }

  /// Bottom controls (tips, gallery)
  Widget _buildBottomControls(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tips
        Container(
          padding: AppLayout.paddingMD,
          decoration: BoxDecoration(
            color: AppColors.overlay,
            borderRadius: BorderRadius.circular(AppLayout.radiusSM),
          ),
          child: Column(
            children: [
              _buildTip(Icons.wb_sunny_outlined, '明るい場所で撮影'),
              const SizedBox(height: AppLayout.space8),
              _buildTip(Icons.center_focus_strong, '文字がはっきり見えるように'),
              const SizedBox(height: AppLayout.space8),
              _buildTip(Icons.straighten, '紙を平らにして撮影'),
            ],
          ),
        ),

        const SizedBox(height: AppLayout.space16),

        // Gallery picker button
        if (onGalleryPick != null)
          TextButton.icon(
            onPressed: onGalleryPick,
            icon: const Icon(Icons.photo_library, color: AppColors.textWhite),
            label: Text(
              'ギャラリーから選択',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textWhite,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.overlay,
              padding: const EdgeInsets.symmetric(
                horizontal: AppLayout.space20,
                vertical: AppLayout.space12,
              ),
            ),
          ),
      ],
    );
  }

  /// Single tip row
  Widget _buildTip(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.cameraFocus,
          size: AppLayout.iconSM,
        ),
        const SizedBox(width: AppLayout.space8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textWhite,
            ),
          ),
        ),
      ],
    );
  }
}
