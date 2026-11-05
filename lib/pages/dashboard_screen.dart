import 'package:flutter/material.dart';

import '../models/cyclefy_item.dart';
import 'components/item_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.items,
    required this.onOpenItems,
    required this.onOpenDetail,
  });

  final List<CyclefyItem> items;
  final VoidCallback onOpenItems;
  final ValueChanged<CyclefyItem> onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final donationCount = items
        .where((item) => item.type == ItemType.donation)
        .length;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFE6F4E9),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reuse More. Waste Less.',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF174B2B),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Kelola barang dan bagikan barang yang masih layak pakai melalui Cyclefy.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Total Barang',
                value: '${items.length}',
                icon: Icons.inventory_2_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'Barang Donasi',
                value: '$donationCount',
                icon: Icons.volunteer_activism_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Barang Terbaru',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: onOpenItems,
              child: const Text('Lihat semua'),
            ),
          ],
        ),
        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('Belum ada barang.')),
          )
        else
          ...items
              .take(3)
              .map(
                (item) => ItemCard(item: item, onTap: () => onOpenDetail(item)),
              ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });
  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD5DDD7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF267A43)),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Text(title, style: const TextStyle(color: Color(0xFF66736A))),
        ],
      ),
    );
  }
}
