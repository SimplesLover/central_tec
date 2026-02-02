import 'dart:collection';

import '../../modules/core/domain/entities/app_user.dart';
import '../../modules/core/domain/entities/cart_item.dart';
import '../../modules/core/domain/entities/notification_item.dart';
import '../../modules/core/domain/entities/order.dart';
import '../../modules/core/domain/entities/points_entry.dart';
import '../../modules/core/domain/entities/product.dart';
import '../../modules/core/domain/entities/referral_entry.dart';
import '../../modules/core/domain/entities/wallet_transaction.dart';
import '../../modules/products/data/datasources/product_seed_data.dart';
import '../constants/app_constants.dart';
import '../utils/id_generator.dart';
import '../utils/password_hasher.dart';
import '../utils/referral_code_generator.dart';

class InMemoryDatabase {
  final IdGenerator _idGenerator;
  final ReferralCodeGenerator _codeGenerator;
  final PasswordHasher _passwordHasher;
  final List<AppUser> _users = [];
  final List<Product> _products = [];
  final List<ReferralEntry> _referrals = [];
  final Map<String, List<CartItem>> _carts = {};
  final Map<String, List<Order>> _orders = {};
  final Map<String, List<PointsEntry>> _points = {};
  final Map<String, List<WalletTransaction>> _transactions = {};
  final Map<String, List<NotificationItem>> _notifications = {};

  InMemoryDatabase(
    this._idGenerator,
    this._codeGenerator,
    this._passwordHasher,
  ) {
    _seedProducts();
    _seedUser();
  }

  UnmodifiableListView<AppUser> get users => UnmodifiableListView(_users);
  UnmodifiableListView<Product> get products => UnmodifiableListView(_products);
  UnmodifiableListView<ReferralEntry> get referrals =>
      UnmodifiableListView(_referrals);

  List<CartItem> cartFor(String userId) => _carts[userId] ?? [];
  List<Order> ordersFor(String userId) => _orders[userId] ?? [];
  List<PointsEntry> pointsFor(String userId) => _points[userId] ?? [];
  List<WalletTransaction> transactionsFor(String userId) =>
      _transactions[userId] ?? [];
  List<NotificationItem> notificationsFor(String userId) =>
      _notifications[userId] ?? [];

  AppUser addUser({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    String? referredByCode,
  }) {
    final user = _buildUser(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
      referredByCode: referredByCode,
    );
    _users.add(user);
    _carts[user.id] = [];
    _orders[user.id] = [];
    _points[user.id] = [];
    _transactions[user.id] = [];
    _notifications[user.id] = [];
    return user;
  }

  void addReferral({
    required String referrerId,
    required String referredUserId,
  }) {
    final entry = ReferralEntry(
      id: _idGenerator.generate(),
      referrerId: referrerId,
      referredUserId: referredUserId,
      createdAt: DateTime.now(),
    );
    _referrals.add(entry);
  }

  void addPointsEntry(PointsEntry entry) {
    final list = _points.putIfAbsent(entry.userId, () => []);
    list.add(entry);
  }

  void addTransaction(WalletTransaction transaction) {
    final list = _transactions.putIfAbsent(transaction.userId, () => []);
    list.add(transaction);
  }

  void addNotification(NotificationItem item) {
    final list = _notifications.putIfAbsent(item.userId, () => []);
    list.add(item);
  }

  void saveNotifications(String userId, List<NotificationItem> items) {
    _notifications[userId] = List<NotificationItem>.from(items);
  }

  void saveCart(String userId, List<CartItem> items) {
    _carts[userId] = List<CartItem>.from(items);
  }

  void addOrder(String userId, Order order) {
    final list = _orders.putIfAbsent(userId, () => []);
    list.add(order);
  }

  void updateUser(AppUser user) {
    final index = _users.indexWhere((item) => item.id == user.id);
    if (index >= 0) {
      _users[index] = user;
    }
  }

  String generateReferralCode() {
    final code = _codeGenerator.generate();
    final exists = _users.any((user) => user.referralCode == code);
    if (exists) {
      return generateReferralCode();
    }
    return code;
  }

  String hashPassword(String value) => _passwordHasher.hash(value);

  AppUser _buildUser({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    String? referredByCode,
  }) {
    return AppUser(
      id: _idGenerator.generate(),
      fullName: fullName,
      email: email,
      phone: phone,
      passwordHash: _passwordHasher.hash(password),
      referralCode: generateReferralCode(),
      referredByCode: referredByCode,
      isActive: true,
      points: 0,
      createdAt: DateTime.now(),
    );
  }

  void _seedProducts() {
    final items = productSeedData.map(_mapProduct).toList();
    _products.addAll(items);
  }

  Product _mapProduct(Map<String, dynamic> data) {
    return Product(
      id: data['id'] as String,
      name: data['name'] as String,
      description: data['description'] as String,
      price: (data['price'] as num).toDouble(),
      imageUrl: data['imageUrl'] as String,
      category: data['category'] as String,
    );
  }

  void _seedUser() {
    final user = addUser(
      fullName: 'Cliente Centraltec',
      email: 'cliente@centraltec.com.br',
      phone: '(71) 99999-0000',
      password: '123456',
      referredByCode: null,
    );
    addPointsEntry(
      PointsEntry(
        id: _idGenerator.generate(),
        userId: user.id,
        points: AppConstants.referredBonusPoints,
        source: 'Bônus de boas-vindas',
        createdAt: DateTime.now(),
      ),
    );
  }
}
