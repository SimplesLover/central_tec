import 'package:flutter/material.dart';

import '../../../../globals/utils/app_exceptions.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../../core/domain/entities/notification_item.dart';

class NotificationController extends ChangeNotifier {
  final NotificationRepository repository;

  List<NotificationItem> notifications = [];
  int unreadCount = 0;
  String? errorMessage;
  bool isLoading = false;

  NotificationController({required this.repository});

  Future<void> load(String userId) async {
    await _handle(() async {
      notifications = await repository.fetchNotifications(userId);
      unreadCount = await repository.unreadCount(userId);
    });
  }

  Future<void> markAll(String userId) async {
    await _handle(() async {
      await repository.markAllRead(userId);
      await load(userId);
    });
  }

  Future<void> _handle(Future<void> Function() action) async {
    _setLoading(true);
    try {
      await action();
      errorMessage = null;
    } on AppException catch (error) {
      errorMessage = error.message;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
