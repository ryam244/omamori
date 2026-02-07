// lib/features/history/presentation/screens/detail_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/constants/layout.dart';
import '../../../../models/omikuji_entry.dart';
import '../../../result/presentation/widgets/summary_card.dart';
import '../../../result/presentation/widgets/translation_card.dart';
import '../../../result/presentation/widgets/action_tip_card.dart';

/// Detail Screen - Fortune entry detail view
/// Displays full analysis with sharing capabilities
class DetailScreen extends StatefulWidget {
  final String entryId;

  const DetailScreen({
    super.key,
    required this.entryId,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  OmikujiEntry? _entry;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEntry();
  }

  /// Load entry from database
  Future<void> _loadEntry() async {
    setState(() => _isLoading = true);

    // TODO: Load from actual database
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data for now
    // In production, query database by widget.entryId

    setState(() {
      _isLoading = false;
      // _entry = ... (from database)
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_entry == null) {
      return _buildNotFoundState();
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // App bar with image
          _buildSliverAppBar(),

          // Content
          SliverPadding(
            padding: AppLayout.screenPadding,
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Metadata
                _buildMetadata(),

                const SizedBox(height: AppLayout.space24),

                // Summary card
                SummaryCard(
                  summary: _entry!.parsedJson.summaryOneLine,
                  fortuneGrade: _entry!.parsedJson.fortuneGrade,
                ),

                const SizedBox(height: AppLayout.space20),

                // Translation card
                TranslationCard(
                  translation: _entry!.parsedJson.modernTranslation,
                  keywords: _entry!.parsedJson.keywords,
                ),

                const SizedBox(height: AppLayout.space20),

                // Action tip card
                ActionTipCard(
                  actionTip: _entry!.parsedJson.actionTipToday,
                ),

                const SizedBox(height: AppLayout.space32),

                // User memo (if exists)
                if (_entry!.userMemo != null && _entry!.userMemo!.isNotEmpty)
                  _buildMemoSection(),

                const SizedBox(height: AppLayout.space32),

                // OCR raw text (expandable)
                _buildOcrSection(),

                const SizedBox(height: AppLayout.space48),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  /// Sliver app bar with image
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: _entry != null
            ? Image.file(
                File(_entry!.imageLocalPath),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.backgroundLight,
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 64,
                      color: AppColors.textHint,
                    ),
                  );
                },
              )
            : null,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: _shareEntry,
          tooltip: '共有',
        ),
        PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 12),
                  Text('編集'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: AppColors.error),
                  SizedBox(width: 12),
                  Text('削除', style: TextStyle(color: AppColors.error)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              _editEntry();
            } else if (value == 'delete') {
              _deleteEntry();
            }
          },
        ),
      ],
    );
  }

  /// Metadata section
  Widget _buildMetadata() {
    if (_entry == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          _entry!.title,
          style: AppTextStyles.headlineMedium,
        ),

        const SizedBox(height: AppLayout.space12),

        // Metadata chips
        Wrap(
          spacing: AppLayout.space8,
          runSpacing: AppLayout.space8,
          children: [
            // Date
            _buildMetadataChip(
              Icons.calendar_today,
              _formatDate(_entry!.createdAt),
            ),

            // Shrine name
            if (_entry!.shrineName != null && _entry!.shrineName!.isNotEmpty)
              _buildMetadataChip(
                Icons.place,
                _entry!.shrineName!,
              ),

            // Tags
            ..._entry!.tags.map((tag) => _buildTagChip(tag)),
          ],
        ),
      ],
    );
  }

  /// Metadata chip
  Widget _buildMetadataChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppLayout.space12,
        vertical: AppLayout.space6,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(AppLayout.radiusSM),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppLayout.iconXS, color: AppColors.textSecondary),
          const SizedBox(width: AppLayout.space4),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Tag chip
  Widget _buildTagChip(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppLayout.space12,
        vertical: AppLayout.space6,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppLayout.radiusSM),
      ),
      child: Text(
        '#$tag',
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.primary,
        ),
      ),
    );
  }

  /// Memo section
  Widget _buildMemoSection() {
    return Container(
      padding: AppLayout.paddingMD,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppLayout.borderRadiusMD,
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.edit_note,
                size: AppLayout.iconSM,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppLayout.space8),
              Text(
                'メモ',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppLayout.space12),
          Text(
            _entry!.userMemo!,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  /// OCR section (expandable)
  Widget _buildOcrSection() {
    return ExpansionTile(
      leading: const Icon(Icons.document_scanner),
      title: const Text('読み取りテキスト（OCR）'),
      children: [
        Container(
          width: double.infinity,
          padding: AppLayout.paddingMD,
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: AppLayout.borderRadiusSM,
          ),
          child: Text(
            _entry?.ocrTextRaw ?? '読み取りテキストがありません',
            style: AppTextStyles.ocrText,
          ),
        ),
      ],
    );
  }

  /// Bottom action bar
  Widget _buildBottomBar() {
    return Container(
      padding: AppLayout.paddingMD,
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _copyToClipboard,
                icon: const Icon(Icons.copy),
                label: const Text('コピー'),
              ),
            ),
            const SizedBox(width: AppLayout.space12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _shareEntry,
                icon: const Icon(Icons.share),
                label: const Text('共有'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Not found state
  Widget _buildNotFoundState() {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textHint,
            ),
            const SizedBox(height: AppLayout.space16),
            const Text('おみくじが見つかりませんでした'),
            const SizedBox(height: AppLayout.space24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('戻る'),
            ),
          ],
        ),
      ),
    );
  }

  /// Format date
  String _formatDate(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日';
  }

  /// Share entry
  void _shareEntry() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('共有機能は開発中です'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Copy to clipboard
  void _copyToClipboard() {
    if (_entry == null) return;

    final text = '''
【${_entry!.parsedJson.fortuneGrade ?? 'おみくじ'}】${_entry!.shrineName ?? ''}

${_entry!.parsedJson.summaryOneLine}

${_entry!.parsedJson.modernTranslation}

今日の一手：
${_entry!.parsedJson.actionTipToday}
    ''';

    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('クリップボードにコピーしました'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Edit entry
  void _editEntry() {
    // TODO: Navigate to edit screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('編集機能は開発中です'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Delete entry
  void _deleteEntry() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('削除の確認'),
        content: const Text('このおみくじを削除してもよろしいですか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Delete from database
              Navigator.of(context).pop();
              context.pop(); // Go back to history
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('削除しました'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text(
              '削除',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
