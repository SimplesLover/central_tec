import '../../../core/domain/entities/order.dart';

class PlaceOrderInput {
  final String userId;
  final List<OrderItem> items;
  final double subtotal;
  final double discount;
  final double total;
  final double cashback;
  final PaymentMethod paymentMethod;

  const PlaceOrderInput({
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.cashback,
    required this.paymentMethod,
  });
}
