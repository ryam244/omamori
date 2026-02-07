// lib/models/fortune_analysis.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'fortune_analysis.freezed.dart';
part 'fortune_analysis.g.dart';

/// LLM解析結果のデータモデル
/// 3段構成：一言要約 / 現代語訳 / 今日の一手
@freezed
class FortuneAnalysis with _$FortuneAnalysis {
  const factory FortuneAnalysis({
    /// 運勢（大吉/吉/凶など）- nullable
    String? fortuneGrade,

    /// 一言要約（1行）
    required String summaryOneLine,

    /// 現代語訳（本文）
    required String modernTranslation,

    /// 今日の一手（行動提案1つ）
    required String actionTipToday,

    /// キーワード（2-5語）
    @Default([]) List<String> keywords,

    /// 断定を避ける表現レベル (0: 通常, 1-3: 慎重)
    @Default(0) int cautionLevel,

    /// 解析日時
    DateTime? analyzedAt,

    /// 解析バージョン（LLMプロンプトの変更追跡用）
    @Default(1) int version,
  }) = _FortuneAnalysis;

  factory FortuneAnalysis.fromJson(Map<String, dynamic> json) =>
      _$FortuneAnalysisFromJson(json);

  /// 空の解析結果（初期化用）
  factory FortuneAnalysis.empty() => FortuneAnalysis(
        summaryOneLine: '',
        modernTranslation: '',
        actionTipToday: '',
        analyzedAt: DateTime.now(),
      );
}
