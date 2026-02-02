import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../globals/constants/app_colors.dart';
import '../../../../globals/utils/formatters.dart';
import '../../../core/domain/entities/cart_item.dart';
import '../../../core/domain/entities/product.dart';
import '../../../cart/presentation/controllers/cart_controller.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../core/domain/entities/app_user.dart';
import '../../presentation/controllers/product_controller.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final ValueNotifier<int> quantity = ValueNotifier(1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductController>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, controller, child) {
        final product = _findProduct(controller.products);
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (product == null) {
          return const Center(child: Text('Produto não encontrado'));
        }
        return _content(context, product);
      },
    );
  }

  @override
  void dispose() {
    quantity.dispose();
    super.dispose();
  }

  Product? _findProduct(List<Product> products) {
    final matches = products.where((item) => item.id == widget.productId).toList();
    return matches.isEmpty ? null : matches.first;
  }

  Widget _content(BuildContext context, Product product) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;
          return isWide
              ? Row(
                  children: [
                    Expanded(child: _image(product)),
                    const SizedBox(width: 24),
                    Expanded(child: _info(context, product)),
                  ],
                )
              : ListView(
                  children: [
                    _image(product),
                    const SizedBox(height: 16),
                    _info(context, product),
                  ],
                );
        },
      ),
    );
  }

  Widget _image(Product product) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CachedNetworkImage(
        imageUrl: product.imageUrl,
        fit: BoxFit.cover,
        height: 320,
        width: double.infinity,
        placeholder: (context, url) => Container(
          color: AppColors.background,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Container(
          color: AppColors.background,
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image),
        ),
      ),
    );
  }

  Widget _info(BuildContext context, Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(product.name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(product.description),
        const SizedBox(height: 16),
        Text(
          Formatters.currency.format(product.price),
          style:
              Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.secondary),
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder<int>(
          valueListenable: quantity,
          builder: (context, value, child) {
            return _quantitySelector(value);
          },
        ),
        const SizedBox(height: 16),
        _addButton(product),
      ],
    );
  }

  Widget _quantitySelector(int value) {
    return Row(
      children: [
        IconButton(
          tooltip: 'Diminuir',
          onPressed: value > 1 ? () => _updateQuantity(value - 1) : null,
          icon: const Icon(Icons.remove),
        ),
        Text(value.toString()),
        IconButton(
          tooltip: 'Aumentar',
          onPressed: () => _updateQuantity(value + 1),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _addButton(Product product) {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        return ElevatedButton.icon(
          onPressed: () => _addToCart(authController.user, product),
          icon: const Icon(Icons.shopping_cart),
          label: const Text('Adicionar ao carrinho'),
        );
      },
    );
  }

  Future<void> _addToCart(
    AppUser? user,
    Product product,
  ) async {
    if (user == null) {
      return;
    }
    await context.read<CartController>().addItem(
          user.id,
          CartItem(product: product, quantity: quantity.value),
        );
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produto adicionado ao carrinho')),
    );
  }

  void _updateQuantity(int value) {
    quantity.value = value;
  }
}
