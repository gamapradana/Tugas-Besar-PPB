
import 'package:flutter/material.dart';

class BorrowingRequestPage extends StatefulWidget {
  final Map<String, String> item;

  const BorrowingRequestPage({
    super.key,
    required this.item,
  });

  @override
  State<BorrowingRequestPage> createState() =>
      _BorrowingRequestPageState();
}

class _BorrowingRequestPageState
    extends State<BorrowingRequestPage> {

  final TextEditingController durationController =
      TextEditingController();

  final TextEditingController purposeController =
      TextEditingController();

  final TextEditingController messageController =
      TextEditingController();

  void sendRequest() {
    if (durationController.text.trim().isEmpty ||
        purposeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Durasi dan tujuan peminjaman wajib diisi!',
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Permintaan Berhasil'),
          content: Text(
            'Permintaan peminjaman ${widget.item['name']} '
            'berhasil disiapkan.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(context);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF477A55),
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
                  color: Color(0xFF294D35),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Lengkapi informasi peminjaman barang '
                'yang kamu butuhkan.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Barang yang Dipilih',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF1E8),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Text(
                      widget.item['emoji']!,
                      style: const TextStyle(fontSize: 38),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item['name']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            'Pemilik: ${widget.item['owner']}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            'Durasi tersedia: '
                            '${widget.item['duration']}',
                            style: const TextStyle(
                              color: Color(0xFF477A55),
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Contoh: 2 hari',
                  prefixIcon: const Icon(
                    Icons.calendar_today_outlined,
                  ),
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
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
                  onPressed: sendRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF477A55),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Kirim Permintaan Peminjaman',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
