// lib/features/history/presentation/screens/history_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/constants/layout.dart';
import '../../../../core/router/app_router.dart';
import '../../../../models/omikuji_entry.dart';
import '../../../../models/fortune_analysis.dart';
import '../widgets/fortune_card.dart';

/// History Screen - Fortune history list
/// Displays all saved fortune entries
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Mock data (will be replaced with database)
  late List<OmikujiEntry> _entries;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  /// Load entries from database (mock implementation)
  void _loadEntries() {
    // TODO: Replace with actual database query
    _entries = _generateMockEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('おみくじ履歴'),
        actions: [
          // Filter button (Phase 2+)
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filter
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('フィルター機能は開発中です'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            tooltip: 'フィルター',
          ),
        ],
      ),
      body: _entries.isEmpty ? _buildEmptyState() : _buildList(),
    );
  }

  /// Empty state
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: AppLayout.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.divider,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.auto_awesome_outlined,
                size: 60,
                color: AppColors.textHint,
              ),
            ),
            const SizedBox(height: AppLayout.space24),
            Text(
              'まだおみくじがありません',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppLayout.space8),
            Text(
              'おみくじを撮影して保存しましょう',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textHint,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppLayout.space32),
            ElevatedButton.icon(
              onPressed: () => context.go(AppRouter.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text('撮影する'),
            ),
          ],
        ),
      ),
    );
  }

  /// Fortune list
  Widget _buildList() {
    return Column(
      children: [
        // Stats summary
        _buildStatsSummary(),

        // List
        Expanded(
          child: ListView.builder(
            padding: AppLayout.screenPadding,
            itemCount: _entries.length,
            itemBuilder: (context, index) {
              final entry = _entries[index];
              return FortuneCard(
                entry: entry,
                onTap: () => _navigateToDetail(entry.id),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Stats summary
  Widget _buildStatsSummary() {
    final totalCount = _entries.length;
    final daikichi = _entries.where((e) => e.parsedJson.fortuneGrade == '大吉').length;
    final kichi = _entries.where((e) => e.parsedJson.fortuneGrade == '吉').length;

    return Container(
      margin: AppLayout.paddingMD,
      padding: AppLayout.paddingMD,
      decoration: BoxDecoration(
        color: AppColors.fortuneCardBackground,
        borderRadius: AppLayout.borderRadiusMD,
        border: Border.all(
          color: AppColors.border,
          width: AppLayout.cardBorderWidth,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('合計', totalCount.toString(), Icons.auto_awesome),
          _buildStatItem('大吉', daikichi.toString(), Icons.star),
          _buildStatItem('吉', kichi.toString(), Icons.favorite),
        ],
      ),
    );
  }

  /// Single stat item
  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: AppLayout.iconMD),
        const SizedBox(height: AppLayout.space4),
        Text(
          value,
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Navigate to detail screen
  void _navigateToDetail(String id) {
    context.push(AppRouter.detail.replaceFirst(':id', id));
  }

  /// Generate mock entries for demonstration
  List<OmikujiEntry> _generateMockEntries() {
    const uuid = Uuid();
    final now = DateTime.now();

    return [
      OmikujiEntry.create(
        id: uuid.v4(),
        imageLocalPath: '/mock/path1.jpg',
        ocrTextRaw: '大吉 願望叶う',
        parsedJson: FortuneAnalysis(
          fortuneGrade: '大吉',
          summaryOneLine: '新しいことを始めるのに最適な時期です',
          modernTranslation: 'あなたは今、とても運気の良い状態にあります。',
          actionTipToday: '今日は気になっていた新しいことに挑戦してみましょう。',
          keywords: ['挑戦', '新しい始まり'],
          analyzedAt: now,
        ),
        shrineName: '明治神宮',
      ),
      OmikujiEntry.create(
        id: uuid.v4(),
        imageLocalPath: '/mock/path2.jpg',
        ocrTextRaw: '吉 努力実る',
        parsedJson: FortuneAnalysis(
          fortuneGrade: '吉',
          summaryOneLine: 'コツコツ積み重ねた努力が実を結びます',
          modernTranslation: 'これまでの努力が認められる時期です。',
          actionTipToday: '焦らず、着実に進めていきましょう。',
          keywords: ['努力', '継続'],
          analyzedAt: now.subtract(const Duration(days: 3)),
        ),
        shrineName: '浅草寺',
      ),
      OmikujiEntry.create(
        id: uuid.v4(),
        imageLocalPath: '/mock/path3.jpg',
        ocrTextRaw: '中吉 健康運良好',
        parsedJson: FortuneAnalysis(
          fortuneGrade: '中吉',
          summaryOneLine: '健康に恵まれ、穏やかな日々が続きます',
          modernTranslation: '体調が良く、安定した日々を過ごせるでしょう。',
          actionTipToday: '規則正しい生活を心がけましょう。',
          keywords: ['健康', '安定'],
          analyzedAt: now.subtract(const Duration(days: 7)),
        ),
        shrineName: '伏見稲荷大社',
      ),
    ];
  }
}
