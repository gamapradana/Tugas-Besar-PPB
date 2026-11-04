import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../data/dummy_location.dart';
import '../models/recycling_location.dart';

class RecyclingLocatorPage extends StatelessWidget {
  const RecyclingLocatorPage({super.key});

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
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Temukan Lokasi Daur Ulang',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Temukan tempat untuk menyalurkan barang bekas '
            'agar dapat digunakan kembali.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.gray600,
            ),
          ),
          const SizedBox(height: 20),

          Container(
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
                  Icon(
                    Icons.map_outlined,
                    size: 42,
                    color: AppColors.green700,
                  ),
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
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Lokasi di Sekitar Anda',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 12),

          ...dummyLocation.map(
            (location) => _LocationCard(location: location),
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
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
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