import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../globals/constants/app_constants.dart';
import '../../../../globals/utils/formatters.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../cart/presentation/controllers/cart_controller.dart';
import '../../../core/domain/entities/order.dart';
import '../../../orders/domain/entities/order_inputs.dart';
import '../controllers/order_controller.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _couponController = TextEditingController();
  final ValueNotifier<PaymentMethod> paymentMethod =
      ValueNotifier(PaymentMethod.pix);
  final ValueNotifier<bool> applyCoupon = ValueNotifier(false);

  @override
  void dispose() {
    _couponController.dispose();
    paymentMethod.dispose();
    applyCoupon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<AuthController, CartController, OrderController>(
      builder: (context, authController, cartController, orderController, child) {
        final user = authController.user;
        if (user == null) {
          return const Center(child: Text('Faça login para finalizar a compra'));
        }
        return _content(user.id, cartController, orderController, user.referredByCode != null);
      },
    );
  }

  Widget _content(
    String userId,
    CartController cartController,
    OrderController orderController,
    bool isReferred,
  ) {
    final subtotal = cartController.subtotal;
    return ValueListenableBuilder<bool>(
      valueListenable: applyCoupon,
      builder: (context, couponEnabled, child) {
        final discount = _discount(subtotal, isReferred, couponEnabled);
        final total = subtotal - discount;
        final cashback = total * AppConstants.cashbackRate;
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('Checkout', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            _summary(subtotal, discount, total, cashback),
            const SizedBox(height: 16),
            _coupon(isReferred),
            const SizedBox(height: 16),
            _payment(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: cartController.items.isEmpty
                  ? null
                  : () => _confirmOrder(
                        userId,
                        cartController,
                        orderController,
                        subtotal,
                        discount,
                        total,
                        cashback,
                      ),
              child: const Text('Confirmar pedido'),
            ),
          ],
        );
      },
    );
  }

  Widget _summary(double subtotal, double discount, double total, double cashback) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row('Subtotal', Formatters.currency.format(subtotal)),
            _row('Desconto', Formatters.currency.format(discount)),
            _row('Total', Formatters.currency.format(total)),
            _row('Cashback', Formatters.currency.format(cashback)),
          ],
        ),
      ),
    );
  }

  Widget _coupon(bool isReferred) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cupom de desconto', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ValueListenableBuilder<bool>(
              valueListenable: applyCoupon,
              builder: (context, value, child) {
                return SwitchListTile(
                  value: value,
                  onChanged: isReferred ? (next) => applyCoupon.value = next : null,
                  title:
                      Text(isReferred ? 'Usar bônus de indicado' : 'Cupom indisponível'),
                );
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: applyCoupon,
              builder: (context, value, child) {
                if (!value) {
                  return const SizedBox.shrink();
                }
                return TextFormField(
                  controller: _couponController,
                  decoration: const InputDecoration(labelText: 'Código do cupom'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _payment() {
    return ValueListenableBuilder<PaymentMethod>(
      valueListenable: paymentMethod,
      builder: (context, selected, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: RadioGroup<PaymentMethod>(
              groupValue: selected,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                paymentMethod.value = value;
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pagamento', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  _radio(PaymentMethod.pix, 'Pix'),
                  _radio(PaymentMethod.card, 'Cartão'),
                  _radio(PaymentMethod.boleto, 'Boleto'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value),
        ],
      ),
    );
  }

  Widget _radio(PaymentMethod method, String label) {
    return RadioListTile<PaymentMethod>(
      value: method,
      title: Text(label),
    );
  }

  double _discount(double subtotal, bool isReferred, bool couponEnabled) {
    if (!couponEnabled || !isReferred) {
      return 0;
    }
    if (_couponController.text.trim().isEmpty) {
      return 0;
    }
    return subtotal * AppConstants.referredDiscountRate;
  }

  Future<void> _confirmOrder(
    String userId,
    CartController cartController,
    OrderController orderController,
    double subtotal,
    double discount,
    double total,
    double cashback,
  ) async {
    final items = cartController.items
        .map(
          (item) => OrderItem(
            productId: item.product.id,
            name: item.product.name,
            price: item.product.price,
            quantity: item.quantity,
          ),
        )
        .toList();
    await orderController.placeOrder(
      PlaceOrderInput(
        userId: userId,
        items: items,
        subtotal: subtotal,
        discount: discount,
        total: total,
        cashback: cashback,
        paymentMethod: paymentMethod.value,
      ),
    );
    await cartController.clear(userId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido realizado com sucesso')),
      );
    }
  }
}
