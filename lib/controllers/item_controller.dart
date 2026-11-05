import 'package:flutter/foundation.dart';

import '../models/cyclefy_item.dart';
import '../models/item_form_data.dart';

/// Controller frontend-only: seluruh data disimpan sementara di memori.
/// Tidak melakukan request ke backend/API.
class ItemController extends ChangeNotifier {
  List<CyclefyItem> items = [];
  bool loading = false;
  String? error;
  int _nextId = 5;

  List<CyclefyItem> get donations =>
      items.where((item) => item.type == ItemType.donation).toList();

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();

    // Data dummy agar halaman bisa ditampilkan tanpa server.
    items = [
      const CyclefyItem(
        id: 1,
        name: 'Buku Pemrograman Flutter',
        category: 'Buku',
        description: 'Buku belajar Flutter, kondisi masih bagus.',
        condition: 'Baik',
        type: ItemType.regular,
        isOwner: true,
      ),
      const CyclefyItem(
        id: 2,
        name: 'Headphone Bluetooth',
        category: 'Elektronik',
        description: 'Headphone masih berfungsi dengan baik.',
        condition: 'Baik',
        type: ItemType.regular,
        isOwner: true,
      ),
      const CyclefyItem(
        id: 3,
        name: 'Baju Kaos',
        category: 'Pakaian',
        description: 'Kaos layak pakai untuk didonasikan.',
        condition: 'Baik',
        type: ItemType.donation,
        pickupLocation: 'Depok',
        isOwner: true,
      ),
      const CyclefyItem(
        id: 4,
        name: 'Tas Sekolah',
        category: 'Aksesoris',
        description: 'Tas sekolah yang masih layak digunakan.',
        condition: 'Sangat Baik',
        type: ItemType.donation,
        pickupLocation: 'Jakarta',
        isOwner: true,
      ),
    ];
    _nextId = 5;

    loading = false;
    notifyListeners();
  }

  Future<void> save(ItemFormData data, {int? id}) async {
    if (id == null) {
      items.add(
        CyclefyItem(
          id: _nextId++,
          name: data.name,
          category: data.category,
          description: data.description,
          condition: data.condition,
          type: data.isDonation ? ItemType.donation : ItemType.regular,
          pickupLocation: data.pickupLocation,
          isOwner: true,
        ),
      );
    } else {
      final index = items.indexWhere((item) => item.id == id);
      if (index != -1) {
        final oldItem = items[index];
        items[index] = CyclefyItem(
          id: id,
          name: data.name,
          category: data.category,
          description: data.description,
          condition: data.condition,
          type: data.isDonation ? ItemType.donation : ItemType.regular,
          pickupLocation: data.pickupLocation,
          imageUrl: oldItem.imageUrl,
          status: oldItem.status,
          isOwner: true,
        );
      }
    }
    notifyListeners();
  }

  Future<void> remove(int id) async {
    items.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
