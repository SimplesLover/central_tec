import '../../../core/domain/entities/notification_item.dart';

abstract class NotificationRepository {
  Future<List<NotificationItem>> fetchNotifications(String userId);
  Future<int> unreadCount(String userId);
  Future<void> markAllRead(String userId);
}
