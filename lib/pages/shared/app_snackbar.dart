import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../app_theme.dart';

enum AppSnackType { success, error, warning, info }

void showAppSnackBar(
  BuildContext context,
  String message, {
  AppSnackType type = AppSnackType.info,
}) {
  final (Color background, Color foreground, IconData icon) = switch (type) {
    AppSnackType.success => (
        AppColors.success,
        AppColors.white,
        LucideIcons.circleCheck
      ),
    AppSnackType.error => (
        AppColors.error,
        AppColors.white,
        LucideIcons.circleAlert
      ),
    AppSnackType.warning => (
        AppColors.warning,
        AppColors.gray900,
        LucideIcons.triangleAlert
      ),
    AppSnackType.info => (AppColors.info, AppColors.white, LucideIcons.info),
  };

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: background,
        margin: const EdgeInsets.all(AppSpacing.pageMargin),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        content: Row(
          children: [
            Icon(icon, color: foreground, size: AppSizes.iconSize),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: foreground),
              ),
            ),
          ],
        ),
      ),
    );
}