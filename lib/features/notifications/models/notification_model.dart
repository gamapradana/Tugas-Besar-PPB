class NotificationModel {
  final String title;
  final String message;
  final String time;
  final String type;
  final bool isRead;

  const NotificationModel({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.isRead,
  });
}