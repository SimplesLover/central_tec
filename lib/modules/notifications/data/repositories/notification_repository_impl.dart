import '../../../../globals/services/app_logger.dart';
import '../../../../globals/utils/app_exceptions.dart';
import '../../../core/domain/entities/notification_item.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_local_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource dataSource;
  final AppLogger logger;

  const NotificationRepositoryImpl({
    required this.dataSource,
    required this.logger,
  });

  @override
  Future<List<NotificationItem>> fetchNotifications(String userId) async {
    try {
      return await dataSource.fetchNotifications(userId);
    } catch (error) {
      logger.error('Falha ao carregar notificações');
      throw const AppException('Não foi possível carregar notificações');
    }
  }

  @override
  Future<int> unreadCount(String userId) async {
    try {
      final items = await dataSource.fetchNotifications(userId);
      return items.where((item) => !item.isRead).length;
    } catch (error) {
      logger.error('Falha ao contar notificações');
      throw const AppException('Não foi possível carregar notificações');
    }
  }

  @override
  Future<void> markAllRead(String userId) async {
    try {
      await dataSource.markAllRead(userId);
    } catch (error) {
      logger.error('Falha ao atualizar notificações');
      throw const AppException('Não foi possível atualizar notificações');
    }
  }
}
