import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'package:flutter/services.dart';

import '../models/request_record.dart';

/// Dibuka lewat named route '/borrowing-request'.
/// Barang yang dipilih diterima lewat `arguments`.
class BorrowingRequestPage extends StatefulWidget {
  const BorrowingRequestPage({super.key});

  @override
  State<BorrowingRequestPage> createState() => _BorrowingRequestPageState();
}

class _BorrowingRequestPageState extends State<BorrowingRequestPage> {
  final TextEditingController durationController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  void showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  void sendRequest(Map<String, String> item) {
    final days = int.tryParse(durationController.text.trim());
    // Durasi maksimum dari penawaran, mis. "3 Hari" -> 3
    final maxDays = int.tryParse(item['duration']!.split(' ').first) ?? 0;

    if (days == null || days <= 0 || purposeController.text.trim().isEmpty) {
      showMessage('Durasi dan tujuan peminjaman wajib diisi!');
      return;
    }

    if (maxDays > 0 && days > maxDays) {
      showMessage('Durasi maksimum untuk barang ini $maxDays hari.');
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Permintaan Berhasil'),
          content: Text(
            'Permintaan peminjaman ${item['name']} '
            'berhasil disiapkan.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final record = RequestRecord(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  type: RequestType.borrowing,
                  itemName: item['name']!,
                  itemEmoji: item['emoji']!,
                  owner: item['owner']!,
                  durationDays: days,
                  purpose: purposeController.text.trim(),
                  message: messageController.text.trim(),
                );

                Navigator.pop(dialogContext); // tutup dialog
                Navigator.pop(context, record); // kembali + kirim data
              },
              child: const Text('Selesai'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    durationController.dispose();
    purposeController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.green900,
        foregroundColor: Colors.white,
        title: const Text('Permintaan Peminjaman'),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ajukan Peminjaman Barang',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gray900,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Lengkapi informasi peminjaman barang '
                'yang kamu butuhkan.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),

              const SizedBox(height: 25),

              const Text(
                'Barang yang Dipilih',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.green100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Text(
                      item['emoji']!,
                      style: const TextStyle(fontSize: 38),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            'Pemilik: ${item['owner']}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            'Durasi tersedia: ${item['duration']}',
                            style: const TextStyle(
                              color: AppColors.green700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Durasi Peminjaman',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Contoh: 2',
                  suffixText: 'hari',
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                'Tujuan Peminjaman',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: purposeController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Jelaskan tujuan peminjaman barang...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                'Pesan untuk Pemilik Barang',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: messageController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Tuliskan pesan tambahan...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => sendRequest(item),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Kirim Permintaan Peminjaman',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}