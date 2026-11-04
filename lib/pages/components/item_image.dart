import 'dart:io';

import 'package:flutter/material.dart';

class ItemImage extends StatelessWidget {
  const ItemImage({super.key, this.path, this.size = 64});
  final String? path;
  final double size;

  @override
  Widget build(BuildContext context) {
    final hasImage = path != null && File(path!).existsSync();
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: hasImage
          ? Image.file(
              File(path!),
              width: size,
              height: size,
              fit: BoxFit.cover,
            )
          : Container(
              width: size,
              height: size,
              color: const Color(0xFFE6F4E9),
              child: const Icon(
                Icons.image_outlined,
                color: Color(0xFF267A43),
                size: 30,
              ),
            ),
    );
  }
}
