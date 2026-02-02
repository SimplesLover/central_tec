import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../globals/constants/app_constants.dart';
import '../../../../globals/utils/validators.dart';
import '../../domain/entities/auth_inputs.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const double _mobileBreakpoint = 600;
  static const double _maxContentWidth = 420;
  static const double _pagePadding = 24;
  static const double _sectionSpacing = 24;
  static const double _fieldSpacing = 16;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _content(context));
  }

  Widget _content(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth =
            constraints.maxWidth < _mobileBreakpoint ? double.infinity : _maxContentWidth;
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: const EdgeInsets.all(_pagePadding),
              child: _form(context),
            ),
          ),
        );
      },
    );
  }

  Widget _form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _title(context),
          const SizedBox(height: _sectionSpacing),
          _emailField(),
          const SizedBox(height: _fieldSpacing),
          _passwordField(),
          const SizedBox(height: _sectionSpacing),
          _submitButton(),
          const SizedBox(height: _fieldSpacing),
          _resetButton(context),
          _registerButton(context),
        ],
      ),
    );
  }

  Widget _title(BuildContext context) {
    return Text(
      AppConstants.appName,
      style: Theme.of(context).textTheme.headlineSmall,
      textAlign: TextAlign.center,
    );
  }

  Widget _emailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: Validators.email,
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: const InputDecoration(labelText: 'Senha'),
      obscureText: true,
      textInputAction: TextInputAction.done,
      validator: (value) => Validators.minLength(value, AppConstants.minPasswordLength),
    );
  }

  Widget _submitButton() {
    return Consumer<AuthController>(
      builder: (context, controller, child) {
        return ElevatedButton(
          onPressed: controller.isLoading ? null : _submit,
          child: controller.isLoading
              ? const CircularProgressIndicator()
              : const Text('Entrar'),
        );
      },
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final controller = context.read<AuthController>();
    await controller.login(
      LoginInput(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
    if (!mounted) {
      return;
    }
    _showMessage(context, controller.errorMessage);
  }

  Future<void> _requestReset() async {
    final validation = Validators.email(_emailController.text.trim());
    if (validation != null) {
      _showMessage(context, validation);
      return;
    }
    final controller = context.read<AuthController>();
    await controller.requestPasswordReset(_emailController.text.trim());
    if (!mounted) {
      return;
    }
    _showMessage(context, controller.errorMessage ?? 'Email enviado.');
  }

  Widget _resetButton(BuildContext context) {
    return TextButton(
      onPressed: _requestReset,
      child: const Text('Esqueci minha senha'),
    );
  }

  Widget _registerButton(BuildContext context) {
    return TextButton(
      onPressed: () => context.go('/register'),
      child: const Text('Criar conta'),
    );
  }

  void _showMessage(BuildContext context, String? message) {
    if (message == null) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
