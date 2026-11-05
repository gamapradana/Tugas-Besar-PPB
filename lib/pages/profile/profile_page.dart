import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../data/api_exception.dart';
import '../../data/auth_controller.dart';
import '../../models/user_model.dart';
import '../app_theme.dart';
import '../shared/app_button.dart';
import '../shared/app_snackbar.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  Future<void> _refresh(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authControllerProvider.notifier).refreshProfile();
    } on ApiException catch (e) {
      if (context.mounted) {
        showAppSnackBar(context, e.message, type: AppSnackType.error);
      }
    }
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Kamu perlu masuk lagi untuk menggunakan Cyclefy.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      // Router otomatis mengarahkan ke Login setelah status berubah.
      await ref.read(authControllerProvider.notifier).logout();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserModel? user = ref.watch(authControllerProvider).user;
    final TextTheme t = Theme.of(context).textTheme;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final profile = user.profile;
    final addressParts = <String?>[
      profile?.address,
      profile?.city,
      profile?.state,
      profile?.country,
      profile?.zipcode,
    ].where((p) => p != null && p.trim().isNotEmpty).join(', ');

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: RefreshIndicator(
        onRefresh: () => _refresh(context, ref),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.pageMargin),
          children: [
            Center(child: _Avatar(user: user)),
            const SizedBox(height: AppSpacing.lg),
            Text(user.displayName,
                textAlign: TextAlign.center, style: t.headlineSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '@${user.username}',
              textAlign: TextAlign.center,
              style: t.bodyMedium?.copyWith(color: AppColors.gray600),
            ),
            const SizedBox(height: AppSpacing.md),
            Center(child: _VerifiedBadge(verified: user.isEmailVerified)),
            const SizedBox(height: AppSpacing.xl),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    _InfoRow(icon: LucideIcons.mail, label: 'Email', value: user.email),
                    const Divider(height: AppSpacing.xl),
                    _InfoRow(
                      icon: LucideIcons.phone,
                      label: 'Nomor Telepon',
                      value: profile?.phoneNumber,
                    ),
                    const Divider(height: AppSpacing.xl),
                    _InfoRow(
                      icon: LucideIcons.mapPin,
                      label: 'Alamat',
                      value: addressParts.isEmpty ? null : addressParts,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: 'Edit Profil',
              icon: LucideIcons.pencil,
              onPressed: () => context.push('/edit-profile'),
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: 'Keluar',
              icon: LucideIcons.logOut,
              variant: AppButtonVariant.secondary,
              onPressed: () => _confirmLogout(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final picture = user.profilePicture;
    final hasImage = picture != null && picture.startsWith('http');

    return CircleAvatar(
      radius: 48,
      backgroundColor: AppColors.green100,
      foregroundImage: hasImage ? NetworkImage(picture) : null,
      child: Text(
        user.displayName.characters.first.toUpperCase(),
        style: Theme.of(context)
            .textTheme
            .headlineLarge
            ?.copyWith(color: AppColors.green700),
      ),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge({required this.verified});

  final bool verified;

  @override
  Widget build(BuildContext context) {
    final Color color = verified ? AppColors.success : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(verified ? LucideIcons.circleCheck : LucideIcons.circleAlert,
              size: 16, color: AppColors.gray900),
          const SizedBox(width: AppSpacing.xs),
          Text(
            verified ? 'Email terverifikasi' : 'Email belum terverifikasi',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final TextTheme t = Theme.of(context).textTheme;
    final bool empty = value == null || value!.trim().isEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: AppSizes.iconSize, color: AppColors.green700),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: t.labelSmall?.copyWith(color: AppColors.gray600)),
              const SizedBox(height: AppSpacing.xs),
              Text(
                empty ? 'Belum diisi' : value!,
                style: t.bodyMedium?.copyWith(
                  color: empty ? AppColors.gray600 : AppColors.gray900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
