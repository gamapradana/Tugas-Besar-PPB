import '../models/notification_model.dart';

final List<NotificationModel> dummyNotifications = [
  const NotificationModel(
    title: 'Donasi Berhasil',
    message: 'Barang donasi kamu berhasil dikirim kepada penerima.',
    time: '5 menit yang lalu',
    type: 'donation',
    isRead: false,
  ),
  const NotificationModel(
    title: 'Permintaan Peminjaman',
    message: 'Seseorang mengajukan permintaan untuk meminjam barangmu.',
    time: '1 jam yang lalu',
    type: 'borrowing',
    isRead: false,
  ),
  const NotificationModel(
    title: 'Permintaan Barter',
    message: 'Ada pengguna yang tertarik melakukan barter dengan barangmu.',
    time: '3 jam yang lalu',
    type: 'barter',
    isRead: true,
  ),
  const NotificationModel(
    title: 'Informasi Daur Ulang',
    message: 'Terdapat lokasi penerimaan barang daur ulang baru.',
    time: 'Kemarin',
    type: 'recycling',
    isRead: true,
  ),
  const NotificationModel(
    title: 'Peminjaman Selesai',
    message: 'Masa peminjaman barang telah selesai.',
    time: '2 hari yang lalu',
    type: 'borrowing',
    isRead: true,
  ),
];