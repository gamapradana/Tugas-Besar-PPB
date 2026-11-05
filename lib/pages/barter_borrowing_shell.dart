import 'package:flutter/material.dart';

import 'app_theme.dart';

import 'barter_offers_page.dart';
import 'borrowing_offers_page.dart';
import 'history_page.dart';

/// Kerangka navigasi modul Barter & Peminjaman (BottomNavigationBar).
/// Nanti dipasang oleh Orang 1 ke navigasi utama aplikasi.
class BarterBorrowingShell extends StatefulWidget {
  const BarterBorrowingShell({super.key});

  @override
  State<BarterBorrowingShell> createState() => _BarterBorrowingShellState();
}

class _BarterBorrowingShellState extends State<BarterBorrowingShell> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Halaman dibangun ulang setiap tab dipilih, sehingga Riwayat
    // selalu menampilkan data terbaru.
    final pages = <Widget>[
      const BarterOffersPage(),
      const BorrowingOffersPage(),
      const HistoryPage(),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        selectedItemColor: AppColors.green700,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Barter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handshake_outlined),
            label: 'Pinjam',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
        ],
      ),
    );
  }
}