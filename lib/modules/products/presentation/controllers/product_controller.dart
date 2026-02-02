import 'package:flutter/material.dart';

import '../../../../globals/utils/app_exceptions.dart';
import '../../../core/domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductController extends ChangeNotifier {
  final ProductRepository repository;

  List<Product> products = [];
  List<String> categories = [];
  String? selectedCategory;
  String query = '';
  double? maxPrice;
  String? errorMessage;
  bool isLoading = false;

  ProductController({required this.repository});

  Future<void> load() async {
    await _handle(() async {
      categories = await repository.fetchCategories();
      products = await repository.fetchProducts();
    });
  }

  void updateQuery(String value) {
    query = value;
    notifyListeners();
  }

  void updateCategory(String? value) {
    selectedCategory = value;
    notifyListeners();
  }

  void updateMaxPrice(double? value) {
    maxPrice = value;
    notifyListeners();
  }

  List<Product> get filtered {
    final lower = query.toLowerCase();
    return products.where((product) {
      final matchesCategory = selectedCategory == null ||
          product.category == selectedCategory;
      final matchesPrice = maxPrice == null || product.price <= maxPrice!;
      final matchesQuery =
          lower.isEmpty || product.name.toLowerCase().contains(lower);
      return matchesCategory && matchesQuery && matchesPrice;
    }).toList();
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
