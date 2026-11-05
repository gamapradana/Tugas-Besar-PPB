import 'package:flutter/material.dart';

enum RequestType { barter, borrowing }

enum RequestStatus {
  menunggu('Menunggu', Colors.orange),
  disetujui('Disetujui', Color(0xFF477A55)),
  ditolak('Ditolak', Colors.red),
  dibatalkan('Dibatalkan', Colors.grey),
  selesai('Selesai', Colors.blue);

  final String label;
  final Color color;

  const RequestStatus(this.label, this.color);
}

class RequestRecord {
  final String id;
  final RequestType type;
  final String itemName;
  final String itemEmoji;
  final String owner;
  final String offeredItem;
  final int durationDays;
  final String purpose;
  final String message;
  final DateTime createdAt;
  RequestStatus status;

  RequestRecord({
    required this.id,
    required this.type,
    required this.itemName,
    required this.itemEmoji,
    required this.owner,
    this.offeredItem = '',
    this.durationDays = 0,
    this.purpose = '',
    this.message = '',
    DateTime? createdAt,
    this.status = RequestStatus.menunggu,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isBarter => type == RequestType.barter;
}

String formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';