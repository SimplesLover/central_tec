// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:central_tec/globals/constants/app_constants.dart';
import 'package:central_tec/modules/auth/domain/entities/auth_inputs.dart';
import 'package:central_tec/modules/auth/domain/repositories/auth_repository.dart';
import 'package:central_tec/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:central_tec/modules/auth/presentation/pages/login_page.dart';
import 'package:central_tec/modules/core/domain/entities/app_user.dart';

void main() {
  testWidgets('Login page renders core actions', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthController(repository: _FakeAuthRepository()),
        child: const MaterialApp(
          home: LoginPage(),
        ),
      ),
    );

    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Criar conta'), findsOneWidget);
  });
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<AppUser?> currentUser() async => null;

  @override
  Future<AppUser> login(LoginInput input) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {}

  @override
  Future<void> requestPasswordReset(String email) async {}

  @override
  Future<AppUser> register(RegisterInput input) {
    throw UnimplementedError();
  }

  @override
  Future<AppUser> updateProfile(ProfileUpdateInput input) {
    throw UnimplementedError();
  }
}
