import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../globals/utils/formatters.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../core/domain/entities/order.dart';
import '../controllers/order_controller.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthController>().user;
      if (user != null) {
        context.read<OrderController>().load(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthController, OrderController>(
      builder: (context, auth, controller, child) {
        final user = auth.user;
        if (user == null) {
          return const Center(child: Text('Faça login para ver pedidos'));
        }
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.orders.isEmpty) {
          return const Center(child: Text('Nenhum pedido registrado'));
        }
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('Histórico de compras', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            ...controller.orders.map(_orderCard),
          ],
        );
      },
    );
  }

  Widget _orderCard(Order order) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pedido ${order.id}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Data: ${Formatters.dateTime.format(order.createdAt)}'),
            const SizedBox(height: 8),
            ...order.items.map(
              (item) => ListTile(
                title: Text(item.name),
                subtitle: Text('Quantidade ${item.quantity}'),
                trailing: Text(Formatters.currency.format(item.price)),
              ),
            ),
            const Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Total: ${Formatters.currency.format(order.total)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
