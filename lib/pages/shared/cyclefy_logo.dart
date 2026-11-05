import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../app_theme.dart';

/// Logo sementara (ikon daur ulang). Ganti dengan aset logo resmi
/// dari UI/UX jika sudah tersedia.
class CyclefyLogo extends StatelessWidget {
  const CyclefyLogo({super.key, this.size = 72, this.onDark = false});

  final double size;

  /// true = dipakai di atas latar hijau gelap (logo berwarna putih).
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: onDark ? AppColors.white : AppColors.green900,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Icon(
        LucideIcons.recycle,
        size: size * 0.55,
        color: onDark ? AppColors.green900 : AppColors.white,
      ),
    );
  }
}
