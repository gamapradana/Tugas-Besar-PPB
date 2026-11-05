import 'package:flutter/material.dart';

import '../models/cyclefy_item.dart';
import 'components/item_card.dart';

class DonationsScreen extends StatelessWidget {
  const DonationsScreen({
    super.key,
    required this.donations,
    required this.onOpenDetail,
  });

  final List<CyclefyItem> donations;
  final ValueChanged<CyclefyItem> onOpenDetail;

  @override
  Widget build(BuildContext context) {
    if (donations.isEmpty) {
      return const Center(child: Text('Belum ada barang donasi.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      itemCount: donations.length,
      itemBuilder: (_, index) {
        final item = donations[index];
        return ItemCard(item: item, onTap: () => onOpenDetail(item));
      },
    );
  }
}
