import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse/core/tts/tts_provider.dart';
// import 'package:flutter/services.dart';
import 'package:pulse/home.dart';
import 'package:pulse/theme/theme.dart';

Future<void> initTTS() async {
  final container = ProviderContainer();
  final ttsService = container.read(ttsServiceProvider);
  await ttsService.init();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // HORIZONTAL ORIENTATION
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.landscapeLeft,
  // ]);
  // HORIZONTAL ORIENTATION

  await initTTS();

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: theme, home: HomeScreen());
  }
}
