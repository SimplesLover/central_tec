import '../../../../globals/constants/app_constants.dart';
import '../../../../globals/services/app_logger.dart';
import '../../../../globals/services/in_memory_database.dart';
import '../../../../globals/utils/app_exceptions.dart';
import '../../../../globals/utils/id_generator.dart';
import '../../../core/domain/entities/app_user.dart';
import '../../../core/domain/entities/points_entry.dart';
import '../../../core/domain/entities/wallet_transaction.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_local_datasource.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletLocalDataSource dataSource;
  final InMemoryDatabase database;
  final IdGenerator idGenerator;
  final AppLogger logger;

  const WalletRepositoryImpl({
    required this.dataSource,
    required this.database,
    required this.idGenerator,
    required this.logger,
  });

  @override
  Future<double> fetchBalance(String userId) async {
    try {
      final transactions = await dataSource.fetchTransactions(userId);
      return _sumTransactions(transactions);
    } catch (error) {
      logger.error('Falha ao carregar saldo');
      throw const AppException('Não foi possível carregar o saldo');
    }
  }

  @override
  Future<List<WalletTransaction>> fetchTransactions(String userId) async {
    try {
      return await dataSource.fetchTransactions(userId);
    } catch (error) {
      logger.error('Falha ao carregar transações');
      throw const AppException('Não foi possível carregar transações');
    }
  }

  @override
  Future<List<PointsEntry>> fetchPointsHistory(String userId) async {
    try {
      return await dataSource.fetchPointsHistory(userId);
    } catch (error) {
      logger.error('Falha ao carregar pontos');
      throw const AppException('Não foi possível carregar pontos');
    }
  }

  @override
  Future<void> convertPoints(String userId, int points) async {
    try {
      final user = _findUser(userId);
      if (user.points < points) {
        throw const InsufficientPointsException();
      }
      final converted = _convertPoints(points);
      final updated = user.copyWith(points: user.points - points);
      database.updateUser(updated);
      database.addPointsEntry(
        PointsEntry(
          id: idGenerator.generate(),
          userId: userId,
          points: -points,
          source: 'Conversão em saldo',
          createdAt: DateTime.now(),
        ),
      );
      database.addTransaction(
        WalletTransaction(
          id: idGenerator.generate(),
          userId: userId,
          type: WalletTransactionType.pointsConversion,
          amount: converted,
          description: 'Conversão de pontos',
          createdAt: DateTime.now(),
        ),
      );
    } on AppException {
      rethrow;
    } catch (error) {
      logger.error('Falha ao converter pontos');
      throw const AppException('Não foi possível converter pontos');
    }
  }

  @override
  Future<void> requestWithdrawal(String userId, double amount) async {
    try {
      if (amount < AppConstants.minWithdrawal) {
        throw const WithdrawalBelowMinimumException();
      }
      final balance = await fetchBalance(userId);
      if (balance < amount) {
        throw const InsufficientBalanceException();
      }
      database.addTransaction(
        WalletTransaction(
          id: idGenerator.generate(),
          userId: userId,
          type: WalletTransactionType.withdrawal,
          amount: -amount,
          description: 'Solicitação de saque',
          createdAt: DateTime.now(),
        ),
      );
    } on AppException {
      rethrow;
    } catch (error) {
      logger.error('Falha ao solicitar saque');
      throw const AppException('Não foi possível solicitar saque');
    }
  }

  double _sumTransactions(List<WalletTransaction> transactions) {
    return transactions.fold(0, (total, item) => total + item.amount);
  }

  double _convertPoints(int points) {
    final base = AppConstants.pointsToMoneyBase;
    final value = AppConstants.pointsToMoneyValue;
    return (points / base) * value;
  }

  AppUser _findUser(String userId) {
    return database.users.firstWhere(
      (item) => item.id == userId,
      orElse: () => throw const UserNotFoundException(),
    );
  }
}
