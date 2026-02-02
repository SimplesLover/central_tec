import '../../../../globals/services/in_memory_database.dart';
import '../../../core/domain/entities/points_entry.dart';
import '../../../core/domain/entities/wallet_transaction.dart';

class WalletLocalDataSource {
  final InMemoryDatabase database;

  const WalletLocalDataSource({required this.database});

  Future<List<WalletTransaction>> fetchTransactions(String userId) async {
    return database.transactionsFor(userId);
  }

  Future<List<PointsEntry>> fetchPointsHistory(String userId) async {
    return database.pointsFor(userId);
  }
}
