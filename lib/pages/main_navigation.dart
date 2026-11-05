import 'package:flutter/material.dart';

import '../controllers/item_controller.dart';
import '../models/cyclefy_item.dart';
import '../services/item_service.dart';
import 'dashboard_screen.dart';
import 'donation_screen.dart';
import 'item_detail_screen.dart';
import 'item_form_screen.dart';
import 'item_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final ItemController _controller = ItemController();
  int _selectedIndex = 0;
  String _searchText = '';
  String _selectedCategory = 'Semua';

  @override
  void initState() {
    super.initState();
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _snack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _openForm({required bool donation, CyclefyItem? item}) {
    final isDonation = item?.type == ItemType.donation || donation;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ItemFormScreen(
          isDonation: isDonation,
          existingItem: item,
          onSave: (data) async {
            await _controller.save(data, id: item?.id);
            if (!mounted) return;
            _snack(
              item != null
                  ? 'Barang berhasil diperbarui'
                  : isDonation
                  ? 'Donasi berhasil ditambahkan'
                  : 'Barang berhasil ditambahkan',
            );
          },
        ),
      ),
    );
  }

  void _openDetail(CyclefyItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ItemDetailScreen(
          item: item,
          onEdit: () {
            Navigator.pop(context);
            _openForm(donation: item.type == ItemType.donation, item: item);
          },
          onDelete: () async {
            try {
              await _controller.remove(item.id);
            } on ApiException catch (e) {
              if (mounted) _snack(e.message);
              return;
            }
            if (!mounted) return;
            Navigator.pop(context);
            _snack('Barang berhasil dihapus.');
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_controller.loading && _controller.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_controller.error != null && _controller.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 48, color: Color(0xFF66736A)),
              const SizedBox(height: 12),
              Text(_controller.error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _controller.load,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final items = _controller.items;
    final pages = [
      DashboardScreen(
        items: items,
        onOpenItems: () => setState(() => _selectedIndex = 1),
        onOpenDetail: _openDetail,
      ),
      ItemsScreen(
        items: items,
        searchText: _searchText,
        selectedCategory: _selectedCategory,
        onSearchChanged: (value) => setState(() => _searchText = value),
        onCategoryChanged: (value) => setState(() => _selectedCategory = value),
        onOpenDetail: _openDetail,
      ),
      DonationsScreen(
        donations: _controller.donations,
        onOpenDetail: _openDetail,
      ),
    ];
    return pages[_selectedIndex];
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [
              Icon(Icons.eco, color: Color(0xFF267A43)),
              SizedBox(width: 8),
              Text('Cyclefy', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Muat ulang',
              onPressed: _controller.loading ? null : _controller.load,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: _buildBody(),
        floatingActionButton: _selectedIndex == 1 || _selectedIndex == 2
            ? FloatingActionButton.extended(
                onPressed: () => _openForm(donation: _selectedIndex == 2),
                backgroundColor: const Color(0xFF267A43),
                foregroundColor: Colors.white,
                icon: const Icon(Icons.add),
                label: Text(_selectedIndex == 2 ? 'Donasi' : 'Tambah Barang'),
              )
            : null,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) =>
              setState(() => _selectedIndex = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.inventory_2_outlined),
              selectedIcon: Icon(Icons.inventory_2),
              label: 'Barang',
            ),
            NavigationDestination(
              icon: Icon(Icons.volunteer_activism_outlined),
              selectedIcon: Icon(Icons.volunteer_activism),
              label: 'Donasi',
            ),
          ],
        ),
      ),
    );
  }
}
