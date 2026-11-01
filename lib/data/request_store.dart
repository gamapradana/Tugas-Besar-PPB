import '../models/request_record.dart';

class RequestStore {
  RequestStore._();

  static final List<RequestRecord> _requests = [
    RequestRecord(
      id: 'seed-1',
      type: RequestType.barter,
      itemName: 'Buku Pemrograman',
      itemEmoji: '📚',
      owner: 'Siti Rahma',
      offeredItem: 'Buku Desain',
      message: 'Kondisi buku masih bagus.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      status: RequestStatus.disetujui,
    ),
    RequestRecord(
      id: 'seed-2',
      type: RequestType.borrowing,
      itemName: 'Kamera DSLR',
      itemEmoji: '📷',
      owner: 'Andi Pratama',
      durationDays: 2,
      purpose: 'Dokumentasi acara himpunan',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      status: RequestStatus.menunggu,
    ),
    RequestRecord(
      id: 'seed-3',
      type: RequestType.borrowing,
      itemName: 'Bor Listrik',
      itemEmoji: '🔧',
      owner: 'Siti Rahma',
      durationDays: 1,
      purpose: 'Memasang rak',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      status: RequestStatus.ditolak,
    ),
  ];

  static List<RequestRecord> get all {
    final list = List<RequestRecord>.from(_requests);
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  static List<RequestRecord> byType(RequestType type) =>
      all.where((r) => r.type == type).toList();

  static void add(RequestRecord record) => _requests.add(record);

  static void updateStatus(RequestRecord record, RequestStatus status) {
    record.status = status;
  }
}
