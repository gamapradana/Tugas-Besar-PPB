import 'package:flutter/material.dart';

import '../app_theme.dart';
import 'cyclefy_logo.dart';

/// Kerangka halaman Login/Register: header hijau gelap berisi sambutan,
/// lalu lembar terang berisi form (mengikuti desain Login pada SDD).
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.headline,
    required this.subtitle,
    required this.child,
  });

  final String headline;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final TextTheme t = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.green900,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.pageMargin,
                        AppSpacing.xl,
                        AppSpacing.pageMargin,
                        AppSpacing.xl,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CyclefyLogo(size: 56, onDark: true),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            headline,
                            style: t.headlineMedium
                                ?.copyWith(color: AppColors.white),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            subtitle,
                            style: t.bodyLarge
                                ?.copyWith(color: AppColors.green100),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.gray50,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(AppRadius.xl),
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.pageMargin,
                          AppSpacing.xl,
                          AppSpacing.pageMargin,
                          AppSpacing.xl,
                        ),
                        child: child,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
