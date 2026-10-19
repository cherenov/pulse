import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse/core/tts/tts_service.dart';

/// Провайдер, який поставляє ініціалізований TtsService для додатку
final ttsServiceProvider = Provider<TtsService>((ref) {
  return TtsService();
});
