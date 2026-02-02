import '../../../core/domain/entities/order.dart';
import '../entities/order_inputs.dart';

abstract class OrderRepository {
  Future<Order> placeOrder(PlaceOrderInput input);

  Future<List<Order>> fetchOrders(String userId);
}
