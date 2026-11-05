import 'package:flutter/material.dart';

/// Menampilkan gambar barang dari URL server (aman di Web & mobile).
class ItemImage extends StatelessWidget {
  const ItemImage({
    super.key,
    this.url,
    this.size = 64,
    this.width,
    this.height,
  });

  final String? url;
  final double size;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final w = width ?? size;
    final h = height ?? size;
    final hasImage = url != null && url!.isNotEmpty;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: hasImage
          ? Image.network(
              url!,
              width: w,
              height: h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => _placeholder(w, h),
            )
          : _placeholder(w, h),
    );
  }

  Widget _placeholder(double w, double h) => Container(
    width: w,
    height: h,
    color: const Color(0xFFE6F4E9),
    child: const Icon(Icons.image_outlined, color: Color(0xFF267A43), size: 30),
  );
}
