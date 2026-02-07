// lib/features/processing/presentation/screens/processing_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/constants/layout.dart';
import '../../../../core/router/app_router.dart';

/// Processing Screen - OCR and LLM analysis
/// Displays progress and handles errors gracefully
class ProcessingScreen extends StatefulWidget {
  final String imagePath;

  const ProcessingScreen({
    super.key,
    required this.imagePath,
  });

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  ProcessingStage _currentStage = ProcessingStage.ocr;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    // Start processing
    _startProcessing();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: AppLayout.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Animation
              _buildAnimation(),

              const SizedBox(height: AppLayout.space48),

              // Stage indicator
              _buildStageIndicator(),

              const SizedBox(height: AppLayout.space24),

              // Progress description
              _buildProgressDescription(),

              const Spacer(),

              // Error state
              if (_errorMessage != null) ...[
                _buildErrorState(),
                const SizedBox(height: AppLayout.space24),
              ],

              // Tips (only show during processing)
              if (_errorMessage == null) _buildTips(),

              const SizedBox(height: AppLayout.space48),
            ],
          ),
        ),
      ),
    );
  }

  /// Processing animation
  Widget _buildAnimation() {
    return RotationTransition(
      turns: _animationController,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.fortuneCardGradient,
          boxShadow: AppLayout.shadowLG,
        ),
        child: Icon(
          _currentStage == ProcessingStage.ocr
              ? Icons.document_scanner
              : Icons.psychology,
          size: 60,
          color: AppColors.primary,
        ),
      ),
    );
  }

  /// Stage indicator
  Widget _buildStageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStageDot(ProcessingStage.ocr),
        Container(
          width: 40,
          height: 2,
          color: _currentStage == ProcessingStage.llm
              ? AppColors.primary
              : AppColors.divider,
        ),
        _buildStageDot(ProcessingStage.llm),
      ],
    );
  }

  /// Single stage dot
  Widget _buildStageDot(ProcessingStage stage) {
    final isActive = _currentStage == stage;
    final isCompleted = stage == ProcessingStage.ocr &&
        _currentStage == ProcessingStage.llm;

    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive || isCompleted ? AppColors.primary : AppColors.divider,
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.divider,
          width: 2,
        ),
      ),
      child: isCompleted
          ? const Icon(
              Icons.check,
              size: 10,
              color: AppColors.textWhite,
            )
          : null,
    );
  }

  /// Progress description
  Widget _buildProgressDescription() {
    final stageText = _currentStage == ProcessingStage.ocr
        ? 'おみくじを読み取っています...'
        : 'おみくじを解析しています...';

    return Column(
      children: [
        Text(
          stageText,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppLayout.space8),
        Text(
          'しばらくお待ちください',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Error state
  Widget _buildErrorState() {
    return Container(
      padding: AppLayout.paddingMD,
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: AppLayout.borderRadiusMD,
        border: Border.all(color: AppColors.error),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 48,
          ),
          const SizedBox(height: AppLayout.space12),
          Text(
            _errorMessage!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.error,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppLayout.space16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: _retryProcessing,
                child: const Text('再試行'),
              ),
              const SizedBox(width: AppLayout.space12),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('戻る'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Tips during processing
  Widget _buildTips() {
    return Container(
      padding: AppLayout.paddingMD,
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: AppLayout.borderRadiusMD,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lightbulb_outline,
            color: AppColors.info,
            size: AppLayout.iconMD,
          ),
          const SizedBox(width: AppLayout.space12),
          Expanded(
            child: Text(
              '解析には数秒かかる場合があります',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.info,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Start processing (Mock implementation)
  Future<void> _startProcessing() async {
    try {
      // Stage 1: OCR
      setState(() {
        _currentStage = ProcessingStage.ocr;
        _errorMessage = null;
      });

      await Future.delayed(const Duration(seconds: 2));

      // Stage 2: LLM Analysis
      if (mounted) {
        setState(() => _currentStage = ProcessingStage.llm);
      }

      await Future.delayed(const Duration(seconds: 3));

      // Success - Navigate to result
      if (mounted) {
        context.go(
          AppRouter.result,
          extra: {
            'imagePath': widget.imagePath,
            'mockResult': true, // TODO: Replace with actual analysis result
          },
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = '解析に失敗しました: $e';
        });
      }
    }
  }

  /// Retry processing
  void _retryProcessing() {
    setState(() => _errorMessage = null);
    _startProcessing();
  }
}

/// Processing stages
enum ProcessingStage {
  ocr,
  llm,
}
