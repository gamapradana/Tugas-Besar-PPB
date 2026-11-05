import 'package:flutter/material.dart';

import 'pages/main_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
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
    );
  }
}
