import '../../../../globals/services/in_memory_database.dart';
import '../../../core/domain/entities/order.dart';

class OrderLocalDataSource {
  final InMemoryDatabase database;

  const OrderLocalDataSource({required this.database});

  Future<void> saveOrder(String userId, Order order) async {
    database.addOrder(userId, order);
  }

  Future<List<Order>> fetchOrders(String userId) async {
    return database.ordersFor(userId);
  }
}
