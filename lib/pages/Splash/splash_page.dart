import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/auth_controller.dart';
import '../app_theme.dart';
import '../shared/cyclefy_logo.dart';

/// Layar pembuka: menampilkan branding sambil memeriksa status login.
/// Setelah selesai, router otomatis memilih Login atau Home.
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authControllerProvider.notifier).checkSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme t = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.green900,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CyclefyLogo(size: 96, onDark: true),
            const SizedBox(height: AppSpacing.lg),
            Text('Cyclefy',
                style: t.headlineLarge?.copyWith(color: AppColors.white)),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Reuse More. Waste Less.',
              style: t.bodyLarge?.copyWith(color: AppColors.green100),
            ),
            const SizedBox(height: AppSpacing.xl2),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.green500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
