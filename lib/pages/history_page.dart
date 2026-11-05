import 'package:flutter/material.dart';

import '../data/request_store.dart';
import '../models/request_record.dart';

/// Riwayat permintaan barter & peminjaman (FR-19).
/// Tab: Barter | Peminjaman. Filter status memakai ChoiceChip.
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // null = semua status
  RequestStatus? selectedStatus;

  Future<void> _openDetail(RequestRecord record) async {
    await Navigator.pushNamed(context, '/request-detail', arguments: record);
    // Status bisa berubah di halaman detail -> refresh daftar.
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF477A55),
          foregroundColor: Colors.white,
          title: const Text(
            'Riwayat Permintaan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.swap_horiz), text: 'Barter'),
              Tab(icon: Icon(Icons.handshake_outlined), text: 'Peminjaman'),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildFilter(),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildList(RequestType.barter),
                    _buildList(RequestType.borrowing),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilter() {
    return SizedBox(
      height: 54,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: const Text('Semua'),
              selected: selectedStatus == null,
              onSelected: (_) => setState(() => selectedStatus = null),
            ),
          ),
          for (final status in RequestStatus.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(status.label),
                selected: selectedStatus == status,
                onSelected: (_) => setState(() => selectedStatus = status),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildList(RequestType type) {
    final records = RequestStore.byType(type)
        .where((r) => selectedStatus == null || r.status == selectedStatus)
        .toList();

    // Tampilan kosong
    if (records.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inbox_outlined, size: 60, color: Colors.grey[400]),
              const SizedBox(height: 12),
              const Text(
                'Belum ada permintaan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'Ajukan barter atau peminjaman dari halaman penawaran.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _openDetail(record),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E9E2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF1E8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      record.itemEmoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.itemName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pemilik: ${record.owner}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        record.isBarter
                            ? 'Ditukar dengan: ${record.offeredItem}'
                            : 'Durasi: ${record.durationDays} hari',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        formatDate(record.createdAt),
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                StatusBadge(status: record.status),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Label status berwarna, dipakai di riwayat dan detail.
class StatusBadge extends StatelessWidget {
  final RequestStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: status.color.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: status.color,
        ),
      ),
    );
  }
}