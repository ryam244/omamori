// lib/models/omikuji_entry.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'fortune_analysis.dart';

part 'omikuji_entry.freezed.dart';
part 'omikuji_entry.g.dart';

/// おみくじエントリーのデータモデル
/// 画像、OCR結果、LLM解析、ユーザーメモを含む
@freezed
class OmikujiEntry with _$OmikujiEntry {
  const factory OmikujiEntry({
    /// UUID
    required String id,

    /// 作成日時
    required DateTime createdAt,

    /// 神社名（任意）
    String? shrineName,

    /// 画像のローカルパス
    required String imageLocalPath,

    /// OCR生テキスト
    required String ocrTextRaw,

    /// LLM解析結果
    required FortuneAnalysis parsedJson,

    /// ユーザーメモ
    String? userMemo,

    /// タグ（任意、複数可）
    @Default([]) List<String> tags,

    /// 解析仕様バージョン
    @Default(1) int version,

    /// 更新日時（最終編集時刻）
    DateTime? updatedAt,

    /// お気に入りフラグ（Phase 2以降で使用）
    @Default(false) bool isFavorite,
  }) = _OmikujiEntry;

  factory OmikujiEntry.fromJson(Map<String, dynamic> json) =>
      _$OmikujiEntryFromJson(json);

  /// 新規作成用のファクトリーコンストラクタ
  factory OmikujiEntry.create({
    required String id,
    required String imageLocalPath,
    required String ocrTextRaw,
    required FortuneAnalysis parsedJson,
    String? shrineName,
    String? userMemo,
    List<String>? tags,
  }) {
    final now = DateTime.now();
    return OmikujiEntry(
      id: id,
      createdAt: now,
      updatedAt: now,
      shrineName: shrineName,
      imageLocalPath: imageLocalPath,
      ocrTextRaw: ocrTextRaw,
      parsedJson: parsedJson,
      userMemo: userMemo,
      tags: tags ?? [],
      version: 1,
      isFavorite: false,
    );
  }
}

/// OmikujiEntry拡張メソッド
extension OmikujiEntryX on OmikujiEntry {
  /// タイトルを生成（神社名 + 日付 or 一言要約）
  String get title {
    if (shrineName != null && shrineName!.isNotEmpty) {
      return '$shrineName - ${_formattedDate}';
    }
    if (parsedJson.summaryOneLine.isNotEmpty) {
      return parsedJson.summaryOneLine;
    }
    return '無題のおみくじ - $_formattedDate';
  }

  /// 日付表示用フォーマット（例: 2026年2月7日）
  String get _formattedDate {
    return '${createdAt.year}年${createdAt.month}月${createdAt.day}日';
  }

  /// 運勢グレードを取得（nullの場合は'不明'）
  String get fortuneGradeDisplay {
    return parsedJson.fortuneGrade ?? '不明';
  }

  /// タグを含むかチェック
  bool hasTag(String tag) {
    return tags.contains(tag);
  }

  /// キーワードを含むかチェック（検索用）
  bool containsKeyword(String keyword) {
    final lowerKeyword = keyword.toLowerCase();
    return parsedJson.summaryOneLine.toLowerCase().contains(lowerKeyword) ||
        parsedJson.modernTranslation.toLowerCase().contains(lowerKeyword) ||
        parsedJson.keywords.any((k) => k.toLowerCase().contains(lowerKeyword)) ||
        (shrineName?.toLowerCase().contains(lowerKeyword) ?? false) ||
        (userMemo?.toLowerCase().contains(lowerKeyword) ?? false);
  }
}
