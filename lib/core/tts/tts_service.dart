import 'dart:io';
import 'dart:developer' as dev;

import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;
  bool _isInitializing = false;
  double _defaultSpeechRate = 0.35;
  double? _currentRate;

  Future<void> init() async {
    if (_isInitialized || _isInitializing) return;
    _isInitializing = true;

    try {
      await _tts.awaitSpeakCompletion(true);
      await _tts.setLanguage("en-US");
      await _tts.setSpeechRate(_defaultSpeechRate);
      // await _tts.setVolume(0.7);
      await _tts.setPitch(1);

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

  Future<void> _applyRate(double rate) async {
    if (_currentRate == rate) return;
    try {
      await _tts.setSpeechRate(rate);
      _currentRate = rate;
    } catch (e) {
      _currentRate = null; // стан невідомий, наступний speak встановить заново
      rethrow;
    }
  }

  Future<void> setDefaultSpeechRate(double rate) async {
    if (rate < 0.0 || rate > 1.0) {
      throw ArgumentError.value(rate, 'rate', 'Must be between 0.0 and 1.0');
    }

    if (!_isInitialized) {
      await init();
    }

    if (!_isInitialized) {
      dev.log(
        '[TtsService] Engine not available, skipping setDefaultSpeechRate.',
      );
      return;
    }

    _defaultSpeechRate = rate;

    try {
      await _applyRate(rate);
    } catch (e) {
      dev.log('[TtsService] setDefaultSpeechRate error: $e');
    }
  }

  Future<void> speak(String text, {double? speechRate}) async {
    if (text.isEmpty) return;

    if (speechRate != null && (speechRate < 0.0 || speechRate > 1.0)) {
      throw ArgumentError.value(
        speechRate,
        'speechRate',
        'Must be between 0.0 and 1.0',
      );
    }

    if (!_isInitialized) {
      await init();
    }

    if (!_isInitialized) {
      dev.log('[TtsService] Engine not available, skipping speak.');
      return;
    }

    try {
      await _tts.stop();
      await _applyRate(speechRate ?? _defaultSpeechRate);
      await _tts.speak(text);
    } catch (e) {
      dev.log('[TtsService] Speak error: $e');
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
