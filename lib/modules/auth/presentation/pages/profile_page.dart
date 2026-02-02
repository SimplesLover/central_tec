import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../globals/utils/validators.dart';
import '../../domain/entities/auth_inputs.dart';
import '../controllers/auth_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, controller, child) {
        final user = controller.user;
        if (user == null) {
          return const Center(child: Text('Faça login para ver o perfil'));
        }
        if (!_initialized) {
          _nameController.text = user.fullName;
          _phoneController.text = user.phone;
          _initialized = true;
        }
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('Perfil', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: ${user.email}'),
                    const SizedBox(height: 8),
                    Text('Código de indicação: ${user.referralCode}'),
                    const SizedBox(height: 8),
                    Text('Pontos: ${user.points}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Nome'),
                        validator: Validators.requiredText,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(labelText: 'Telefone'),
                        validator: Validators.requiredText,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: controller.isLoading ? null : () => _save(controller),
                        child: const Text('Salvar alterações'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: controller.isLoading ? null : controller.logout,
                        child: const Text('Sair'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _save(AuthController controller) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final user = controller.user;
    if (user == null) {
      return;
    }
    await controller.updateProfile(
      ProfileUpdateInput(
        userId: user.id,
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
      ),
    );
  }
}
