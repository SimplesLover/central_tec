import '../../../../globals/services/app_logger.dart';
import '../../../../globals/utils/app_exceptions.dart';
import '../../../core/domain/entities/app_user.dart';
import '../../domain/entities/auth_inputs.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource dataSource;
  final AppLogger logger;

  const AuthRepositoryImpl({
    required this.dataSource,
    required this.logger,
  });

  @override
  Future<AppUser> register(RegisterInput input) async {
    try {
      return await dataSource.register(
        fullName: input.fullName,
        email: input.email,
        phone: input.phone,
        password: input.password,
        referralCode: input.referralCode,
      );
    } on AppException {
      rethrow;
    } catch (error) {
      logger.error('Falha no cadastro');
      throw const AppException('Não foi possível concluir o cadastro');
    }
  }

  @override
  Future<AppUser> login(LoginInput input) async {
    try {
      return await dataSource.login(
        email: input.email,
        password: input.password,
      );
    } on AppException {
      rethrow;
    } catch (error) {
      logger.error('Falha no login');
      throw const AppException('Não foi possível fazer login');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dataSource.logout();
    } catch (error) {
      logger.error('Falha ao sair');
      throw const AppException('Não foi possível sair');
    }
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    try {
      await dataSource.requestPasswordReset(email);
    } on AppException {
      rethrow;
    } catch (error) {
      logger.error('Falha ao recuperar senha');
      throw const AppException('Não foi possível recuperar a senha');
    }
  }

  @override
  Future<AppUser?> currentUser() async {
    try {
      return await dataSource.currentUser();
    } on AppException {
      rethrow;
    } catch (error) {
      logger.error('Falha ao recuperar usuário');
      throw const AppException('Não foi possível carregar o usuário');
    }
  }

  @override
  Future<AppUser> updateProfile(ProfileUpdateInput input) async {
    try {
      return await dataSource.updateProfile(
        userId: input.userId,
        fullName: input.fullName,
        phone: input.phone,
      );
    } on AppException {
      rethrow;
    } catch (error) {
      logger.error('Falha ao atualizar perfil');
      throw const AppException('Não foi possível atualizar o perfil');
    }
  }
}
