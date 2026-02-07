# Fortune Vault 🎋

**おみくじを撮って、意味を知ろう**

Fortune Vaultは、神社仏閣で引いた紙のおみくじを「撮る → 読める → 腑に落ちる → 残せる → 後で効く」に変えるモバイルアプリです。

[![Flutter](https://img.shields.io/badge/Flutter-3.38.9-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.10.8-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## ✨ 特徴

### 📸 撮影ガイド機能
- ガイドフレーム付きカメラUI
- 撮影のコツを表示（明るい場所、はっきり、平ら）
- フラッシュ切り替え対応
- ギャラリーからの選択も可能

### 🔍 OCR + AI解析
- **Google ML Kit**による高精度日本語OCR
- **LLM**（OpenAI/Anthropic対応）による解析
- 3段構成の結果表示：
  1. **一言要約** - パッと理解できる
  2. **現代語訳** - 難解な文面を読みやすく
  3. **今日の一手** - 具体的な行動提案

### 💾 ローカル保存
- SQLiteによるオフライン保存
- 神社名・メモ・タグ管理
- 履歴一覧・詳細表示
- キーワード検索機能

### 🎨 和風モダンデザイン
- Material Design 3準拠
- 神社仏閣の美学を取り入れた配色
  - 朱色（鳥居）
  - 金色（おみくじの紙）
  - 藍色（伝統色）
- 運勢別カラーコーディング

---

## 📱 スクリーンフロー

```
Home → Camera → Crop → Processing → Result → History
  ↓                                    ↓
Settings                             Detail
```

---

## 🛠️ 技術スタック

### フレームワーク
- **Flutter** 3.38.9
- **Dart** 3.10.8

### 主要パッケージ
- **riverpod** - State management
- **go_router** - Declarative routing
- **sqflite** - Local database
- **google_mlkit_text_recognition** - OCR
- **image_picker** / **image_cropper** - Image handling
- **freezed** / **json_serializable** - Data models

### アーキテクチャ
- **Clean Architecture** (Presentation / Domain / Data)
- **Feature-first structure**
- **Repository pattern**

---

## 🚀 セットアップ

### 必要要件
- Flutter SDK 3.38.9以上
- Dart 3.10.8以上
- iOS 12.0+ / Android 21+

### インストール

```bash
# リポジトリのクローン
git clone https://github.com/ryam244/omamori.git
cd omamori/fortune_vault

# 依存関係のインストール
flutter pub get

# コード生成
dart run build_runner build --delete-conflicting-outputs

# 実行
flutter run
```

### API設定（LLM解析用）

**方法1: 環境変数で設定（推奨・安全）**
```bash
# OpenAI APIキーを使って実行
flutter run --dart-define=OPENAI_API_KEY=sk-proj-your-key-here
```

**方法2: コードに直接設定（開発用のみ）**
```dart
// lib/features/processing/services/llm_service.dart の defaultValue を編集
static const String _openaiApiKey = String.fromEnvironment(
  'OPENAI_API_KEY',
  defaultValue: 'ここにAPIキーを入力', // ⚠️ Gitにコミットしない
);
```

**方法3: モックモード（APIキー不要）**
```dart
// lib/features/processing/presentation/screens/processing_screen.dart
final LlmService _llmService = LlmService(provider: LlmProvider.mock);
```

**注**: デフォルトは `LlmProvider.openai`。APIキーが空の場合、エラーメッセージが表示されます。

---

## 📂 プロジェクト構造

```
fortune_vault/
├── lib/
│   ├── app.dart                    # Root app widget
│   ├── main.dart                   # Entry point
│   ├── core/
│   │   ├── constants/              # Colors, TextStyles, Layout
│   │   ├── theme/                  # Material Theme
│   │   ├── router/                 # go_router config
│   │   └── utils/                  # Utilities
│   ├── features/
│   │   ├── home/                   # Home screen
│   │   ├── camera/                 # Camera & Crop
│   │   ├── processing/             # OCR & LLM processing
│   │   ├── result/                 # Result display (3-stage)
│   │   ├── history/                # History & Detail
│   │   └── settings/               # Settings
│   └── models/                     # Data models
├── assets/                         # Images & fonts
└── test/                           # Tests
```

---

## 🎯 データモデル

### OmikujiEntry
```dart
class OmikujiEntry {
  final String id;                  // UUID
  final DateTime createdAt;
  final String? shrineName;
  final String imageLocalPath;
  final String ocrTextRaw;
  final FortuneAnalysis parsedJson;
  final String? userMemo;
  final List<String> tags;
  final int version;
}
```

### FortuneAnalysis
```dart
class FortuneAnalysis {
  final String? fortuneGrade;       // 大吉/吉/凶など
  final String summaryOneLine;      // 一言要約
  final String modernTranslation;   // 現代語訳
  final String actionTipToday;      // 今日の一手
  final List<String> keywords;
  final int cautionLevel;
}
```

---

## 🔮 ロードマップ

### ✅ MVP (完了)
- [x] 全画面実装（Home, Camera, Crop, Processing, Result, History, Detail)
- [x] OCR統合（Google ML Kit）
- [x] LLM統合（OpenAI/Anthropic/Mock）
- [x] ローカルデータベース（SQLite）
- [x] 和風モダンデザイン

### 🔜 Phase 2
- [ ] OCRテキスト手動編集機能
- [ ] 解釈スタイル切替（励ます/ユーモア/辛口）
- [ ] SNS共有カード生成
- [ ] 検索・フィルター機能強化
- [ ] 課金プラン（Pro）

### 🚀 Phase 3
- [ ] 神社別テンプレート/文例ライブラリ
- [ ] 多言語対応（英/中/韓）
- [ ] クラウド同期
- [ ] 振り返り機能（当たった/気づき/実行ログ）

---

## 🤝 貢献

プルリクエストを歓迎します！バグ報告や機能リクエストは[Issues](https://github.com/ryam244/omamori/issues)へお願いします。

---

## 📄 ライセンス

MIT License - 詳細は[LICENSE](LICENSE)を参照してください。

---

## 🙏 謝辞

- **Google ML Kit** - 高精度OCR
- **Flutter Community** - 素晴らしいパッケージ群
- **Material Design 3** - デザインガイドライン

---

**Made with ❤️ and Flutter**

*おみくじの意味を、もっと身近に。*
