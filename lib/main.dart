import 'package:flutter/material.dart';

import 'features/recycling_locator/pages/recycling_locator_page.dart';

void main() {
  runApp(const CycleApp());
}

class CycleApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cyclefy',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      home: const RecyclingLocatorPage(),
    );
  }
}

