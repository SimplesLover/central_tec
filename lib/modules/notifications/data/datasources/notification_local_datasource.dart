import '../../../../globals/services/in_memory_database.dart';
import '../../../core/domain/entities/notification_item.dart';

class NotificationLocalDataSource {
  final InMemoryDatabase database;

  const NotificationLocalDataSource({required this.database});

  Future<List<NotificationItem>> fetchNotifications(String userId) async {
    return database.notificationsFor(userId);
  }

  Future<void> markAllRead(String userId) async {
    final items = database.notificationsFor(userId);
    final updated = items.map((item) => item.copyWith(isRead: true)).toList();
    database.saveNotifications(userId, updated);
  }
}
