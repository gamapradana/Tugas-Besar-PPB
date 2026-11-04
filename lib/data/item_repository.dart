import '../models/cyclefy_item.dart';

class ItemRepository {
  final List<CyclefyItem> _items = [
    CyclefyItem(
      id: 1,
      name: 'Buku Pemrograman',
      category: 'Buku',
      description: 'Buku pemrograman yang masih layak digunakan.',
      condition: 'Baik',
      type: ItemType.regular,
    ),
    CyclefyItem(
      id: 2,
      name: 'Tas Kuliah',
      category: 'Aksesoris',
      description: 'Tas kuliah untuk diberikan kepada yang membutuhkan.',
      condition: 'Sangat baik',
      type: ItemType.donation,
    ),
    CyclefyItem(
      id: 3,
      name: 'Botol Minum',
      category: 'Rumah Tangga',
      description: 'Botol minum reusable, kondisi masih bagus.',
      condition: 'Baik',
      type: ItemType.regular,
    ),
  ];

  List<CyclefyItem> get all => List.unmodifiable(_items);

  List<CyclefyItem> get donations =>
      _items.where((item) => item.type == ItemType.donation).toList();

  void add(CyclefyItem item) => _items.insert(0, item);

  void update(CyclefyItem updated) {
    final index = _items.indexWhere((item) => item.id == updated.id);
    if (index != -1) _items[index] = updated;
  }

  void delete(int id) => _items.removeWhere((item) => item.id == id);
}
