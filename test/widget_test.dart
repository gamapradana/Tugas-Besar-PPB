import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cyclefy/main.dart';

void main() {
  testWidgets('Aplikasi Cyclefy tampil', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(child: CyclefyApp(theme: ThemeData())),
    );

    expect(find.text('Cyclefy'), findsOneWidget);
  });
}