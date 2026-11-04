import 'package:flutter/material.dart';

import '../app_theme.dart';

/// Varian tombol sesuai Design System bagian 7.1.
enum AppButtonVariant { primary, secondary, tertiary }

/// Tombol standar Cyclefy (tinggi 48 px, radius 8 px).
///
/// - [onPressed] null  -> tombol disabled (abu-abu).
/// - [isLoading] true  -> menampilkan spinner dan mengabaikan tap.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.expanded = true,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;

  /// true = lebar penuh (default untuk form di mobile).
  final bool expanded;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    // Saat loading, tombol tetap berwarna aktif tetapi tap diabaikan.
    final VoidCallback? handler = isLoading ? () {} : onPressed;

    final Widget child = isLoading
        ? SizedBox(
            width: AppSizes.iconSize,
            height: AppSizes.iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: variant == AppButtonVariant.primary
                  ? AppColors.white
                  : AppColors.green700,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: AppSizes.iconSize),
                const SizedBox(width: AppSpacing.sm),
              ],
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
            ],
          );

    final Widget button = switch (variant) {
      AppButtonVariant.primary =>
        FilledButton(onPressed: handler, child: child),
      AppButtonVariant.secondary =>
        OutlinedButton(onPressed: handler, child: child),
      AppButtonVariant.tertiary =>
        TextButton(onPressed: handler, child: child),
    };

    return SizedBox(
      width: expanded ? double.infinity : null,
      child: button,
    );
  }
}