import 'package:flutter/material.dart';

import '../../models/cyclefy_item.dart';
import 'item_image.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.item, required this.onTap});
  final CyclefyItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDonation = item.type == ItemType.donation;
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFD5DDD7)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(12),
        leading: ItemImage(url: item.imageUrl, size: 58),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text('${item.category} • ${item.condition}'),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isDonation ? Icons.volunteer_activism : Icons.inventory_2,
              color: const Color(0xFF267A43),
            ),
            const SizedBox(height: 4),
            Text(
              isDonation ? 'Donasi' : 'Barang',
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
