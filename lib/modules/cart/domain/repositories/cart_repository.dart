import '../../../core/domain/entities/cart_item.dart';

abstract class CartRepository {
  Future<List<CartItem>> fetchItems(String userId);
  Future<void> addItem(String userId, CartItem item);
  Future<void> updateItem(String userId, CartItem item);
  Future<void> removeItem(String userId, String productId);
  Future<void> clearCart(String userId);
}
