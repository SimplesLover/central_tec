import '../../../../globals/services/in_memory_database.dart';
import '../../../core/domain/entities/cart_item.dart';

class CartLocalDataSource {
  final InMemoryDatabase database;

  const CartLocalDataSource({required this.database});

  Future<List<CartItem>> fetchItems(String userId) async {
    return database.cartFor(userId);
  }

  Future<void> saveItems(String userId, List<CartItem> items) async {
    database.saveCart(userId, items);
  }
}
