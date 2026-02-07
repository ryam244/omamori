// lib/features/camera/presentation/screens/crop_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/constants/layout.dart';
import '../../../../core/router/app_router.dart';

/// Crop Screen - Manual image cropping
/// Allows user to adjust the captured image before OCR processing
class CropScreen extends StatefulWidget {
  final String imagePath;

  const CropScreen({
    super.key,
    required this.imagePath,
  });

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  File? _imageFile;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _imageFile = File(widget.imagePath);
    // Auto-crop on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openCropper();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('画像の調整'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isProcessing
          ? _buildLoadingState()
          : _imageFile != null
              ? _buildImagePreview()
              : _buildErrorState(),
    );
  }

  /// Loading state
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: AppLayout.space16),
          Text('処理中...'),
        ],
      ),
    );
  }

  /// Image preview with action buttons
  Widget _buildImagePreview() {
    return Column(
      children: [
        // Image preview
        Expanded(
          child: Container(
            margin: AppLayout.paddingMD,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppLayout.borderRadiusMD,
              boxShadow: AppLayout.shadowMD,
            ),
            child: ClipRRect(
              borderRadius: AppLayout.borderRadiusMD,
              child: Image.file(
                _imageFile!,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        // Action buttons
        Padding(
          padding: AppLayout.paddingMD,
          child: Column(
            children: [
              // Re-crop button
              SizedBox(
                width: double.infinity,
                height: AppLayout.buttonHeightMD,
                child: OutlinedButton.icon(
                  onPressed: _openCropper,
                  icon: const Icon(Icons.crop),
                  label: const Text('再調整'),
                ),
              ),

              const SizedBox(height: AppLayout.space12),

              // Next button
              SizedBox(
                width: double.infinity,
                height: AppLayout.buttonHeightLG,
                child: ElevatedButton.icon(
                  onPressed: _proceedToProcessing,
                  icon: const Icon(Icons.check),
                  label: const Text('この画像で解析'),
                ),
              ),

              const SizedBox(height: AppLayout.space8),

              // Tip text
              Text(
                '※ 文字がはっきり読めるか確認してください',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Error state
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: AppLayout.space16),
          const Text('画像の読み込みに失敗しました'),
          const SizedBox(height: AppLayout.space24),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('戻る'),
          ),
        ],
      ),
    );
  }

  /// Open image cropper
  Future<void> _openCropper() async {
    if (_imageFile == null) return;

    setState(() => _isProcessing = true);

    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _imageFile!.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'おみくじの範囲を調整',
            toolbarColor: AppColors.primary,
            toolbarWidgetColor: AppColors.textWhite,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
            ],
            activeControlsWidgetColor: AppColors.primary,
            cropGridColor: AppColors.cameraFocus,
            cropFrameColor: AppColors.primary,
          ),
          IOSUiSettings(
            title: 'おみくじの範囲を調整',
            doneButtonTitle: '完了',
            cancelButtonTitle: 'キャンセル',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
            ],
            rectX: 0.2,
            rectY: 0.2,
            rectWidth: 0.6,
            rectHeight: 0.6,
          ),
        ],
      );

      if (croppedFile != null && mounted) {
        setState(() {
          _imageFile = File(croppedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('画像の調整に失敗しました: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  /// Proceed to processing screen
  void _proceedToProcessing() {
    if (_imageFile == null) return;

    // Navigate to processing screen with the cropped image
    context.push(
      AppRouter.processing,
      extra: {'imagePath': _imageFile!.path},
    );
  }

  /// Show error snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
