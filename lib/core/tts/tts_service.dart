import 'dart:io';
import 'dart:developer' as dev;

import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;
  bool _isInitializing = false;

  Future<void> init() async {
    if (_isInitialized || _isInitializing) return;
    _isInitializing = true;

    try {
      // 1. Обов'язково чекаємо готовності нативного Handler
      await _tts.awaitSpeakCompletion(true);

      // 2. Встановлюємо основні параметри (БЕЗ setEngine)
      await _tts.setLanguage("en-US");
      await _tts.setSpeechRate(0.35);
      // await _tts.setVolume(1.0);
      await _tts.setPitch(0.7);

      if (Platform.isIOS) {
        await _tts.setIosAudioCategory(IosTextToSpeechAudioCategory.playback, [
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        ]);
      }

      _isInitialized = true;
    } catch (e) {
      dev.log("[TtsService] Init failed: $e");
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> speak(String text) async {
    if (text.isEmpty) return;

    if (!_isInitialized) {
      await init();
    }

    if (!_isInitialized) {
      dev.log("[TtsService] Engine not available, skipping speak.");
      return;
    }

    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      dev.log("[TtsService] Speak error: $e");
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (e) {
      dev.log("[TtsService] Stop error: $e");
    }
  }
}
