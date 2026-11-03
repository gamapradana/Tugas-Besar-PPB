import 'package:flutter/material.dart';

import '../data/request_store.dart';
import '../models/request_record.dart';
import 'history_page.dart';

/// Detail & status transaksi (FR-08, FR-11).
/// Dibuka lewat named route '/request-detail' dengan arguments RequestRecord.
class RequestDetailPage extends StatefulWidget {
  const RequestDetailPage({super.key});

  @override
  State<RequestDetailPage> createState() => _RequestDetailPageState();
}

class _RequestDetailPageState extends State<RequestDetailPage> {
  void _setStatus(RequestRecord record, RequestStatus status, String message) {
    setState(() => RequestStore.updateStatus(record, status));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _confirmCancel(RequestRecord record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Batalkan permintaan?'),
        content: Text('Permintaan untuk ${record.itemName} akan dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      _setStatus(record, RequestStatus.dibatalkan, 'Permintaan dibatalkan.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final record = ModalRoute.of(context)!.settings.arguments as RequestRecord;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF477A55),
        foregroundColor: Colors.white,
        title: Text(record.isBarter ? 'Detail Barter' : 'Detail Peminjaman'),
        actions: [
          // MENU DEMO: menggantikan respon pemilik barang sampai API tersedia.
          // Hapus saat backend sudah ada.
          if (record.status == RequestStatus.menunggu)
            PopupMenuButton<RequestStatus>(
              tooltip: 'Simulasi respon pemilik',
              onSelected: (status) => _setStatus(
                record,
                status,
                'Simulasi: permintaan ${status.label.toLowerCase()}.',
              ),
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: RequestStatus.disetujui,
                  child: Text('Simulasi: Setujui'),
                ),
                PopupMenuItem(
                  value: RequestStatus.ditolak,
                  child: Text('Simulasi: Tolak'),
                ),
              ],
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildItemCard(record),
              const SizedBox(height: 22),
              const Text(
                'Status Transaksi',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              _buildTimeline(record),
              const SizedBox(height: 12),
              const Text(
                'Informasi Permintaan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              _buildInfo(record),
              const SizedBox(height: 26),
              _buildActions(record),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(RequestRecord record) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF1E8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Text(record.itemEmoji, style: const TextStyle(fontSize: 42)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.itemName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Pemilik: ${record.owner}',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 8),
                StatusBadge(status: record.status),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Langkah status: Diajukan -> Disetujui -> Selesai.
  /// Jika ditolak/dibatalkan, langkah terakhir diganti status akhir tersebut.
  Widget _buildTimeline(RequestRecord record) {
    final status = record.status;
    final failed =
        status == RequestStatus.ditolak || status == RequestStatus.dibatalkan;

    final steps = <String>[
      'Diajukan',
      failed ? status.label : 'Disetujui',
      if (!failed) 'Selesai',
    ];

    int currentStep;
    switch (status) {
      case RequestStatus.menunggu:
        currentStep = 0;
        break;
      case RequestStatus.disetujui:
        currentStep = 1;
        break;
      case RequestStatus.selesai:
        currentStep = 2;
        break;
      default:
        currentStep = 1; // ditolak / dibatalkan
    }

    return Column(
      children: [
        for (int i = 0; i < steps.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Icon(
                  i > currentStep
                      ? Icons.radio_button_unchecked
                      : (failed && i == 1 ? Icons.cancel : Icons.check_circle),
                  color: i > currentStep
                      ? Colors.grey
                      : (failed && i == 1
                          ? status.color
                          : const Color(0xFF477A55)),
                ),
                const SizedBox(width: 10),
                Text(
                  steps[i],
                  style: TextStyle(
                    fontWeight:
                        i == currentStep ? FontWeight.bold : FontWeight.normal,
                    color: i > currentStep ? Colors.grey : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildInfo(RequestRecord record) {
    final rows = <MapEntry<String, String>>[
      MapEntry('Tanggal diajukan', formatDate(record.createdAt)),
      if (record.isBarter)
        MapEntry('Barang ditawarkan', record.offeredItem)
      else ...[
        MapEntry('Durasi', '${record.durationDays} hari'),
        MapEntry('Tujuan', record.purpose),
      ],
      MapEntry('Pesan', record.message.isEmpty ? '-' : record.message),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E9E2)),
      ),
      child: Column(
        children: [
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 130,
                    child: Text(
                      row.key,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      row.value,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActions(RequestRecord record) {
    if (record.status == RequestStatus.menunggu) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () => _confirmCancel(record),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: const Text('Batalkan Permintaan'),
        ),
      );
    }

    if (record.status == RequestStatus.disetujui) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _setStatus(
            record,
            RequestStatus.selesai,
            record.isBarter
                ? 'Barter ditandai selesai.'
                : 'Peminjaman ditandai selesai (barang dikembalikan).',
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF477A55),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: Text(
            record.isBarter
                ? 'Tandai Barter Selesai'
                : 'Tandai Sudah Dikembalikan',
          ),
        ),
      );
    }

    // Status akhir (ditolak, dibatalkan, selesai): tidak ada aksi.
    return const SizedBox.shrink();
  }
}