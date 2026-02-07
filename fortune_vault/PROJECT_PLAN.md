# Fortune Vault - Project Plan

## 1. Project Concept

**Fortune Vault** は、神社仏閣で引いた紙のおみくじを「撮る → 読める → 腑に落ちる → 残せる → 後で効く」に変えるモバイルアプリです。

### Core Value Proposition
- 難解な文面を **短時間で理解**（現代語・要約・行動提案）
- 「捨てずに残す」ではなく **"意味が育つ保存"**（振り返り機能）
- 現物おみくじを人生ログに変える（一次情報＝写真が核）

### Target Platform
- iOS (MVP)
- Android (Phase 2以降)

---

## 2. Current Status

**Phase 1: Project Setup & Architecture Design** 🚧

Flutter プロジェクトが作成され、技術スタックと基本構造の設計フェーズに入りました。

---

## 3. Tech Specification

### 3.1 Tech Stack
- **Framework:** Flutter 3.38.9 (Stable)
- **Language:** Dart 3.10.8
- **State Management:** Riverpod (preferred) or Provider
- **Routing:** go_router (declarative routing)
- **Database:** sqflite (SQLite for local storage)
- **Image Processing:**
  - `image_picker` - Camera & Gallery access
  - `image_cropper` - Manual crop functionality
  - `image` package - Image manipulation
- **OCR:**
  - `google_ml_kit` (Text Recognition v2) - Japanese vertical/horizontal text
- **LLM Integration:**
  - HTTP client with custom API (OpenAI/Anthropic/Gemini)
  - Structured JSON output for consistent parsing
- **UI Components:**
  - Material Design 3
  - Custom components for Fortune Card UI

### 3.2 Data Model

```dart
// lib/models/omikuji_entry.dart

class OmikujiEntry {
  final String id;                    // UUID
  final DateTime createdAt;           // 作成日時
  final String? shrineName;           // 神社名（任意）
  final String imageLocalPath;        // 画像のローカルパス
  final String ocrTextRaw;            // OCR生テキスト
  final FortuneAnalysis parsedJson;   // LLM解析結果
  final String? userMemo;             // ユーザーメモ
  final List<String> tags;            // タグ（任意）
  final int version;                  // 解析仕様バージョン
}

class FortuneAnalysis {
  final String? fortuneGrade;         // 運勢（大吉/吉/凶など）
  final String summaryOneLine;        // 一言要約
  final String modernTranslation;     // 現代語訳
  final String actionTipToday;        // 今日の一手（行動提案）
  final List<String> keywords;        // キーワード（2-5語）
  final int cautionLevel;             // 断定を避ける表現レベル (0-3)
}
```

### 3.3 Directory Structure

```
fortune_vault/
├── lib/
│   ├── main.dart                   # App entry point
│   ├── app.dart                    # Root app widget with routing
│   ├── core/
│   │   ├── constants/
│   │   │   ├── colors.dart         # App color palette
│   │   │   ├── text_styles.dart    # Typography
│   │   │   └── layout.dart         # Spacing, sizes
│   │   ├── theme/
│   │   │   └── app_theme.dart      # Material Theme configuration
│   │   ├── router/
│   │   │   └── app_router.dart     # go_router configuration
│   │   └── utils/
│   │       ├── logger.dart         # Logging utility
│   │       └── error_handler.dart  # Error handling
│   ├── features/
│   │   ├── home/
│   │   │   ├── presentation/
│   │   │   │   ├── screens/
│   │   │   │   │   └── home_screen.dart
│   │   │   │   └── widgets/
│   │   │   └── providers/
│   │   ├── camera/
│   │   │   ├── presentation/
│   │   │   │   ├── screens/
│   │   │   │   │   ├── camera_screen.dart
│   │   │   │   │   └── crop_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       └── camera_guide_overlay.dart
│   │   │   └── providers/
│   │   ├── processing/
│   │   │   ├── presentation/
│   │   │   │   └── screens/
│   │   │   │       └── processing_screen.dart
│   │   │   ├── services/
│   │   │   │   ├── ocr_service.dart
│   │   │   │   └── llm_service.dart
│   │   │   └── providers/
│   │   ├── result/
│   │   │   ├── presentation/
│   │   │   │   ├── screens/
│   │   │   │   │   └── result_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── summary_card.dart
│   │   │   │       ├── translation_card.dart
│   │   │   │       └── action_tip_card.dart
│   │   │   └── providers/
│   │   ├── history/
│   │   │   ├── presentation/
│   │   │   │   ├── screens/
│   │   │   │   │   ├── history_screen.dart
│   │   │   │   │   └── detail_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       └── fortune_card.dart
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── fortune_repository.dart
│   │   │   │   └── database/
│   │   │   │       └── fortune_database.dart
│   │   │   └── providers/
│   │   └── settings/
│   │       ├── presentation/
│   │       │   └── screens/
│   │       │       └── settings_screen.dart
│   │       └── providers/
│   └── models/
│       ├── omikuji_entry.dart
│       └── fortune_analysis.dart
├── assets/
│   ├── images/
│   └── fonts/
└── test/
```

### 3.4 Architecture Principles
- **Feature-First Structure:** 機能ごとにフォルダ分割
- **Clean Architecture:** Presentation / Domain / Data層の分離
- **Riverpod for DI:** 依存性注入とステート管理
- **Immutable Data Models:** freezed package使用
- **Repository Pattern:** データアクセス層の抽象化

---

## 4. Implementation Roadmap

