import 'package:flutter/material.dart';

import '../models/cyclefy_item.dart';
import 'components/item_card.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({
    super.key,
    required this.items,
    required this.searchText,
    required this.selectedCategory,
    required this.onSearchChanged,
    required this.onCategoryChanged,
    required this.onOpenDetail,
  });

  final List<CyclefyItem> items;
  final String searchText;
  final String selectedCategory;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<CyclefyItem> onOpenDetail;

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  static const _categories = [
    'Semua',
    'Buku',
    'Elektronik',
    'Pakaian',
    'Aksesoris',
    'Rumah Tangga',
    'Lainnya',
  ];

  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchText);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = widget.searchText.trim().toLowerCase();
    final filtered = widget.items.where((item) {
      final matchCategory =
          widget.selectedCategory == 'Semua' ||
          item.category == widget.selectedCategory;
      final matchSearch =
          query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query);
      return matchCategory && matchSearch;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: _searchController,
            onChanged: widget.onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Cari barang...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFD5DDD7)),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (_, index) {
              final category = _categories[index];
              return ChoiceChip(
                label: Text(category),
                selected: widget.selectedCategory == category,
                onSelected: (_) => widget.onCategoryChanged(category),
              );
            },
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text('Barang tidak ditemukan.'))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                  itemCount: filtered.length,
                  itemBuilder: (_, index) {
                    final item = filtered[index];
                    return ItemCard(
                      item: item,
                      onTap: () => widget.onOpenDetail(item),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
