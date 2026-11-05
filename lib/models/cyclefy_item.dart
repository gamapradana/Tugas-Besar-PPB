enum ItemType { regular, donation }

class CyclefyItem {
  const CyclefyItem({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.condition,
    required this.type,
    this.imageUrl,
    this.pickupLocation,
    this.status = 'available',
    this.isOwner = false,
  });

  final int id;
  final String name;
  final String category;
  final String description;
  final String condition;
  final ItemType type;
  final String? imageUrl; // URL gambar utama dari server
  final String? pickupLocation; // hanya untuk donasi
  final String status; // available | pending | completed
  final bool isOwner; // true jika item milik user yang sedang login

  factory CyclefyItem.fromJson(Map<String, dynamic> json) {
    final images = (json['images'] as List? ?? const []).cast<String>();
    return CyclefyItem(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      condition: json['condition'] as String,
      type: json['type'] == 'donation' ? ItemType.donation : ItemType.regular,
      imageUrl: images.isNotEmpty ? images.first : null,
      pickupLocation: json['pickup_location'] as String?,
      status: json['status'] as String? ?? 'available',
      isOwner: json['is_owner'] == true,
    );
  }
}
