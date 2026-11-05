import 'package:flutter/material.dart';

import '../data/request_store.dart';
import '../models/request_record.dart';

class BarterOffersPage extends StatelessWidget {
  const BarterOffersPage({super.key});

  final List<Map<String, String>> barterItems = const [
    {
      'name': 'Sepatu Sneakers',
      'owner': 'Andi Pratama',
      'condition': 'Sangat Baik',
      'wanted': 'Tas Ransel',
      'emoji': '👟',
    },
    {
      'name': 'Buku Pemrograman',
      'owner': 'Siti Rahma',
      'condition': 'Baik',
      'wanted': 'Buku Desain',
      'emoji': '📚',
    },
    {
      'name': 'Headphone Wireless',
      'owner': 'Budi Santoso',
      'condition': 'Sangat Baik',
      'wanted': 'Mouse Wireless',
      'emoji': '🎧',
    },
    {
      'name': 'Tas Kuliah',
      'owner': 'Dina Putri',
      'condition': 'Baik',
      'wanted': 'Sepatu Sneakers',
      'emoji': '🎒',
    },
  ];

  Future<void> _openRequestForm(
    BuildContext context,
    Map<String, String> item,
  ) async {
    final result = await Navigator.pushNamed(
      context,
      '/barter-request',
      arguments: item,
    );

    if (!context.mounted) return;

    if (result is RequestRecord) {
      RequestStore.add(result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Permintaan barter terkirim. Cek di Riwayat.'),
          action: SnackBarAction(
            label: 'Lihat',
            onPressed: () => Navigator.pushNamed(
              context,
              '/request-detail',
              arguments: result,
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
        backgroundColor: const Color(0xFF477A55),
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
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: const Color(0xFF477A55),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Barter Barang',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'Temukan barang menarik dan tukarkan '
                    'dengan barang milikmu!',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Penawaran Barter',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF294D35),
                    ),
                  ),
                  Text(
                    '${barterItems.length} Barang',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: barterItems.length,
                itemBuilder: (context, index) {
                  final item = barterItems[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E9E2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 95,
                              height: 100,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF1E8),
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
                                      color: const Color(0xFFEAF1E8),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Ingin: ${item['wanted']}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF477A55),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 13),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF477A55),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => _openRequestForm(context, item),
                            child: const Text('Ajukan Barter'),
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
