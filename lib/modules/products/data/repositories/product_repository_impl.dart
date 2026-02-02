import '../../../../globals/services/app_logger.dart';
import '../../../../globals/utils/app_exceptions.dart';
import '../../../core/domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource dataSource;
  final AppLogger logger;

  const ProductRepositoryImpl({
    required this.dataSource,
    required this.logger,
  });

  @override
  Future<List<Product>> fetchProducts() async {
    try {
      return await dataSource.fetchProducts();
    } catch (error) {
      logger.error('Falha ao buscar produtos');
      throw const AppException('Não foi possível carregar os produtos');
    }
  }

  @override
  Future<List<String>> fetchCategories() async {
    try {
      return await dataSource.fetchCategories();
    } catch (error) {
      logger.error('Falha ao buscar categorias');
      throw const AppException('Não foi possível carregar as categorias');
    }
  }

  @override
  Future<Product?> fetchById(String id) async {
    try {
      return await dataSource.fetchById(id);
    } catch (error) {
      logger.error('Falha ao buscar produto');
      throw const AppException('Não foi possível carregar o produto');
    }
  }
}
