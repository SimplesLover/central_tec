import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../globals/constants/app_constants.dart';
import '../../../../globals/utils/validators.dart';
import '../../domain/entities/auth_inputs.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static const double _mobileBreakpoint = 600;
  static const double _maxContentWidth = 520;
  static const double _pagePadding = 24;
  static const double _sectionSpacing = 24;
  static const double _fieldSpacing = 16;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _referralController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _referralController.dispose();
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
          _nameField(),
          const SizedBox(height: _fieldSpacing),
          _emailField(),
          const SizedBox(height: _fieldSpacing),
          _phoneField(),
          const SizedBox(height: _fieldSpacing),
          _passwordField(),
          const SizedBox(height: _fieldSpacing),
          _referralField(),
          const SizedBox(height: _sectionSpacing),
          _submitButton(),
          const SizedBox(height: _fieldSpacing),
          _loginButton(context),
        ],
      ),
    );
  }

  Widget _title(BuildContext context) {
    return Text(
      'Criar conta',
      style: Theme.of(context).textTheme.headlineSmall,
      textAlign: TextAlign.center,
    );
  }

  Widget _nameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(labelText: 'Nome completo'),
      textInputAction: TextInputAction.next,
      validator: Validators.requiredText,
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

  Widget _phoneField() {
    return TextFormField(
      controller: _phoneController,
      decoration: const InputDecoration(labelText: 'Telefone'),
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      validator: Validators.requiredText,
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: const InputDecoration(labelText: 'Senha'),
      obscureText: true,
      textInputAction: TextInputAction.next,
      validator: (value) => Validators.minLength(value, AppConstants.minPasswordLength),
    );
  }

  Widget _referralField() {
    return TextFormField(
      controller: _referralController,
      decoration: const InputDecoration(labelText: 'Código de indicação (opcional)'),
      textInputAction: TextInputAction.done,
    );
  }

  Widget _submitButton() {
    return Consumer<AuthController>(
      builder: (context, controller, child) {
        return ElevatedButton(
          onPressed: controller.isLoading ? null : _submit,
          child: controller.isLoading
              ? const CircularProgressIndicator()
              : const Text('Cadastrar'),
        );
      },
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final controller = context.read<AuthController>();
    await controller.register(
      RegisterInput(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
        referralCode: _referralController.text.trim().isEmpty
            ? null
            : _referralController.text.trim(),
      ),
    );
    if (!mounted) {
      return;
    }
    _showMessage(context, controller.errorMessage);
  }

  Widget _loginButton(BuildContext context) {
    return TextButton(
      onPressed: () => context.go('/login'),
      child: const Text('Já tenho conta'),
    );
  }

  void _showMessage(BuildContext context, String? message) {
    if (message == null) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
