import '../../../core/domain/entities/points_entry.dart';
import '../../../core/domain/entities/wallet_transaction.dart';

abstract class WalletRepository {
  Future<double> fetchBalance(String userId);
  Future<List<WalletTransaction>> fetchTransactions(String userId);
  Future<List<PointsEntry>> fetchPointsHistory(String userId);
  Future<void> convertPoints(String userId, int points);
  Future<void> requestWithdrawal(String userId, double amount);
}
