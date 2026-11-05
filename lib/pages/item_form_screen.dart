import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/cyclefy_item.dart';
import '../models/item_form_data.dart';
import '../services/item_service.dart';
import 'components/item_image.dart';

class ItemFormScreen extends StatefulWidget {
  const ItemFormScreen({
    super.key,
    required this.isDonation,
    required this.onSave,
    this.existingItem,
  });

  final bool isDonation;

  /// Dipanggil saat tombol simpan ditekan. Boleh melempar ApiException.
  final Future<void> Function(ItemFormData data) onSave;
  final CyclefyItem? existingItem;

  @override
  State<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends State<ItemFormScreen> {
  static const _categories = [
    'Buku',
    'Elektronik',
    'Pakaian',
    'Aksesoris',
    'Rumah Tangga',
    'Lainnya',
  ];
  static const _conditions = ['Sangat baik', 'Baik', 'Cukup baik'];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pickupController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String _category = _categories.first;
  String _condition = 'Baik';
  XFile? _selectedImage;
  Uint8List? _previewBytes; // preview foto baru (aman di Web & mobile)
  String? _existingImageUrl;
  bool _saving = false;

  bool get _isEditing => widget.existingItem != null;

  @override
  void initState() {
    super.initState();
    final item = widget.existingItem;
    if (item != null) {
      _nameController.text = item.name;
      _descriptionController.text = item.description;
      _pickupController.text = item.pickupLocation ?? '';
      if (_categories.contains(item.category)) _category = item.category;
      if (_conditions.contains(item.condition)) _condition = item.condition;
      _existingImageUrl = item.imageUrl;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _pickupController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1600,
      );
      if (image == null) return;
      final bytes = await image.readAsBytes();
      if (!mounted) return;
      setState(() {
        _selectedImage = image;
        _previewBytes = bytes;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat mengambil gambar.')),
      );
    }
  }

  void _showImageOptions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Ambil dari Kamera'),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await widget.onSave(
        ItemFormData(
          name: _nameController.text.trim(),
          category: _category,
          description: _descriptionController.text.trim(),
          condition: _condition,
          isDonation: widget.isDonation,
          pickupLocation: widget.isDonation
              ? _pickupController.text.trim()
              : null,
          image: _selectedImage,
        ),
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e is ApiException ? e.message : 'Terjadi kesalahan.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _isEditing
        ? 'Edit Barang'
        : widget.isDonation
        ? 'Form Donasi'
        : 'Tambah Barang';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Foto Barang',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _saving ? null : _showImageOptions,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                height: 170,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F4E9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFD5DDD7)),
                ),
                child: _buildImagePreview(),
              ),
            ),
            const SizedBox(height: 18),
            _label('Nama Barang'),
            TextFormField(
              controller: _nameController,
              maxLength: 150,
              decoration: const InputDecoration(
                hintText: 'Masukkan nama barang',
                counterText: '',
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Nama barang wajib diisi'
                  : null,
            ),
            const SizedBox(height: 16),
            _label('Kategori'),
            DropdownButtonFormField<String>(
              initialValue: _category,
              items: _categories
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: (value) => setState(() => _category = value!),
            ),
            const SizedBox(height: 16),
            _label('Kondisi Barang'),
            DropdownButtonFormField<String>(
              initialValue: _condition,
              items: _conditions
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: (value) => setState(() => _condition = value!),
            ),
            const SizedBox(height: 16),
            _label('Deskripsi'),
            TextFormField(
              controller: _descriptionController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Jelaskan kondisi dan informasi barang',
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Deskripsi wajib diisi'
                  : null,
            ),
            if (widget.isDonation) ...[
              const SizedBox(height: 16),
              _label('Lokasi Pengambilan'),
              TextFormField(
                controller: _pickupController,
                maxLength: 255,
                decoration: const InputDecoration(
                  hintText: 'Contoh: Depok, dekat Stasiun UI',
                  prefixIcon: Icon(Icons.place_outlined),
                  counterText: '',
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Lokasi pengambilan wajib diisi'
                    : null,
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: FilledButton.icon(
                onPressed: _saving ? null : _submitForm,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(
                  _saving
                      ? 'Menyimpan...'
                      : widget.isDonation
                      ? 'Kirim Donasi'
                      : 'Simpan Barang',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_previewBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.memory(_previewBytes!, fit: BoxFit.cover),
      );
    }
    if (_existingImageUrl != null) {
      return ItemImage(url: _existingImageUrl, width: double.infinity, height: 170);
    }
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo_outlined, size: 38, color: Color(0xFF267A43)),
        SizedBox(height: 8),
        Text('Ketuk untuk memilih foto'),
        Text(
          'Kamera atau galeri',
          style: TextStyle(color: Color(0xFF66736A), fontSize: 12),
        ),
      ],
    );
  }

  Widget _label(String value) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
  );
}
