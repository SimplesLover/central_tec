import 'package:flutter/material.dart';

import '../../../../globals/utils/app_exceptions.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardController extends ChangeNotifier {
  final DashboardRepository repository;

  DashboardStats? stats;
  String? errorMessage;
  bool isLoading = false;

  DashboardController({required this.repository});

  Future<void> load(String userId, int points) async {
    await _handle(() async {
      stats = await repository.fetchStats(userId: userId, points: points);
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
