import 'package:flutter/material.dart';

import 'pages/barter_offers_page.dart';

void main() {
  runApp(const CyclefyApp());
}

class CyclefyApp extends StatelessWidget {
  const CyclefyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cyclefy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF477A55)),
        scaffoldBackgroundColor: const Color(0xFFF7F8F3),
        useMaterial3: true,
      ),
      home: const BarterOffersPage(),
    );
  }
}
