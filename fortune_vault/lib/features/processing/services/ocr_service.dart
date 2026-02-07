// lib/features/processing/services/ocr_service.dart

import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// OCR Service
/// Extracts text from images using Google ML Kit
class OcrService {
  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.japanese,
  );

  /// Extract text from image file
  Future<OcrResult> extractText(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      if (recognizedText.text.isEmpty) {
        return OcrResult(
          text: '',
          confidence: 0.0,
          success: false,
          error: 'テキストを検出できませんでした',
        );
      }

      // Calculate average confidence
      double totalConfidence = 0.0;
      int blockCount = 0;

      for (final block in recognizedText.blocks) {
        // ML Kit doesn't provide direct confidence scores
        // We use block size and text length as heuristics
        if (block.text.isNotEmpty) {
          blockCount++;
          // Assume higher confidence for longer text blocks
          totalConfidence += block.text.length / 100.0;
        }
      }

      final avgConfidence = blockCount > 0
          ? (totalConfidence / blockCount).clamp(0.0, 1.0)
          : 0.5;

      return OcrResult(
        text: recognizedText.text,
        confidence: avgConfidence,
        success: true,
        blocks: recognizedText.blocks.map((b) => b.text).toList(),
      );
    } catch (e) {
      return OcrResult(
        text: '',
        confidence: 0.0,
        success: false,
        error: 'OCR処理に失敗しました: $e',
      );
    }
  }

  /// Dispose resources
  void dispose() {
    _textRecognizer.close();
  }
}

/// OCR Result Model
class OcrResult {
  final String text;
  final double confidence;
  final bool success;
  final String? error;
  final List<String>? blocks;

  OcrResult({
    required this.text,
    required this.confidence,
    required this.success,
    this.error,
    this.blocks,
  });

  /// Check if OCR quality is good enough
  bool get isGoodQuality => success && confidence > 0.6;

  /// Get formatted text (clean up)
  String get formattedText {
    return text
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'\n+'), '\n')
        .trim();
  }
}
