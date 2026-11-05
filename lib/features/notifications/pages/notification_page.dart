import 'package:flutter/material.dart';

import '../../../pages/app_theme.dart';
import '../data/dummy_notifications.dart';
import '../models/notification_model.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final List<NotificationModel> notifications =
      List.from(dummyNotifications);

  int get unreadCount =>
      notifications.where((notification) => !notification.isRead).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.green900,
        foregroundColor: AppColors.white,
        title: const Text(
          'Notifikasi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: unreadCount == 0 ? null : _markAllAsRead,
            icon: const Icon(Icons.done_all),
            tooltip: 'Tandai semua dibaca',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildNotificationHeader(),
          Expanded(
            child: _buildNotificationList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aktivitas Terbaru',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$unreadCount notifikasi belum dibaca',
            style: const TextStyle(
              color: AppColors.gray600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    if (notifications.isEmpty) {
      return const Center(
        child: Text('Belum ada notifikasi.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];

        return _NotificationCard(
          notification: notification,
          onTap: () => _markAsRead(index),
        );
      },
    );
  }

  void _markAsRead(int index) {
    setState(() {
      final notification = notifications[index];

      notifications[index] = NotificationModel(
        title: notification.title,
        message: notification.message,
        time: notification.time,
        type: notification.type,
        isRead: true,
      );
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (int i = 0; i < notifications.length; i++) {
        final notification = notifications[i];

        notifications[i] = NotificationModel(
          title: notification.title,
          message: notification.message,
          time: notification.time,
          type: notification.type,
          isRead: true,
        );
      }
    });
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: notification.isRead
          ? AppColors.white
          : AppColors.green100,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: AppColors.white,
                child: Icon(
                  _getNotificationIcon(notification.type),
                  color: AppColors.green700,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.gray900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.message,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.gray600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notification.time,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
              if (!notification.isRead)
                const Icon(
                  Icons.circle,
                  color: AppColors.green700,
                  size: 10,
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'donation':
        return Icons.volunteer_activism;
      case 'borrowing':
        return Icons.inventory_2_outlined;
      case 'barter':
        return Icons.swap_horiz;
      case 'recycling':
        return Icons.recycling;
      default:
        return Icons.notifications_outlined;
    }
  }
}