import '../../../core/domain/entities/app_user.dart';
import '../entities/auth_inputs.dart';

abstract class AuthRepository {
  Future<AppUser> register(RegisterInput input);

  Future<AppUser> login(LoginInput input);

  Future<void> logout();

  Future<void> requestPasswordReset(String email);

  Future<AppUser?> currentUser();

  Future<AppUser> updateProfile(ProfileUpdateInput input);
}
