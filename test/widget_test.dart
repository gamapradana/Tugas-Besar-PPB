import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cyclefy/main.dart';

void main() {
  testWidgets('Aplikasi Cyclefy tampil', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: CyclefyApp()));

    expect(find.text('Cyclefy'), findsOneWidget);
  });
}