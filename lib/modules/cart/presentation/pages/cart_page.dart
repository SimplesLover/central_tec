import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../globals/utils/formatters.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../core/domain/entities/cart_item.dart';
import '../controllers/cart_controller.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthController>().user;
      if (user != null) {
        context.read<CartController>().load(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthController, CartController>(
      builder: (context, authController, cartController, child) {
        final user = authController.user;
        if (user == null) {
          return const Center(child: Text('Faça login para ver o carrinho'));
        }
        if (cartController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            Expanded(child: _itemsList(user.id, cartController)),
            _summary(cartController, user.id),
          ],
        );
      },
    );
  }

  Widget _itemsList(String userId, CartController controller) {
    if (controller.items.isEmpty) {
      return const Center(child: Text('Carrinho vazio'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.items.length,
      itemBuilder: (context, index) {
        return _cartItemTile(userId, controller.items[index]);
      },
    );
  }

  Widget _cartItemTile(String userId, CartItem item) {
    return Card(
      child: ListTile(
        title: Text(item.product.name),
        subtitle: Text(Formatters.currency.format(item.product.price)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Diminuir quantidade',
              onPressed: () => _updateQuantity(userId, item, item.quantity - 1),
              icon: const Icon(Icons.remove),
            ),
            Text(item.quantity.toString()),
            IconButton(
              tooltip: 'Aumentar quantidade',
              onPressed: () => _updateQuantity(userId, item, item.quantity + 1),
              icon: const Icon(Icons.add),
            ),
            IconButton(
              tooltip: 'Remover',
              onPressed: () => _confirmRemove(userId, item),
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summary(CartController controller, String userId) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: const Border(top: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Subtotal: ${Formatters.currency.format(controller.subtotal)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ElevatedButton(
            onPressed: controller.items.isEmpty ? null : () => context.go('/checkout'),
            child: const Text('Finalizar compra'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateQuantity(
    String userId,
    CartItem item,
    int value,
  ) async {
    if (value <= 0) {
      await _confirmRemove(userId, item);
      return;
    }
    await context
        .read<CartController>()
        .updateItem(userId, item.copyWith(quantity: value));
  }

  Future<void> _confirmRemove(String userId, CartItem item) async {
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remover item'),
          content: const Text('Deseja remover este item do carrinho?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Remover'),
            ),
          ],
        );
      },
    );
    if (!mounted) {
      return;
    }
    if (shouldRemove == true) {
      await context.read<CartController>().removeItem(userId, item.product.id);
    }
  }
}
