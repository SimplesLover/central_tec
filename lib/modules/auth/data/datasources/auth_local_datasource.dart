import '../../../../globals/constants/app_constants.dart';
import '../../../../globals/services/in_memory_database.dart';
import '../../../../globals/services/session_storage.dart';
import '../../../../globals/utils/app_exceptions.dart';
import '../../../../globals/utils/id_generator.dart';
import '../../../../globals/utils/token_generator.dart';
import '../../../core/domain/entities/app_user.dart';
import '../../../core/domain/entities/notification_item.dart';
import '../../../core/domain/entities/points_entry.dart';

class AuthLocalDataSource {
  final InMemoryDatabase database;
  final SessionStorage sessionStorage;
  final IdGenerator idGenerator;
  final TokenGenerator tokenGenerator;

  const AuthLocalDataSource({
    required this.database,
    required this.sessionStorage,
    required this.idGenerator,
    required this.tokenGenerator,
  });

  Future<AppUser> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    String? referralCode,
  }) async {
    _ensureEmailUnique(email);
    final referrer = _findReferrer(referralCode);
    final user = database.addUser(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
      referredByCode: referralCode,
    );
    _applyReferralRewards(user, referrer);
    await sessionStorage.saveSession(user.id, tokenGenerator.generate());
    return user;
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final user = _findUserByEmail(email);
    final hashed = database.hashPassword(password);
    if (user.passwordHash != hashed) {
      throw const InvalidCredentialsException();
    }
    await sessionStorage.saveSession(user.id, tokenGenerator.generate());
    return user;
  }

  Future<void> logout() async {
    await sessionStorage.clear();
  }

  Future<void> requestPasswordReset(String email) async {
    final user = _findUserByEmail(email);
    _addNotification(
      user.id,
      'Recuperação de senha',
      'Solicitação recebida. Verifique seu email.',
    );
  }

  Future<AppUser?> currentUser() async {
    final userId = await sessionStorage.getUserId();
    if (userId == null) {
      return null;
    }
    return database.users.firstWhere(
      (item) => item.id == userId,
      orElse: () => throw const UserNotFoundException(),
    );
  }

  Future<AppUser> updateProfile({
    required String userId,
    required String fullName,
    required String phone,
  }) async {
    final user = _findUserById(userId);
    final updated = user.copyWith(fullName: fullName, phone: phone);
    database.updateUser(updated);
    return updated;
  }

  void _ensureEmailUnique(String email) {
    final exists = database.users.any((user) => user.email == email);
    if (exists) {
      throw const EmailAlreadyUsedException();
    }
  }

  AppUser? _findReferrer(String? referralCode) {
    if (referralCode == null || referralCode.isEmpty) {
      return null;
    }
    final referrer = database.users
        .where((user) => user.referralCode == referralCode)
        .toList();
    if (referrer.isEmpty) {
      throw const ReferralNotFoundException();
    }
    return referrer.first;
  }

  AppUser _findUserByEmail(String email) {
    return database.users.firstWhere(
      (item) => item.email == email,
      orElse: () => throw const UserNotFoundException(),
    );
  }

  AppUser _findUserById(String userId) {
    return database.users.firstWhere(
      (item) => item.id == userId,
      orElse: () => throw const UserNotFoundException(),
    );
  }

  void _applyReferralRewards(AppUser user, AppUser? referrer) {
    _addPoints(
      userId: user.id,
      points: AppConstants.referredBonusPoints,
      source: 'Bônus por cadastro',
    );
    if (referrer != null) {
      database.addReferral(referrerId: referrer.id, referredUserId: user.id);
      _addPoints(
        userId: referrer.id,
        points: AppConstants.referralPoints,
        source: 'Indicação de novo cadastro',
      );
      _addNotification(
        referrer.id,
        'Nova indicação',
        '${user.fullName} entrou com seu código.',
      );
    }
    _addNotification(
      user.id,
      'Cadastro concluído',
      'Seu bônus de pontos já está disponível.',
    );
  }

  void _addPoints({
    required String userId,
    required int points,
    required String source,
  }) {
    final user = _findUserById(userId);
    final updated = user.copyWith(points: user.points + points);
    database.updateUser(updated);
    database.addPointsEntry(
      PointsEntry(
        id: idGenerator.generate(),
        userId: userId,
        points: points,
        source: source,
        createdAt: DateTime.now(),
      ),
    );
  }

  void _addNotification(String userId, String title, String body) {
    database.addNotification(
      NotificationItem(
        id: idGenerator.generate(),
        userId: userId,
        title: title,
        body: body,
        isRead: false,
        createdAt: DateTime.now(),
      ),
    );
  }
}
