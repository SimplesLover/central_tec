import 'package:dio/dio.dart';

import '../../../../globals/services/in_memory_database.dart';
import '../../../core/domain/entities/product.dart';

class ProductLocalDataSource {
  final InMemoryDatabase database;
  final Dio httpClient;

  const ProductLocalDataSource({
    required this.database,
    required this.httpClient,
  });

  Future<List<Product>> fetchProducts() async {
    final response = Response<List<Product>>(
      requestOptions: RequestOptions(path: '/products'),
      data: database.products.toList(),
    );
    return response.data ?? [];
  }

  Future<List<String>> fetchCategories() async {
    final categories = database.products.map((item) => item.category).toSet();
    return categories.toList()..sort();
  }

  Future<Product?> fetchById(String id) async {
    final products = database.products;
    final match = products.where((item) => item.id == id).toList();
    return match.isEmpty ? null : match.first;
  }
}
