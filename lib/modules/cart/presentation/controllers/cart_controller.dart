import 'package:flutter/material.dart';

import '../../../../globals/utils/app_exceptions.dart';
import '../../../core/domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';

class CartController extends ChangeNotifier {
  final CartRepository repository;

  List<CartItem> items = [];
  String? errorMessage;
  bool isLoading = false;

  CartController({required this.repository});

  Future<void> load(String userId) async {
    await _handle(() async {
      items = await repository.fetchItems(userId);
    });
  }

  Future<void> addItem(String userId, CartItem item) async {
    await _handle(() async {
      await repository.addItem(userId, item);
      items = await repository.fetchItems(userId);
    });
  }

  Future<void> updateItem(String userId, CartItem item) async {
    await _handle(() async {
      await repository.updateItem(userId, item);
      items = await repository.fetchItems(userId);
    });
  }

  Future<void> removeItem(String userId, String productId) async {
    await _handle(() async {
      await repository.removeItem(userId, productId);
      items = await repository.fetchItems(userId);
    });
  }

  Future<void> clear(String userId) async {
    await _handle(() async {
      await repository.clearCart(userId);
      items = await repository.fetchItems(userId);
    });
  }

  double get subtotal => items.fold(
        0,
        (value, item) => value + (item.product.price * item.quantity),
      );

  Future<void> _handle(Future<void> Function() action) async {
    _setLoading(true);
    try {
      await action();
      errorMessage = null;
    } on AppException catch (error) {
      errorMessage = error.message;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
