import 'package:flutter/material.dart';

import '../../../../globals/utils/app_exceptions.dart';
import '../../domain/entities/order_inputs.dart';
import '../../domain/repositories/order_repository.dart';
import '../../../core/domain/entities/order.dart';

class OrderController extends ChangeNotifier {
  final OrderRepository repository;

  List<Order> orders = [];
  String? errorMessage;
  bool isLoading = false;

  OrderController({required this.repository});

  Future<void> load(String userId) async {
    await _handle(() async {
      orders = await repository.fetchOrders(userId);
    });
  }

  Future<void> placeOrder(PlaceOrderInput input) async {
    await _handle(() async {
      final order = await repository.placeOrder(input);
      orders = [...orders, order];
    });
  }

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
