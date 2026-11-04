import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/app_theme.dart';
import 'pages/design_preview_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const ProviderScope(child: CyclefyApp()));
}

class CyclefyApp extends StatelessWidget {
  /// [theme] . [AppTheme.light].
  const CyclefyApp({super.key, this.theme});

  final ThemeData? theme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyclefy',
      debugShowCheckedModeBanner: false,
      theme: theme ?? AppTheme.light(),
      home: const DesignPreviewPage(),
    );
  }
}