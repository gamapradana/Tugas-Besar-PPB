
import 'package:flutter/material.dart';

import '../../../pages/app_theme.dart';
import '../models/recycling_location.dart';

class LocationDetailPage extends StatelessWidget {
  final RecyclingLocation location;

  const LocationDetailPage({
    super.key,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.green700,
        foregroundColor: AppColors.white,
        title: const Text('Detail Lokasi'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLocationImage(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLocationName(),
                  const SizedBox(height: 12),
                  _buildLocationStatus(),
                  const SizedBox(height: 20),
                  _buildInformationSection(),
                  const SizedBox(height: 20),
                  _buildCategorySection(),
                  const SizedBox(height: 20),
                  _buildDescriptionSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationImage() {
    return Container(
      height: 200,
      width: double.infinity,
      color: AppColors.green100,
      child: const Center(
        child: Icon(
          Icons.recycling,
          size: 80,
          color: AppColors.green700,
        ),
      ),
    );
  }

  Widget _buildLocationName() {
    return Text(
      location.name,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.gray900,
      ),
    );
  }

  Widget _buildLocationStatus() {
    return Row(
      children: [
        Icon(
          location.isOpen ? Icons.check_circle : Icons.cancel,
          color: location.isOpen
              ? AppColors.success
              : AppColors.error,
          size: 18,
        ),
        const SizedBox(width: 6),
        Text(
          location.isOpen ? 'Buka' : 'Tutup',
          style: TextStyle(
            color: location.isOpen
                ? AppColors.success
                : AppColors.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 16),
        const Icon(
          Icons.location_on,
          size: 18,
          color: AppColors.gray600,
        ),
        const SizedBox(width: 4),
        Text(
          location.distance,
          style: const TextStyle(
            color: AppColors.gray600,
          ),
        ),
      ],
    );
  }

  Widget _buildInformationSection() {
    return _buildSection(
      title: 'Alamat',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.location_on_outlined,
            color: AppColors.green700,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              location.address,
              style: const TextStyle(
                color: AppColors.gray600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return _buildSection(
      title: 'Kategori yang Diterima',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: location.category.split(',').map((category) {
          return Chip(
            label: Text(category.trim()),
            backgroundColor: AppColors.green100,
            labelStyle: const TextStyle(
              color: AppColors.green900,
              fontWeight: FontWeight.w500,
            ),
            side: BorderSide.none,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return _buildSection(
      title: 'Deskripsi',
      child: Text(
        location.description,
        style: const TextStyle(
          fontSize: 14,
          height: 1.5,
          color: AppColors.gray600,
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
