import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'app_theme.dart';
import 'shared/app_button.dart';
import 'shared/app_snackbar.dart';
import 'shared/app_text_field.dart';


class DesignPreviewPage extends StatelessWidget {
  const DesignPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Cyclefy')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pageMargin),
        children: [
          Text('Heading 1', style: t.headlineLarge),
          Text('Heading 2', style: t.headlineMedium),
          Text('Heading 3', style: t.headlineSmall),
          Text('Heading 4', style: t.titleLarge),
          Text('Body 16 px', style: t.bodyLarge),
          Text('Small 14 px', style: t.bodySmall),
          Text('Caption 12 px', style: t.labelSmall),
          const SizedBox(height: AppSpacing.xl),
          const Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _Swatch('Green 900', AppColors.green900),
              _Swatch('Green 700', AppColors.green700),
              _Swatch('Green 500', AppColors.green500),
              _Swatch('Green 100', AppColors.green100),
              _Swatch('Success', AppColors.success),
              _Swatch('Warning', AppColors.warning),
              _Swatch('Error', AppColors.error),
              _Swatch('Info', AppColors.info),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: 'Primary', onPressed: () {}),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: 'Secondary',
            variant: AppButtonVariant.secondary,
            onPressed: () {},
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: 'Tertiary',
            variant: AppButtonVariant.tertiary,
            icon: LucideIcons.user,
            onPressed: () {},
          ),
          const SizedBox(height: AppSpacing.sm),
          const AppButton(label: 'Disabled', onPressed: null),
          const SizedBox(height: AppSpacing.sm),
          AppButton(label: 'Loading', isLoading: true, onPressed: () {}),
          const SizedBox(height: AppSpacing.xl),
          const AppTextField(
            label: 'Email atau Username',
            hint: 'Masukkan email atau username',
            isRequired: true,
          ),
          const SizedBox(height: AppSpacing.lg),
          const AppTextField(
            label: 'Password',
            hint: 'Masukkan password',
            isRequired: true,
            isPassword: true,
          ),
          const SizedBox(height: AppSpacing.xl),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final type in AppSnackType.values)
                AppButton(
                  label: type.name,
                  expanded: false,
                  variant: AppButtonVariant.secondary,
                  onPressed: () =>
                      showAppSnackBar(context, 'Contoh pesan ${type.name}',
                          type: type),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch(this.name, this.color);

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 48,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.gray300),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(name, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}