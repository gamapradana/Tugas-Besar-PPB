import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/receiver_location.dart';

class ReceiverFormPage extends StatefulWidget {
  final ReceiverLocation? receiver;

  const ReceiverFormPage({
    super.key,
    this.receiver,
  });

  @override
  State<ReceiverFormPage> createState() => _ReceiverFormPageState();
}

class _ReceiverFormPageState extends State<ReceiverFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  late final TextEditingController _hoursController;

  final List<String> categories = [
    'Plastik',
    'Kertas',
    'Kardus',
    'Elektronik',
    'Logam',
  ];

  late Set<String> selectedCategories;

  bool get isEditing => widget.receiver != null;

  @override
  void initState() {
    super.initState();

    final receiver = widget.receiver;

    _nameController = TextEditingController(
      text: receiver?.name ?? '',
    );

    _descriptionController = TextEditingController(
      text: receiver?.description ?? '',
    );

    _addressController = TextEditingController(
      text: receiver?.address ?? '',
    );

    _phoneController = TextEditingController(
      text: receiver?.phone ?? '',
    );

    _hoursController = TextEditingController(
      text: receiver?.operatingHours ?? '',
    );

    selectedCategories = receiver == null
        ? {}
        : receiver.acceptedCategories.toSet();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _hoursController.dispose();

    super.dispose();
  }

  void _saveReceiver() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal satu kategori sampah.'),
        ),
      );
      return;
    }

    final receiver = ReceiverLocation(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      address: _addressController.text.trim(),
      phone: _phoneController.text.trim(),
      operatingHours: _hoursController.text.trim(),
      acceptedCategories: selectedCategories.toList(),
      status: widget.receiver?.status ?? 'Pending',
      isActive: widget.receiver?.isActive ?? true,
    );

    Navigator.pop(context, receiver);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.green700,
        foregroundColor: AppColors.white,
        title: Text(
          isEditing ? 'Edit Lokasi' : 'Tambah Lokasi',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTextField(
              controller: _nameController,
              label: 'Nama Lokasi',
              hint: 'Masukkan nama lokasi',
              icon: Icons.business,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _descriptionController,
              label: 'Deskripsi',
              hint: 'Jelaskan tempat penerimaan sampah',
              icon: Icons.description_outlined,
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _addressController,
              label: 'Alamat',
              hint: 'Masukkan alamat lengkap',
              icon: Icons.location_on_outlined,
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _phoneController,
              label: 'Nomor Telepon',
              hint: 'Contoh: 081234567890',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _hoursController,
              label: 'Jam Operasional',
              hint: 'Contoh: 08.00 - 16.00',
              icon: Icons.access_time,
            ),
            const SizedBox(height: 24),

            _buildCategorySelection(),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveReceiver,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green700,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isEditing ? 'Simpan Perubahan' : 'Tambah Lokasi',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.gray900,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
              color: AppColors.green700,
            ),
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.gray300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.gray300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.green700,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '$label wajib diisi';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kategori Sampah yang Diterima',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.gray900,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            final isSelected = selectedCategories.contains(category);

            return FilterChip(
              label: Text(category),
              selected: isSelected,
              selectedColor: AppColors.green100,
              checkmarkColor: AppColors.green700,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedCategories.add(category);
                  } else {
                    selectedCategories.remove(category);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
