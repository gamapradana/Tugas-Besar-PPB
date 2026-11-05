import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

<<<<<<< HEAD
import 'pages/main_navigation.dart';

void main() {
  runApp(const MyApp());
=======
import 'pages/app_router.dart';
import 'pages/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const ProviderScope(child: CyclefyApp()));
>>>>>>> origin/main
}

class CyclefyApp extends ConsumerWidget {
  const CyclefyApp({super.key});

  @override
<<<<<<< HEAD
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyclefy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF267A43)),
        scaffoldBackgroundColor: const Color(0xFFF6F8F6),
        useMaterial3: true,
      ),
      home: const MainNavigation(),
=======
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Cyclefy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: ref.watch(routerProvider),
>>>>>>> origin/main
    );
  }
}
