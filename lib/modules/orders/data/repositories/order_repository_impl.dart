import '../../../../globals/constants/app_constants.dart';
import '../../../../globals/services/app_logger.dart';
import '../../../../globals/services/commission_service.dart';
import '../../../../globals/services/in_memory_database.dart';
import '../../../../globals/utils/app_exceptions.dart';
import '../../../../globals/utils/id_generator.dart';
import '../../domain/entities/order_inputs.dart';
import '../../domain/repositories/order_repository.dart';
import '../../../core/domain/entities/notification_item.dart';
import '../../../core/domain/entities/order.dart';
import '../../../core/domain/entities/app_user.dart';
import '../../../core/domain/entities/wallet_transaction.dart';
import '../datasources/order_local_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderLocalDataSource dataSource;
  final InMemoryDatabase database;
  final IdGenerator idGenerator;
  final CommissionService commissionService;
  final AppLogger logger;

  const OrderRepositoryImpl({
    required this.dataSource,
    required this.database,
    required this.idGenerator,
    required this.commissionService,
    required this.logger,
  });

  @override
  Future<Order> placeOrder(PlaceOrderInput input) async {
    try {
      final order = _buildOrder(input);
      await dataSource.saveOrder(input.userId, order);
      _applyCashback(input, order);
      _applyCommissions(input, order);
      _notifyPurchase(input.userId, order.total);
      return order;
    } catch (error) {
      logger.error('Falha ao finalizar pedido');
      throw const AppException('Não foi possível concluir o pedido');
    }
  }

  @override
  Future<List<Order>> fetchOrders(String userId) async {
    try {
      return await dataSource.fetchOrders(userId);
    } catch (error) {
      logger.error('Falha ao carregar pedidos');
      throw const AppException('Não foi possível carregar os pedidos');
    }
  }

  Order _buildOrder(PlaceOrderInput input) {
    return Order(
      id: idGenerator.generate(),
      userId: input.userId,
      items: input.items,
      subtotal: input.subtotal,
      discount: input.discount,
      total: input.total,
      cashback: input.cashback,
      paymentMethod: input.paymentMethod,
      createdAt: DateTime.now(),
    );
  }

  void _applyCashback(PlaceOrderInput input, Order order) {
    if (order.cashback <= 0) {
      return;
    }
    database.addTransaction(
      WalletTransaction(
        id: idGenerator.generate(),
        userId: input.userId,
        type: WalletTransactionType.cashback,
        amount: order.cashback,
        description: 'Cashback da compra',
        createdAt: DateTime.now(),
      ),
    );
  }

  void _applyCommissions(PlaceOrderInput input, Order order) {
    final uplines = _findUplines(input.userId);
    for (var index = 0; index < uplines.length; index += 1) {
      final userId = uplines[index];
      final amount = _commissionAmount(order.total, index);
      if (amount <= 0) {
        continue;
      }
      database.addTransaction(
        WalletTransaction(
          id: idGenerator.generate(),
          userId: userId,
          type: WalletTransactionType.commission,
          amount: amount,
          description: 'Comissão nível ${index + 1}',
          createdAt: DateTime.now(),
        ),
      );
      _addNotification(
        userId,
        'Comissão recebida',
        'Você recebeu R\$ ${amount.toStringAsFixed(2)}',
      );
    }
  }

  double _commissionAmount(double total, int index) {
    if (index == 0) {
      return commissionService.levelOne(total);
    }
    if (index == 1) {
      return commissionService.levelTwo(total);
    }
    if (index == 2) {
      return commissionService.levelThree(total);
    }
    return 0;
  }

  List<String> _findUplines(String userId) {
    final result = <String>[];
    var current = _findUserById(userId);
    while (current != null && result.length < AppConstants.maxNetworkLevels) {
      final referrer = _findReferrer(current);
      if (referrer == null) {
        break;
      }
      result.add(referrer.id);
      current = referrer;
    }
    return result;
  }

  AppUser? _findUserById(String userId) {
    final matches = database.users.where((user) => user.id == userId).toList();
    return matches.isEmpty ? null : matches.first;
  }

  AppUser? _findReferrer(AppUser user) {
    final code = user.referredByCode;
    if (code == null || code.isEmpty) {
      return null;
    }
    final matches =
        database.users.where((item) => item.referralCode == code).toList();
    return matches.isEmpty ? null : matches.first;
  }

  void _notifyPurchase(String userId, double total) {
    final uplines = _findUplines(userId);
    for (final uplineId in uplines) {
      _addNotification(
        uplineId,
        'Compra na rede',
        'Uma compra de R\$ ${total.toStringAsFixed(2)} foi realizada.',
      );
    }
  }

  void _addNotification(String userId, String title, String body) {
    database.addNotification(
      NotificationItem(
        id: idGenerator.generate(),
        userId: userId,
        title: title,
        body: body,
        isRead: false,
        createdAt: DateTime.now(),
      ),
    );
  }
}
