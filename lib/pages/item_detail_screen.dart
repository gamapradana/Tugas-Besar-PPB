import 'package:flutter/material.dart';

import '../models/cyclefy_item.dart';
import 'components/item_image.dart';

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  final CyclefyItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus barang?'),
        content: Text('"${item.name}" akan dihapus secara permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed == true) onDelete();
  }

  @override
  Widget build(BuildContext context) {
    final isDonation = item.type == ItemType.donation;
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Barang')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ItemImage(url: item.imageUrl, width: double.infinity, height: 220),
          const SizedBox(height: 16),
          Text(
            item.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              Chip(label: Text(item.category)),
              Chip(label: Text('Kondisi: ${item.condition}')),
              Chip(
                avatar: Icon(
                  isDonation ? Icons.volunteer_activism : Icons.inventory_2,
                  size: 18,
                  color: const Color(0xFF267A43),
                ),
                label: Text(isDonation ? 'Donasi' : 'Barang'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Deskripsi',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(item.description),
          if (isDonation && item.pickupLocation != null) ...[
            const SizedBox(height: 16),
            const Text(
              'Lokasi Pengambilan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.place_outlined,
                  size: 18,
                  color: Color(0xFF267A43),
                ),
                const SizedBox(width: 6),
                Expanded(child: Text(item.pickupLocation!)),
              ],
            ),
          ],
          // Edit & hapus hanya untuk pemilik barang
          if (item.isOwner) ...[
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                    ),
                    onPressed: () => _confirmDelete(context),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Hapus'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
