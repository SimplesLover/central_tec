import '../../../../globals/services/in_memory_database.dart';
import '../../../core/domain/entities/order.dart';
import '../../../core/domain/entities/wallet_transaction.dart';

class DashboardLocalDataSource {
  final InMemoryDatabase database;

  const DashboardLocalDataSource({required this.database});

  Future<List<Order>> fetchOrders(String userId) async {
    return database.ordersFor(userId);
  }

  Future<List<WalletTransaction>> fetchTransactions(String userId) async {
    return database.transactionsFor(userId);
  }

  Future<int> rankingPosition(String userId) async {
    final users = database.users.toList()
      ..sort((a, b) => b.points.compareTo(a.points));
    final index = users.indexWhere((item) => item.id == userId);
    return index < 0 ? users.length : index + 1;
  }

  Future<int> totalReferrals(String userId) async {
    return database.referrals
        .where((item) => item.referrerId == userId)
        .length;
  }
}
