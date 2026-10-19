import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:pulse/home.dart';
import 'package:pulse/theme/theme.dart';

void main() async {
  // HORIZONTAL ORIENTATION
  // WidgetsFlutterBinding.ensureInitialized();

  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.landscapeLeft,
  // ]);
  // HORIZONTAL ORIENTATION

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: theme, home: HomeSreen());
  }
}
