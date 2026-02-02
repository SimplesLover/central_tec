import '../entities/dashboard_stats.dart';

abstract class DashboardRepository {
  Future<DashboardStats> fetchStats({
    required String userId,
    required int points,
  });
}
