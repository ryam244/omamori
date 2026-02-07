// lib/features/result/presentation/screens/result_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/constants/layout.dart';
import '../../../../core/router/app_router.dart';
import '../../../../models/fortune_analysis.dart';
import '../widgets/summary_card.dart';
import '../widgets/translation_card.dart';
import '../widgets/action_tip_card.dart';

/// Result Screen - Fortune analysis results
/// Displays 3-stage results: Summary / Translation / Action Tip
class ResultScreen extends StatefulWidget {
  final String imagePath;
  final String? ocrText;
  final FortuneAnalysis? analysis;

  const ResultScreen({
    super.key,
    required this.imagePath,
    this.ocrText,
    this.analysis,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final TextEditingController _shrineNameController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();

  late FortuneAnalysis _analysis;
  late String _ocrText;

  @override
  void initState() {
    super.initState();

    // Use provided data or fallback to mock
    _ocrText = widget.ocrText ?? '（OCRテキストがありません）';
    _analysis = widget.analysis ??
        FortuneAnalysis(
          fortuneGrade: '大吉',
          summaryOneLine: '新しいことを始めるのに最適な時期です',
          modernTranslation:
              'あなたは今、とても運気の良い状態にあります。新しいことに挑戦するのに最適な時期です。'
              'これまで躊躇していたことがあれば、思い切って一歩踏み出してみましょう。'
              '周囲の人々もあなたを応援してくれるでしょう。ただし、慎重さも忘れずに。',
          actionTipToday: '今日は気になっていた新しいことに挑戦してみましょう。小さな一歩でも大丈夫です。',
          keywords: ['挑戦', '新しい始まり', '周囲のサポート'],
          analyzedAt: DateTime.now(),
        );
  }

  @override
  void dispose() {
    _shrineNameController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('おみくじの結果'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go(AppRouter.home),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareResult,
            tooltip: '共有',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppLayout.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Original image thumbnail
            _buildImageThumbnail(),

            const SizedBox(height: AppLayout.space24),

            // ① Summary Card (一言要約)
            SummaryCard(
              summary: _analysis.summaryOneLine,
              fortuneGrade: _analysis.fortuneGrade,
            ),

            const SizedBox(height: AppLayout.space20),

            // ② Translation Card (現代語訳)
            TranslationCard(
              translation: _analysis.modernTranslation,
              keywords: _analysis.keywords,
            ),

            const SizedBox(height: AppLayout.space20),

            // ③ Action Tip Card (今日の一手)
            ActionTipCard(
              actionTip: _analysis.actionTipToday,
            ),

            const SizedBox(height: AppLayout.space32),

            // Save section
            _buildSaveSection(),

            const SizedBox(height: AppLayout.space48),
          ],
        ),
      ),
    );
  }

  /// Original image thumbnail
  Widget _buildImageThumbnail() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppLayout.borderRadiusMD,
        boxShadow: AppLayout.shadowSM,
      ),
      child: ClipRRect(
        borderRadius: AppLayout.borderRadiusMD,
        child: Row(
          children: [
            // Image
            AspectRatio(
              aspectRatio: 0.7,
              child: Image.file(
                File(widget.imagePath),
                fit: BoxFit.cover,
              ),
            ),

            // Text info
            Expanded(
              child: Padding(
                padding: AppLayout.paddingMD,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '元の画像',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppLayout.space4),
                    Text(
                      '撮影日時: ${_formatDateTime(DateTime.now())}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Save section
  Widget _buildSaveSection() {
    return Container(
      padding: AppLayout.paddingLG,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppLayout.borderRadiusLG,
        boxShadow: AppLayout.shadowMD,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '保存',
            style: AppTextStyles.titleMedium,
          ),

          const SizedBox(height: AppLayout.space16),

          // Shrine name input
          TextField(
            controller: _shrineNameController,
            decoration: const InputDecoration(
              labelText: '神社・寺院名（任意）',
              hintText: '例: 明治神宮',
              prefixIcon: Icon(Icons.place),
            ),
          ),

          const SizedBox(height: AppLayout.space16),

          // Memo input
          TextField(
            controller: _memoController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'メモ（任意）',
              hintText: '気づいたことや感想を記録',
              prefixIcon: Icon(Icons.edit_note),
            ),
          ),

          const SizedBox(height: AppLayout.space20),

          // Save button
          SizedBox(
            width: double.infinity,
            height: AppLayout.buttonHeightLG,
            child: ElevatedButton.icon(
              onPressed: _saveResult,
              icon: const Icon(Icons.save),
              label: const Text('保存して履歴へ'),
            ),
          ),
        ],
      ),
    );
  }

  /// Format date time
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month}/${dateTime.day} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Share result
  void _shareResult() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('共有機能は開発中です'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Save result
  void _saveResult() {
    // TODO: Implement actual save to database
    // For now, just navigate to history
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('保存しました！'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate to history after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.go(AppRouter.history);
      }
    });
  }
}