### Phase 1: Project Setup & Foundation ✅
- [x] Flutter project creation
- [x] PROJECT_PLAN.md creation
- [x] Directory structure setup
- [x] Core constants (Colors, TextStyles, Layout)
- [x] Theme configuration (Material 3)
- [x] Router setup (go_router)
- [x] Add essential dependencies to pubspec.yaml
- [x] Data models implementation (OmikujiEntry, FortuneAnalysis)
- [ ] Database schema design (sqflite) - Phase 3

### Phase 2: MVP - Core UI Screens 🔄
- [x] **Home Screen**
  - [x] "撮影する" button with camera icon
  - [x] "履歴" button to navigate to history
  - [x] Empty state illustration
- [ ] **Camera Screen**
  - [ ] Camera preview integration
  - [ ] Guide overlay (frame + tips)
  - [ ] Capture button
  - [ ] Flash toggle
  - [ ] Gallery picker option
- [ ] **Crop Screen**
  - [ ] Auto-detect rectangle (image processing)
  - [ ] Manual crop with handles
  - [ ] Rotation controls
  - [ ] "次へ" button
- [ ] **Processing Screen**
  - [ ] Progress indicator (OCR → LLM)
  - [ ] Stage display ("読み取り中..." → "解析中...")
  - [ ] Failure handling UI
- [ ] **Result Screen (3段構成)**
  - [ ] ① 一言要約 (large, bold)
  - [ ] ② 現代語訳 (readable paragraphs)
  - [ ] ③ 今日の一手 (action card)
  - [ ] Save button with title/memo input
  - [ ] Original image thumbnail
- [ ] **History Screen**
  - [ ] Card list (最新順)
  - [ ] Fortune card component (image + summary + date)
  - [ ] Tap to navigate to detail
  - [ ] Empty state
- [ ] **Detail Screen**
  - [ ] Full image display
  - [ ] 3段結果表示
  - [ ] User memo
  - [ ] Share button (text/image)
  - [ ] Delete option

### Phase 3: Core Logic & Services 🔜
- [ ] **OCR Service Integration**
  - [ ] google_ml_kit text recognition setup
  - [ ] Japanese vertical/horizontal detection
  - [ ] Confidence level tracking
  - [ ] Error handling & retry logic
- [ ] **LLM Service Integration**
  - [ ] API client setup (HTTP)
  - [ ] Prompt engineering (fixed template)
  - [ ] JSON output parsing
  - [ ] NG word filtering
  - [ ] Fallback to "簡易モード" on failure
- [ ] **Image Processing**
  - [ ] Rectangle detection algorithm
  - [ ] Crop & rotation utilities
  - [ ] Image quality optimization
- [ ] **Database Implementation**
  - [ ] sqflite setup
  - [ ] CRUD operations for OmikujiEntry
  - [ ] Migration strategy
  - [ ] Query optimization

### Phase 4: State Management & Integration 🔜
- [ ] Riverpod providers setup
  - [ ] CameraProvider
  - [ ] ProcessingProvider
  - [ ] FortuneRepositoryProvider
  - [ ] HistoryProvider
- [ ] End-to-end flow integration
  - [ ] Camera → Crop → OCR → LLM → Save → History
- [ ] Error handling & recovery flows
  - [ ] OCR failure → re-capture tips
  - [ ] LLM failure → simplified output
  - [ ] Network timeout handling

### Phase 5: Polish & Testing 🔜
- [ ] Loading states refinement
- [ ] Error messages (user-friendly Japanese)
- [ ] Haptic feedback
- [ ] Animations & transitions
- [ ] Unit tests (services, repositories)
- [ ] Widget tests (critical screens)
- [ ] Integration tests (full flow)

### Phase 6: MVP Release Preparation 🔜
- [ ] App icon & splash screen
- [ ] Privacy policy & terms of service
- [ ] Analytics setup (optional)
- [ ] Crash reporting (Firebase Crashlytics)
- [ ] TestFlight build
- [ ] Beta testing (30-100 users)
- [ ] Bug fixes & iteration
- [ ] App Store submission materials
  - [ ] Screenshots
  - [ ] Description
  - [ ] Preview video

---

## 5. Phase 2+ Features (Nice to Have)

### Phase 2: Experience Extensions
- [ ] OCR text manual editing
- [ ] Interpretation style switching (励ます / ユーモア / 超辛口)
- [ ] SNS share card generation (templates)
- [ ] Search & filter (keywords, fortune grade, tags)
- [ ] Basic monetization (free tier limits, Pro subscription)

### Phase 3: Competitive Moat
- [ ] Shrine-specific templates (accuracy boost)
- [ ] Multi-language support (EN/ZH/KO) + cultural explanations
- [ ] Cloud sync (device migration)
- [ ] Reflection features (当たった/気づき/実行ログ)

---

## 6. Success Metrics (KPIs)

### MVP Goals
- **解析完了率**: >80% (OCR + LLM success rate)
- **保存率**: >60% (users who save after analysis)
- **翌週再訪率**: >30% (retention after 7 days)
- **共有率**: >15% (users who share results)

### Quality Metrics
- **撮影成功率**: >85% (first-time capture success)
- **結果納得感**: Qualitative feedback (beta testing)
- **クラッシュ率**: <1% (production stability)

---

## 7. Current Next Steps

1. ✅ Setup directory structure
2. ✅ Configure pubspec.yaml with dependencies
3. ✅ Implement core constants & theme
4. 🔄 Build Home Screen (starting point)
5. 🔄 Build Camera Screen with guide overlay
6. → Continue with Processing → Result → History flow

---

**Last Updated:** 2026-02-07
**Current Phase:** Phase 2 - MVP Core UI Screens
**Overall Progress:** 25% Complete
