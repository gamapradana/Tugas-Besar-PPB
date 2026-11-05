import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'location_detail_page.dart';
import '../../../pages/app_theme.dart';
import '../data/dummy_location.dart';
import '../models/recycling_location.dart';

class RecyclingLocatorPage extends StatefulWidget {
  const RecyclingLocatorPage({super.key});

  @override
  State<RecyclingLocatorPage> createState() => _RecyclingLocatorPageState();
}

class _RecyclingLocatorPageState extends State<RecyclingLocatorPage> {
  final TextEditingController _searchController = TextEditingController();

  String searchQuery = '';

  String selectedCategory = 'Semua';

  final List<String> categories = [
    'Semua',
    'Plastik',
    'Kertas',
    'Kardus',
    'Elektronik',
    'Logam',
  ];

  List<RecyclingLocation> get filteredLocations {
    final query = searchQuery.trim().toLowerCase();

    return dummyLocation.where((location) {
      final matchesSearch =
          location.name.toLowerCase().contains(query) ||
          location.address.toLowerCase().contains(query) ||
          location.category.toLowerCase().contains(query);

      final matchesCategory =
          selectedCategory == 'Semua' ||
          location.category.toLowerCase().contains(
            selectedCategory.toLowerCase(),
          );

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.green900,
        foregroundColor: AppColors.white,
        title: const Text(
          'Recycling Locator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Notifikasi',
            onPressed: () {
              context.push('/notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.store),
            tooltip: 'Receiver Management',
            onPressed: () {
              context.push('/receiver-management');
            },
          ),
        ],
        elevation: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(),

          const SizedBox(height: 20),

          _buildSearchBar(),

          const SizedBox(height: 16),

          _buildCategoryFilter(),

          const SizedBox(height: 20),

          _buildMapPreview(),

          const SizedBox(height: 24),

          _buildLocationSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Temukan Lokasi Daur Ulang',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.gray900,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Temukan tempat untuk menyalurkan barang bekas '
          'agar dapat digunakan kembali.',
          style: TextStyle(fontSize: 14, color: AppColors.gray600),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Cari lokasi daur ulang...',
        prefixIcon: const Icon(Icons.search, color: AppColors.green700),
        suffixIcon: searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    searchQuery = '';
                    _searchController.clear();
                  });
                },
              )
            : null,
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.gray300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.gray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.green700, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kategori Barang',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.gray900,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            final isSelected = selectedCategory == category;

            return ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedCategory = category;
                });
              },
              selectedColor: AppColors.green100,
              backgroundColor: AppColors.white,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.green900 : AppColors.gray600,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.green700 : AppColors.gray300,
              ),
              showCheckmark: false,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMapPreview() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: AppColors.green100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray300),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map_outlined, size: 42, color: AppColors.green700),
            SizedBox(height: 8),
            Text(
              'Map Preview',
              style: TextStyle(
                color: AppColors.green900,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Peta akan diintegrasikan pada tahap berikutnya',
              style: TextStyle(fontSize: 12, color: AppColors.gray600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lokasi di Sekitar Anda',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.gray900,
          ),
        ),
        const SizedBox(height: 12),
        if (filteredLocations.isEmpty)
          _buildEmptyState()
        else
          ...filteredLocations.map(
            (location) => _LocationCard(location: location),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 48, color: AppColors.gray600),
          SizedBox(height: 12),
          Text(
            'Lokasi tidak ditemukan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.gray900,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Coba gunakan kata kunci atau kategori lainnya.',
            style: TextStyle(fontSize: 13, color: AppColors.gray600),
          ),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final RecyclingLocation location;

  const _LocationCard({required this.location});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.gray100),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LocationDetailPage(location: location),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.green100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.recycling,
                  color: AppColors.green700,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.gray900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      location.address,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.gray600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Menerima: ${location.category}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.gray600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: AppColors.green700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          location.distance,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.gray600,
                          ),
                        ),
                        const Spacer(),
                        _StatusBadge(isOpen: location.isOpen),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isOpen;

  const _StatusBadge({required this.isOpen});

  @override
  Widget build(BuildContext context) {
    final color = isOpen ? AppColors.success : AppColors.gray600;
    final label = isOpen ? 'Buka' : 'Tutup';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isOpen ? AppColors.green100 : AppColors.gray100,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
