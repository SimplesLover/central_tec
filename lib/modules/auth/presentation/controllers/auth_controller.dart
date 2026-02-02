import 'package:flutter/material.dart';

import '../../../../globals/utils/app_exceptions.dart';
import '../../domain/entities/auth_inputs.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../core/domain/entities/app_user.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository repository;

  AppUser? user;
  String? errorMessage;
  bool isLoading = false;

  AuthController({required this.repository});

  Future<void> loadSession() async {
    await _handle(() async {
      user = await repository.currentUser();
    });
  }

  Future<void> register(RegisterInput input) async {
    await _handle(() async {
      user = await repository.register(input);
    });
  }

  Future<void> login(LoginInput input) async {
    await _handle(() async {
      user = await repository.login(input);
    });
  }

  Future<void> logout() async {
    await _handle(() async {
      await repository.logout();
      user = null;
    });
  }

  Future<void> requestPasswordReset(String email) async {
    await _handle(() async {
      await repository.requestPasswordReset(email);
    });
  }

  Future<void> updateProfile(ProfileUpdateInput input) async {
    await _handle(() async {
      user = await repository.updateProfile(input);
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
