import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../data/auth_controller.dart';
import '../app_theme.dart';

/// Halaman utama SEMENTARA. Fitur Donation, Barter, Borrow, Recycle, dan
/// Repair dikerjakan modul lain dan akan menggantikan isi halaman ini.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    final TextTheme t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Cyclefy')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pageMargin),
        children: [
          Text('Halo, ${user?.displayName ?? 'Pengguna'}!',
              style: t.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Reuse More. Waste Less.',
            style: t.bodyLarge?.copyWith(color: AppColors.gray600),
          ),
          const SizedBox(height: AppSpacing.xl),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Row(
                children: [
                  const Icon(LucideIcons.recycle,
                      size: 32, color: AppColors.green700),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Text(
                      'Fitur Donasi, Barter, Pinjam, Daur Ulang, dan Perbaikan '
                      'akan segera hadir.',
                      style: t.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
