import '../../../../globals/services/app_logger.dart';
import '../../../../globals/utils/app_exceptions.dart';
import '../../../core/domain/entities/order.dart';
import '../../../core/domain/entities/wallet_transaction.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../../network/domain/repositories/network_repository.dart';
import '../datasources/dashboard_local_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDataSource dataSource;
  final NetworkRepository networkRepository;
  final AppLogger logger;

  const DashboardRepositoryImpl({
    required this.dataSource,
    required this.networkRepository,
    required this.logger,
  });

  @override
  Future<DashboardStats> fetchStats({
    required String userId,
    required int points,
  }) async {
    try {
      final orders = await dataSource.fetchOrders(userId);
      final transactions = await dataSource.fetchTransactions(userId);
      final network = await networkRepository.fetchNetwork(userId);
      final ranking = await dataSource.rankingPosition(userId);
      final balance = _sumTransactions(transactions);
      final monthlyCommissions = _monthlyCommissions(transactions);
      final salesSeries = _monthlySalesSeries(orders);
      final commissionSeries = _monthlyCommissionSeries(transactions);
      return DashboardStats(
        totalReferrals: network.total,
        points: points,
        walletBalance: balance,
        monthlyCommissions: monthlyCommissions,
        rankingPosition: ranking,
        monthlySales: salesSeries,
        monthlyCommissionsSeries: commissionSeries,
      );
    } catch (error) {
      logger.error('Falha ao carregar dashboard');
      throw const AppException('Não foi possível carregar dashboard');
    }
  }

  double _sumTransactions(List<WalletTransaction> transactions) {
    return transactions.fold(0, (value, item) => value + item.amount);
  }

  double _monthlyCommissions(List<WalletTransaction> transactions) {
    final now = DateTime.now();
    return transactions
        .where((item) =>
            item.type == WalletTransactionType.commission &&
            item.createdAt.month == now.month &&
            item.createdAt.year == now.year)
        .fold(0, (value, item) => value + item.amount);
  }

  List<double> _monthlySalesSeries(List<Order> orders) {
    final now = DateTime.now();
    final months = List<double>.filled(6, 0);
    for (final order in orders) {
      final diff = _monthDiff(now, order.createdAt);
      if (diff >= 0 && diff < months.length) {
        months[months.length - 1 - diff] += order.total;
      }
    }
    return months;
  }

  List<double> _monthlyCommissionSeries(List<WalletTransaction> transactions) {
    final now = DateTime.now();
    final months = List<double>.filled(6, 0);
    for (final transaction in transactions) {
      if (transaction.type != WalletTransactionType.commission) {
        continue;
      }
      final diff = _monthDiff(now, transaction.createdAt);
      if (diff >= 0 && diff < months.length) {
        months[months.length - 1 - diff] += transaction.amount;
      }
    }
    return months;
  }

  int _monthDiff(DateTime start, DateTime end) {
    return (start.year - end.year) * 12 + (start.month - end.month);
  }
}
