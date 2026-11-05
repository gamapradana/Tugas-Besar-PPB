import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cyclefy/main.dart';
import 'package:cyclefy/data/auth_controller.dart';

void main() {
  testWidgets('Aplikasi Cyclefy berhasil dirender', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith(
            () => TestAuthController(),
          ),
        ],
        child: const CyclefyApp(),
      ),
    );

    expect(find.text('Cyclefy'), findsOneWidget);
    expect(find.text('Reuse More. Waste Less.'), findsOneWidget);
  });
}

class TestAuthController extends AuthController {
  @override
  Future<void> checkSession() async {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}