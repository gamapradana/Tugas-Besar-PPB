import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/auth_controller.dart';
import '../app_theme.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Cyclefy')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pageMargin),
        children: [
          Text(
            'Halo, ${user?.displayName ?? 'Pengguna'}!',
            style: textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Reuse More. Waste Less.',
            style: textTheme.bodyLarge?.copyWith(color: AppColors.gray600),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Jelajahi Fitur', style: textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          _FeatureTile(
            icon: Icons.volunteer_activism_outlined,
            title: 'Barang & Donasi',
            subtitle: 'Lihat, tambah, dan kelola barang serta donasi.',
            onTap: () => context.push('/items'),
          ),
          _FeatureTile(
            icon: Icons.swap_horiz,
            title: 'Barter & Peminjaman',
            subtitle: 'Lihat penawaran, ajukan barter atau peminjaman, dan cek riwayat.',
            onTap: () => context.push('/barter'),
          ),
          _FeatureTile(
            icon: Icons.recycling,
            title: 'Lokasi Daur Ulang',
            subtitle: 'Temukan lokasi daur ulang di sekitarmu.',
            onTap: () => context.push('/recycling-locator'),
          ),
          _FeatureTile(
            icon: Icons.location_on_outlined,
            title: 'Lokasi Penerimaan',
            subtitle: 'Kelola lokasi penerimaan barang.',
            onTap: () => context.push('/receiver-management'),
          ),
          _FeatureTile(
            icon: Icons.notifications_none,
            title: 'Notifikasi',
            subtitle: 'Lihat pemberitahuan aplikasi.',
            onTap: () => context.push('/notifications'),
          ),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.green100,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(icon, color: AppColors.green700, size: 26),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.gray600),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.gray600),
            ],
          ),
        ),
      ),
    );
  }
}
