import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../globals/constants/app_constants.dart';
import '../../../../globals/utils/formatters.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/wallet_controller.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final TextEditingController _pointsController = TextEditingController();
  final TextEditingController _withdrawController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthController>().user;
      if (user != null) {
        context.read<WalletController>().load(user.id);
      }
    });
  }

  @override
  void dispose() {
    _pointsController.dispose();
    _withdrawController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthController, WalletController>(
      builder: (context, auth, controller, child) {
        final user = auth.user;
        if (user == null) {
          return const Center(child: Text('Faça login para ver sua carteira'));
        }
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('Carteira', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            _balanceCard(controller.balance),
            const SizedBox(height: 16),
            _pointsCard(user.points),
            const SizedBox(height: 16),
            _actions(user.id, user.points, controller),
            const SizedBox(height: 16),
            _transactions(controller),
          ],
        );
      },
    );
  }

  Widget _balanceCard(double balance) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.account_balance_wallet),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                Formatters.currency.format(balance),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pointsCard(int points) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pontos', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(points.toString(), style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Conversão: ${AppConstants.pointsToMoneyBase} pontos = ${Formatters.currency.format(AppConstants.pointsToMoneyValue)}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _actions(String userId, int points, WalletController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ações rápidas', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _pointsController,
              decoration: const InputDecoration(labelText: 'Pontos para converter'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _convert(userId, controller),
              child: const Text('Converter pontos'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _withdrawController,
              decoration:
                  const InputDecoration(labelText: 'Valor para saque (mínimo R\$ 50)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => _withdraw(userId, controller),
              child: const Text('Solicitar saque'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _transactions(WalletController controller) {
    if (controller.transactions.isEmpty) {
      return const Center(child: Text('Sem transações registradas'));
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Transações', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...controller.transactions.map(
              (item) => ListTile(
                title: Text(item.description),
                subtitle: Text(Formatters.dateTime.format(item.createdAt)),
                trailing: Text(Formatters.currency.format(item.amount)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _convert(String userId, WalletController controller) async {
    final value = int.tryParse(_pointsController.text);
    if (value == null || value <= 0) {
      return;
    }
    final authController = context.read<AuthController>();
    await controller.convert(userId, value);
    if (!mounted) {
      return;
    }
    await authController.loadSession();
    if (!mounted) {
      return;
    }
    if (mounted) {
      _pointsController.clear();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Pontos convertidos')));
    }
  }

  Future<void> _withdraw(String userId, WalletController controller) async {
    final value = double.tryParse(_withdrawController.text.replaceAll(',', '.'));
    if (value == null || value <= 0) {
      return;
    }
    await controller.withdraw(userId, value);
    if (mounted) {
      _withdrawController.clear();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Solicitação enviada')));
    }
  }
}
