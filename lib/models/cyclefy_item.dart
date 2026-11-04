enum ItemType { regular, donation }

class CyclefyItem {
  CyclefyItem({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.condition,
    required this.type,
    this.imagePath,
  });

  final int id;
  final String name;
  final String category;
  final String description;
  final String condition;
  final ItemType type;
  final String? imagePath;

  CyclefyItem copyWith({
    String? name,
    String? category,
    String? description,
    String? condition,
    ItemType? type,
    String? imagePath,
  }) {
    return CyclefyItem(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      condition: condition ?? this.condition,
      type: type ?? this.type,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
