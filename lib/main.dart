import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/app_router.dart';
import 'pages/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const ProviderScope(child: CyclefyApp()));
}

class CyclefyApp extends ConsumerWidget {
  const CyclefyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Cyclefy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: ref.watch(routerProvider),
    );
  }
}