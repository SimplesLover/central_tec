import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../modules/auth/data/datasources/auth_local_datasource.dart';
import '../../modules/auth/data/repositories/auth_repository_impl.dart';
import '../../modules/auth/domain/repositories/auth_repository.dart';
import '../../modules/cart/data/datasources/cart_local_datasource.dart';
import '../../modules/cart/data/repositories/cart_repository_impl.dart';
import '../../modules/cart/domain/repositories/cart_repository.dart';
import '../../modules/dashboard/data/datasources/dashboard_local_datasource.dart';
import '../../modules/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../modules/dashboard/domain/repositories/dashboard_repository.dart';
import '../../modules/network/data/datasources/network_local_datasource.dart';
import '../../modules/network/data/repositories/network_repository_impl.dart';
import '../../modules/network/domain/repositories/network_repository.dart';
import '../../modules/notifications/data/datasources/notification_local_datasource.dart';
import '../../modules/notifications/data/repositories/notification_repository_impl.dart';
import '../../modules/notifications/domain/repositories/notification_repository.dart';
import '../../modules/orders/data/datasources/order_local_datasource.dart';
import '../../modules/orders/data/repositories/order_repository_impl.dart';
import '../../modules/orders/domain/repositories/order_repository.dart';
import '../../modules/products/data/datasources/product_local_datasource.dart';
import '../../modules/products/data/repositories/product_repository_impl.dart';
import '../../modules/products/domain/repositories/product_repository.dart';
import '../../modules/wallet/data/datasources/wallet_local_datasource.dart';
import '../../modules/wallet/data/repositories/wallet_repository_impl.dart';
import '../../modules/wallet/domain/repositories/wallet_repository.dart';
import '../utils/id_generator.dart';
import '../utils/password_hasher.dart';
import '../utils/referral_code_generator.dart';
import '../utils/token_generator.dart';
import 'app_logger.dart';
import 'commission_service.dart';
import 'in_memory_database.dart';
import 'session_storage.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  serviceLocator.registerLazySingleton<AppLogger>(AppLogger.new);
  serviceLocator.registerLazySingleton<IdGenerator>(IdGenerator.new);
  serviceLocator.registerLazySingleton<ReferralCodeGenerator>(
    ReferralCodeGenerator.new,
  );
  serviceLocator.registerLazySingleton<PasswordHasher>(PasswordHasher.new);
  serviceLocator.registerLazySingleton<TokenGenerator>(TokenGenerator.new);
  serviceLocator.registerLazySingleton<Dio>(Dio.new);
  serviceLocator.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  serviceLocator.registerLazySingleton<SessionStorage>(
    () => SessionStorage(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<CommissionService>(
    CommissionService.new,
  );
  serviceLocator.registerLazySingleton<InMemoryDatabase>(
    () => InMemoryDatabase(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
    ),
  );

  _registerDataSources();
  _registerRepositories();
}

void _registerDataSources() {
  serviceLocator.registerLazySingleton<DashboardLocalDataSource>(
    () => DashboardLocalDataSource(database: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(
      database: serviceLocator(),
      sessionStorage: serviceLocator(),
      idGenerator: serviceLocator(),
      tokenGenerator: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSource(
      database: serviceLocator(),
      httpClient: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSource(database: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<OrderLocalDataSource>(
    () => OrderLocalDataSource(database: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<WalletLocalDataSource>(
    () => WalletLocalDataSource(database: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<NetworkLocalDataSource>(
    () => NetworkLocalDataSource(database: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<NotificationLocalDataSource>(
    () => NotificationLocalDataSource(database: serviceLocator()),
  );
}

void _registerRepositories() {
  serviceLocator.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      dataSource: serviceLocator(),
      networkRepository: serviceLocator(),
      logger: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      dataSource: serviceLocator(),
      logger: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      dataSource: serviceLocator(),
      logger: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(
      dataSource: serviceLocator(),
      logger: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(
      dataSource: serviceLocator(),
      database: serviceLocator(),
      idGenerator: serviceLocator(),
      commissionService: serviceLocator(),
      logger: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(
      dataSource: serviceLocator(),
      database: serviceLocator(),
      idGenerator: serviceLocator(),
      logger: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<NetworkRepository>(
    () => NetworkRepositoryImpl(
      dataSource: serviceLocator(),
      logger: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      dataSource: serviceLocator(),
      logger: serviceLocator(),
    ),
  );
}
