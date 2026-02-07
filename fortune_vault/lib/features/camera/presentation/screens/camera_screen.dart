// lib/features/camera/presentation/screens/camera_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/layout.dart';
import '../../../../core/router/app_router.dart';
import '../widgets/camera_guide_overlay.dart';

/// Camera Screen - Capture omikuji photo
/// Displays camera preview with guide overlay and capture controls
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isFlashOn = false;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview (Placeholder for now)
          // In production, use camera package for live preview
          _buildCameraPreviewPlaceholder(),

          // Guide Overlay
          CameraGuideOverlay(
            isFlashOn: _isFlashOn,
            onFlashToggle: _toggleFlash,
            onGalleryPick: _pickFromGallery,
          ),

          // Capture Button
          Positioned(
            bottom: AppLayout.space48,
            left: 0,
            right: 0,
            child: _buildCaptureButton(),
          ),
        ],
      ),
    );
  }

  /// Camera preview placeholder
  /// TODO: Replace with actual camera preview using camera package
  Widget _buildCameraPreviewPlaceholder() {
    return Container(
      color: Colors.grey[900],
      child: const Center(
        child: Icon(
          Icons.camera_alt_outlined,
          size: 120,
          color: Colors.white24,
        ),
      ),
    );
  }

  /// Capture button
  Widget _buildCaptureButton() {
    return Center(
      child: GestureDetector(
        onTap: _isProcessing ? null : _capturePhoto,
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.textWhite,
              width: 4,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.textWhite,
              ),
              child: _isProcessing
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  /// Toggle flash on/off
  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    // TODO: Implement actual flash control with camera package
  }

  /// Capture photo
  Future<void> _capturePhoto() async {
    setState(() => _isProcessing = true);

    try {
      // Use image picker to simulate camera capture
      // TODO: Replace with actual camera.takePicture() in production
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (photo != null && mounted) {
        // Navigate to crop screen with the captured image
        context.push(
          AppRouter.crop,
          extra: {'imagePath': photo.path},
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('撮影に失敗しました: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  /// Pick image from gallery
  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (image != null && mounted) {
        // Navigate to crop screen with the selected image
        context.push(
          AppRouter.crop,
          extra: {'imagePath': image.path},
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('画像の選択に失敗しました: $e');
      }
    }
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
