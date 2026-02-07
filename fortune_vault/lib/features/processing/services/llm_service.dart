// lib/features/processing/services/llm_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../models/fortune_analysis.dart';

/// LLM Service
/// Analyzes fortune text using Large Language Models
class LlmService {
  // API Keys - Set via environment variables or defaultValue for local development
  // Usage: flutter run --dart-define=OPENAI_API_KEY=sk-...
  static const String _openaiApiKey = String.fromEnvironment(
    'OPENAI_API_KEY',
    defaultValue: '', // Add your key here for local testing
  );
  static const String _anthropicApiKey = String.fromEnvironment(
    'ANTHROPIC_API_KEY',
    defaultValue: '',
  );

  final LlmProvider provider;

  LlmService({this.provider = LlmProvider.openai});

  /// Analyze fortune text
  Future<LlmResult> analyzeFortune(String ocrText) async {
    try {
      final prompt = _buildPrompt(ocrText);

      switch (provider) {
        case LlmProvider.openai:
          return await _analyzeWithOpenAI(prompt);
        case LlmProvider.anthropic:
          return await _analyzeWithAnthropic(prompt);
        case LlmProvider.mock:
          return _mockAnalysis(ocrText);
      }
    } catch (e) {
      return LlmResult(
        analysis: null,
        success: false,
        error: 'LLM解析に失敗しました: $e',
      );
    }
  }

  /// Build analysis prompt
  String _buildPrompt(String ocrText) {
    return '''
あなたはおみくじの解釈専門家です。以下のおみくじのテキストを分析し、JSON形式で結果を返してください。

おみくじテキスト:
$ocrText

以下のJSON形式で返してください：
{
  "fortuneGrade": "大吉/吉/中吉/小吉/末吉/凶/大凶など（テキストから抽出、なければnull）",
  "summaryOneLine": "一言要約（50文字以内）",
  "modernTranslation": "現代語訳（200文字程度、わかりやすく）",
  "actionTipToday": "今日の一手（具体的な行動提案、100文字以内）",
  "keywords": ["キーワード1", "キーワード2", "キーワード3"],
  "cautionLevel": 0
}

重要な注意事項：
- 断定的な表現は避け、「〜でしょう」「〜かもしれません」を使用
- 医療、投資、法律に関する具体的なアドバイスは避ける
- ポジティブで前向きな解釈を心がける
- actionTipTodayは実行可能で具体的な提案にする
''';
  }

  /// Analyze with OpenAI API
  Future<LlmResult> _analyzeWithOpenAI(String prompt) async {
    // Check if API key is set
    if (_openaiApiKey == 'YOUR_OPENAI_API_KEY') {
      return _mockAnalysis('（OpenAI APIキーが設定されていません）');
    }

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_openaiApiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4o-mini',
        'messages': [
          {'role': 'system', 'content': 'あなたはおみくじの解釈専門家です。'},
          {'role': 'user', 'content': prompt},
        ],
        'response_format': {'type': 'json_object'},
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['choices'][0]['message']['content'];
      final analysisJson = jsonDecode(content);

      return LlmResult(
        analysis: FortuneAnalysis.fromJson(analysisJson),
        success: true,
      );
    } else {
      throw Exception('OpenAI API error: ${response.statusCode}');
    }
  }

  /// Analyze with Anthropic Claude API
  Future<LlmResult> _analyzeWithAnthropic(String prompt) async {
    // Check if API key is set
    if (_anthropicApiKey == 'YOUR_ANTHROPIC_API_KEY') {
      return _mockAnalysis('（Anthropic APIキーが設定されていません）');
    }

    final response = await http.post(
      Uri.parse('https://api.anthropic.com/v1/messages'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _anthropicApiKey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': 'claude-3-5-sonnet-20241022',
        'max_tokens': 1024,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['content'][0]['text'];

      // Extract JSON from response
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(content);
      if (jsonMatch != null) {
        final analysisJson = jsonDecode(jsonMatch.group(0)!);
        return LlmResult(
          analysis: FortuneAnalysis.fromJson(analysisJson),
          success: true,
        );
      }

      throw Exception('Failed to parse JSON from Claude response');
    } else {
      throw Exception('Anthropic API error: ${response.statusCode}');
    }
  }

  /// Mock analysis (for development/demo)
  LlmResult _mockAnalysis(String ocrText) {
    // Generate mock analysis based on common patterns
    final hasGoodWords = ocrText.contains(RegExp(r'吉|良|福|幸'));
    final hasBadWords = ocrText.contains(RegExp(r'凶|悪|災'));

    String grade = '中吉';
    String summary = 'バランスの取れた運勢です';
    String translation = 'あなたは今、安定した運気の中にいます。';
    String action = '今日は普段通りの生活を心がけましょう。';

    if (hasGoodWords) {
      grade = '大吉';
      summary = '新しいことを始めるのに最適な時期です';
      translation = 'あなたは今、とても運気の良い状態にあります。新しいことに挑戦するのに最適な時期です。'
          'これまで躊躇していたことがあれば、思い切って一歩踏み出してみましょう。'
          '周囲の人々もあなたを応援してくれるでしょう。ただし、慎重さも忘れずに。';
      action = '今日は気になっていた新しいことに挑戦してみましょう。小さな一歩でも大丈夫です。';
    } else if (hasBadWords) {
      grade = '末吉';
      summary = '慎重に行動することで道が開けます';
      translation = '今は少し運気が停滞している時期かもしれません。しかし、これは次の飛躍のための準備期間と考えましょう。'
          '焦らず、着実に進むことが大切です。';
      action = '今日は無理せず、基本的なことを丁寧にこなしましょう。';
    }

    return LlmResult(
      analysis: FortuneAnalysis(
        fortuneGrade: grade,
        summaryOneLine: summary,
        modernTranslation: translation,
        actionTipToday: action,
        keywords: ['挑戦', '新しい始まり', '周囲のサポート'],
        cautionLevel: 0,
        analyzedAt: DateTime.now(),
        version: 1,
      ),
      success: true,
    );
  }
}

/// LLM Provider
enum LlmProvider {
  openai,
  anthropic,
  mock, // For development/testing
}

/// LLM Result Model
class LlmResult {
  final FortuneAnalysis? analysis;
  final bool success;
  final String? error;

  LlmResult({
    required this.analysis,
    required this.success,
    this.error,
  });
}
