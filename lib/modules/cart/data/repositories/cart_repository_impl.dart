import '../../../../globals/services/app_logger.dart';
import '../../../../globals/utils/app_exceptions.dart';
import '../../../core/domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_datasource.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource dataSource;
  final AppLogger logger;

  const CartRepositoryImpl({
    required this.dataSource,
    required this.logger,
  });

  @override
  Future<List<CartItem>> fetchItems(String userId) async {
    try {
      return await dataSource.fetchItems(userId);
    } catch (error) {
      logger.error('Falha ao carregar carrinho');
      throw const AppException('Não foi possível carregar o carrinho');
    }
  }

  @override
  Future<void> addItem(String userId, CartItem item) async {
    try {
      final items = await dataSource.fetchItems(userId);
      final updated = _mergeItem(items, item);
      await dataSource.saveItems(userId, updated);
    } catch (error) {
      logger.error('Falha ao adicionar item');
      throw const AppException('Não foi possível adicionar item');
    }
  }

  @override
  Future<void> updateItem(String userId, CartItem item) async {
    try {
      final items = await dataSource.fetchItems(userId);
      final updated = _replaceItem(items, item);
      await dataSource.saveItems(userId, updated);
    } catch (error) {
      logger.error('Falha ao atualizar item');
      throw const AppException('Não foi possível atualizar item');
    }
  }

  @override
  Future<void> removeItem(String userId, String productId) async {
    try {
      final items = await dataSource.fetchItems(userId);
      final updated = items.where((item) => item.product.id != productId).toList();
      await dataSource.saveItems(userId, updated);
    } catch (error) {
      logger.error('Falha ao remover item');
      throw const AppException('Não foi possível remover item');
    }
  }

  @override
  Future<void> clearCart(String userId) async {
    try {
      await dataSource.saveItems(userId, []);
    } catch (error) {
      logger.error('Falha ao limpar carrinho');
      throw const AppException('Não foi possível limpar o carrinho');
    }
  }

  List<CartItem> _mergeItem(List<CartItem> items, CartItem item) {
    final updated = List<CartItem>.from(items);
    final index = updated.indexWhere((value) => value.product.id == item.product.id);
    if (index >= 0) {
      final current = updated[index];
      updated[index] = current.copyWith(quantity: current.quantity + item.quantity);
      return updated;
    }
    updated.add(item);
    return updated;
  }

  List<CartItem> _replaceItem(List<CartItem> items, CartItem item) {
    final updated = List<CartItem>.from(items);
    final index = updated.indexWhere((value) => value.product.id == item.product.id);
    if (index >= 0) {
      updated[index] = item;
    }
    return updated;
  }
}
