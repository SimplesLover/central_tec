import '../../../core/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchProducts();
  Future<List<String>> fetchCategories();
  Future<Product?> fetchById(String id);
}
