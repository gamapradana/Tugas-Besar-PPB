import 'package:flutter/material.dart';
import 'features/notifications/pages/notification_page.dart';
import 'features/recycling_locator/pages/recycling_locator_page.dart';
import 'features/receiver_management/pages/receiver_list_page.dart';

void main() {
  runApp(const CycleApp());
}

class CycleApp extends StatelessWidget {
  const CycleApp({super.key});

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
      routes: {
        '/receiver-management': (context) =>
            const ReceiverListPage(),
        '/notifications': (context) => 
            const NotificationPage(),
      },
    );
  }
}
