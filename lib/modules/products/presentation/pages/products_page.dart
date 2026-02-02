import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../globals/constants/app_breakpoints.dart';
import '../../../../globals/constants/app_colors.dart';
import '../../../../globals/utils/formatters.dart';
import '../../../core/domain/entities/product.dart';
import '../../presentation/controllers/product_controller.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
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
        return Column(
          children: [
            _filters(controller),
            Expanded(child: _content(controller)),
          ],
        );
      },
    );
  }

  Widget _filters(ProductController controller) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        runSpacing: 12,
        spacing: 12,
        alignment: WrapAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 260,
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Buscar produtos',
              ),
              onChanged: controller.updateQuery,
            ),
          ),
          SizedBox(
            width: 220,
            child: DropdownButtonFormField<String>(
              key: ValueKey(controller.selectedCategory),
              initialValue: controller.selectedCategory,
              decoration: const InputDecoration(labelText: 'Categoria'),
              items: _categoryItems(controller),
              onChanged: controller.updateCategory,
            ),
          ),
          SizedBox(
            width: 220,
            child: _priceFilter(controller),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _categoryItems(ProductController controller) {
    final items = controller.categories
        .map((category) => DropdownMenuItem(value: category, child: Text(category)))
        .toList();
    return [
      const DropdownMenuItem(value: null, child: Text('Todas')),
      ...items,
    ];
  }

  Widget _priceFilter(ProductController controller) {
    final max = _maxPrice(controller.products);
    final current = controller.maxPrice ?? max;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Preço até ${Formatters.currency.format(current)}'),
        Slider(
          value: current,
          max: max,
          min: 0,
          onChanged: controller.updateMaxPrice,
        ),
      ],
    );
  }

  double _maxPrice(List<Product> products) {
    if (products.isEmpty) {
      return 10000;
    }
    return products.map((item) => item.price).reduce((a, b) => a > b ? a : b);
  }

  Widget _content(ProductController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (controller.errorMessage != null) {
      return Center(child: Text(controller.errorMessage!));
    }
    final items = controller.filtered;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width < AppBreakpoints.mobileMax
            ? 1
            : width < AppBreakpoints.tabletMax
                ? 2
                : 3;
        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return _productCard(items[index]);
          },
        );
      },
    );
  }

  Widget _productCard(Product product) {
    return Semantics(
      label: product.name,
      child: Card(
        child: InkWell(
          onTap: () => context.go('/products/${product.id}'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
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
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  Formatters.currency.format(product.price),
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: AppColors.secondary),
                ),
                const SizedBox(height: 4),
                Text(
                  product.category,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
