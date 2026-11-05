import 'package:image_picker/image_picker.dart';

/// Data yang dikirim dari form ke server.
class ItemFormData {
  const ItemFormData({
    required this.name,
    required this.category,
    required this.description,
    required this.condition,
    required this.isDonation,
    this.pickupLocation,
    this.image,
  });

  final String name;
  final String category;
  final String description;
  final String condition;
  final bool isDonation;
  final String? pickupLocation;
  final XFile? image; // null = tidak ada gambar baru

  Map<String, String> toFields() => {
    'name': name,
    'category': category,
    'description': description,
    'condition': condition,
    if (pickupLocation != null && pickupLocation!.isNotEmpty)
      'pickup_location': pickupLocation!,
  };
}
