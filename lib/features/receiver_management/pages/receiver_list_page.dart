import 'package:flutter/material.dart';

import 'receiver_form_page.dart';
import '../../../pages/app_theme.dart';
import '../data/dummy_receiver.dart';
import '../models/receiver_location.dart';

class ReceiverListPage extends StatefulWidget {
  const ReceiverListPage({super.key});

  @override
  State<ReceiverListPage> createState() => _ReceiverListPageState();
}

class _ReceiverListPageState extends State<ReceiverListPage> {
  final List<ReceiverLocation> receivers = List.from(dummyReceivers);

  
  Future<void> _addReceiver() async {
    final result = await Navigator.push<ReceiverLocation>(
      context,
      MaterialPageRoute(
        builder: (context) => const ReceiverFormPage(),
      ),
    );

    if (result != null) {
      setState(() {
        receivers.add(result);
      });
    }
  }
  
  void _deleteReceiver(int index) {
    final receiver = receivers[index];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Lokasi'),
          content: Text(
            'Apakah kamu yakin ingin menghapus ${receiver.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  receivers.removeAt(index);
                });

                Navigator.pop(context);
              },
              child: const Text(
                'Hapus',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.green700,
        foregroundColor: AppColors.white,
        title: const Text('Receiver Management'),
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildSummary(),
          Expanded(child: _buildReceiverList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addReceiver,
        backgroundColor: AppColors.green700,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Lokasi'),
      ),
    );
  }

  Future<void> _editReceiver(int index) async {
    final result = await Navigator.push<ReceiverLocation>(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiverFormPage(receiver: receivers[index]),
      ),
    );

    if (result != null) {
      setState(() {
        receivers[index] = result;
      });
    }
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: AppColors.green700,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kelola Lokasi Penerimaan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Pantau dan kelola tempat penerimaan barang daur ulang.',
            style: TextStyle(fontSize: 13, color: AppColors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    final totalLocations = receivers.length;

    final activeLocations = receivers
        .where((receiver) => receiver.status == 'Active')
        .length;

    final pendingLocations = receivers
        .where((receiver) => receiver.status == 'Pending')
        .length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _SummaryCard(
              title: 'Total Lokasi',
              value: totalLocations.toString(),
              icon: Icons.location_on_outlined,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _SummaryCard(
              title: 'Aktif',
              value: activeLocations.toString(),
              icon: Icons.check_circle_outline,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _SummaryCard(
              title: 'Pending',
              value: pendingLocations.toString(),
              icon: Icons.pending_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiverList() {
    if (receivers.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada lokasi penerimaan.',
          style: TextStyle(color: AppColors.gray600),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: receivers.length,
      itemBuilder: (context, index) {
        final receiver = receivers[index];

        return _ReceiverCard(
          receiver: receiver,
          onEdit: () => _editReceiver(index),
          onDelete: () => _deleteReceiver(index),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.green700, size: 22),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.gray900,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: AppColors.gray600),
          ),
        ],
      ),
    );
  }
}

class _ReceiverCard extends StatelessWidget {
  final ReceiverLocation receiver;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ReceiverCard({
    required this.receiver,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.gray100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.green100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.recycling, color: AppColors.green700),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    receiver.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gray900,
                    ),
                  ),
                ),
                _ReceiverStatusBadge(status: receiver.status),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.green700,
                    size: 20,
                  ),
                  tooltip: 'Edit lokasi',
                ),
              ],
            ),

            const SizedBox(height: 14),
            Text(
              receiver.address,
              style: const TextStyle(fontSize: 13, color: AppColors.gray600),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: receiver.acceptedCategories.map((category) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.green100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.green900,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppColors.gray600,
                ),
                const SizedBox(width: 5),
                Text(
                  receiver.operatingHours,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.gray600,
                  ),
                ),
                const Spacer(),
                Text(
                  receiver.isActive ? 'Aktif' : 'Nonaktif',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: receiver.isActive
                        ? AppColors.success
                        : AppColors.gray600,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete_outline,
                color: AppColors.error,
                size: 20,
              ),
              tooltip: 'Hapus lokasi',
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiverStatusBadge extends StatelessWidget {
  final String status;

  const _ReceiverStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case 'Active':
        backgroundColor = AppColors.green100;
        textColor = AppColors.success;
        break;
      case 'Pending':
        backgroundColor = const Color(0xFFFFF4D6);
        textColor = AppColors.warning;
        break;
      case 'Rejected':
        backgroundColor = const Color(0xFFFDE8E8);
        textColor = AppColors.error;
        break;
      default:
        backgroundColor = AppColors.gray100;
        textColor = AppColors.gray600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
