import 'package:flutter/material.dart';

import 'app_theme.dart';

import '../data/request_store.dart';
import '../models/request_record.dart';
import 'borrowing_request_page.dart';
import 'request_detail_page.dart';

class BorrowingOffersPage extends StatelessWidget {
  const BorrowingOffersPage({super.key});

  final List<Map<String, String>> borrowingItems = const [
    {
      'name': 'Kamera DSLR',
      'owner': 'Andi Pratama',
      'condition': 'Sangat Baik',
      'duration': '3 Hari',
      'terms': 'Dikembalikan dalam kondisi semula',
      'emoji': '📷',
    },
    {
      'name': 'Bor Listrik',
      'owner': 'Siti Rahma',
      'condition': 'Baik',
      'duration': '2 Hari',
      'terms': 'Digunakan dengan hati-hati',
      'emoji': '🔧',
    },
    {
      'name': 'Tenda Camping',
      'owner': 'Budi Santoso',
      'condition': 'Sangat Baik',
      'duration': '5 Hari',
      'terms': 'Dibersihkan sebelum dikembalikan',
      'emoji': '⛺',
    },
    {
      'name': 'Proyektor',
      'owner': 'Dina Putri',
      'condition': 'Baik',
      'duration': '3 Hari',
      'terms': 'Aksesori harus dikembalikan lengkap',
      'emoji': '📽️',
    },
  ];

  Future<void> _openRequestForm(
    BuildContext context,
    Map<String, String> item,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        settings: RouteSettings(arguments: item),
        builder: (_) => const BorrowingRequestPage(),
      ),
    );

    if (!context.mounted) return;

    if (result is RequestRecord) {
      RequestStore.add(result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Permintaan peminjaman terkirim. Cek di Riwayat.',
          ),
          action: SnackBarAction(
            label: 'Lihat',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                settings: RouteSettings(arguments: result),
                builder: (_) => const RequestDetailPage(),
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.green900,
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.recycling, size: 27),
            SizedBox(width: 10),
            Text(
              'Cyclefy',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header halaman
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: AppColors.green700,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Peminjaman Barang',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'Pinjam barang yang kamu butuhkan '
                    'dan gunakan dengan bijak!',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            // Judul daftar penawaran
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Penawaran Peminjaman',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gray900,
                    ),
                  ),
                  Text(
                    '${borrowingItems.length} Barang',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),

            // Daftar barang
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: borrowingItems.length,
                itemBuilder: (context, index) {
                  final item = borrowingItems[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.gray300),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Ilustrasi barang
                            Container(
                              width: 95,
                              height: 100,
                              decoration: BoxDecoration(
                                color: AppColors.green100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  item['emoji']!,
                                  style: const TextStyle(fontSize: 43),
                                ),
                              ),
                            ),

                            const SizedBox(width: 14),

                            // Informasi barang
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 7),

                                  Text(
                                    'Pemilik: ${item['owner']}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    'Kondisi: ${item['condition']}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 9,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.green100,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Durasi: ${item['duration']}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.green700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Ketentuan peminjaman
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.gray50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.info_outline,
                                size: 18,
                                color: AppColors.green700,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Ketentuan: ${item['terms']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 13),

                        // Tombol pengajuan peminjaman
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.green700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),

                            onPressed: () => _openRequestForm(context, item),

                            child: const Text(
                              'Ajukan Peminjaman',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
