import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../globals/utils/formatters.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/network_controller.dart';

class NetworkPage extends StatefulWidget {
  const NetworkPage({super.key});

  @override
  State<NetworkPage> createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthController>().user;
      if (user != null) {
        context.read<NetworkController>().load(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthController, NetworkController>(
      builder: (context, auth, controller, child) {
        final user = auth.user;
        if (user == null) {
          return const Center(child: Text('Faça login para ver sua rede'));
        }
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('Minha rede', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            _referralCard(user.referralCode),
            const SizedBox(height: 16),
            _summary(controller),
            const SizedBox(height: 16),
            _referralList(controller),
          ],
        );
      },
    );
  }

  Widget _referralCard(String code) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Seu código: $code',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _copyCode(code),
              icon: const Icon(Icons.copy),
              label: const Text('Copiar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summary(NetworkController controller) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _summaryTile('Nível 1', controller.levelOne.length.toString()),
        _summaryTile('Nível 2', controller.levelTwo.length.toString()),
        _summaryTile('Nível 3', controller.levelThree.length.toString()),
        _summaryTile('Total', controller.total.toString()),
      ],
    );
  }

  Widget _summaryTile(String title, String value) {
    return SizedBox(
      width: 220,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              const SizedBox(height: 8),
              Text(value, style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
        ),
      ),
    );
  }

  Widget _referralList(NetworkController controller) {
    if (controller.referrals.isEmpty) {
      return const Center(child: Text('Nenhuma indicação registrada'));
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Indicações recentes', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...controller.referrals.map(
              (item) => ListTile(
                title: Text('Código ${item.id}'),
                subtitle: Text(Formatters.dateTime.format(item.createdAt)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _copyCode(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Código copiado')),
      );
    }
  }
}
