import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse/core/tts/tts_provider.dart';
import 'package:pulse/home_screen.dart';
import 'package:pulse/theme/theme.dart';

Future<void> initTTS() async {
  final container = ProviderContainer();
  final ttsService = container.read(ttsServiceProvider);
  await ttsService.init();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initTTS();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: theme, home: const HomeScreen());
  }
}
