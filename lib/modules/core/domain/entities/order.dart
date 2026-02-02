import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

enum PaymentMethod { pix, card, boleto }

@freezed
abstract class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String productId,
    required String name,
    required double price,
    required int quantity,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
}

@freezed
abstract class Order with _$Order {
  const factory Order({
    required String id,
    required String userId,
    required List<OrderItem> items,
    required double subtotal,
    required double discount,
    required double total,
    required double cashback,
    required PaymentMethod paymentMethod,
    required DateTime createdAt,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
