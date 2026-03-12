import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/product_card.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/shop.dart';
import '../bloc/shop_bloc.dart';

/// Mock products for now (until Product Module is fully spec'd).
List<Product> _mockProducts(String shopId) {
  return List.generate(
    10,
    (index) => Product(
      id: 'prod_$index',
      name: 'Produit Item $index',
      description: 'Description du produit $index',
      price: (index + 1) * 1000.0,
      shopId: shopId,
    ),
  );
}

class ShopDetailScreen extends StatefulWidget {
  const ShopDetailScreen({
    super.key,
    required this.shopId,
    this.shopExtra,
  });

  final String shopId;
  final Shop? shopExtra;

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  List<Product>? _products;

  @override
  void initState() {
    super.initState();
    if (widget.shopExtra == null) {
      context.read<ShopBloc>().add(ShopDetailRequested(widget.shopId));
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _products = _mockProducts(widget.shopId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      buildWhen: (prev, next) =>
          prev.detailStatus != next.detailStatus ||
          prev.selectedShop != next.selectedShop,
      builder: (context, state) {
        final shop = widget.shopExtra ??
            (state.detailStatus == ShopDetailStatus.success
                ? state.selectedShop
                : null);
        if (shop == null) {
          if (state.detailStatus == ShopDetailStatus.failure) {
            return Scaffold(
              backgroundColor: AppColors.white,
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
              ),
              body: Center(child: Text('Erreur: ${state.detailError}')),
            );
          }
          return Scaffold(
            backgroundColor: AppColors.white,
            body: const Center(
              child: CircularProgressIndicator(color: AppColors.black),
            ),
          );
        }
        final products = _products ?? [];
        return Scaffold(
          backgroundColor: AppColors.white,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                backgroundColor: AppColors.black,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  title: Text(
                    shop.name,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  background: shop.logoUrl != null
                      ? Image.network(
                          shop.logoUrl!,
                          fit: BoxFit.cover,
                          color: Colors.black.withValues(alpha: 0.5),
                          colorBlendMode: BlendMode.darken,
                        )
                      : Container(color: AppColors.darkGray),
                ),
                leading: IconButton(
                  icon: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  onPressed: () => context.pop(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 16, color: AppColors.darkGray),
                          const SizedBox(width: 4),
                          Text(shop.deliveryScope ?? 'Local',
                              style: AppTextStyles.bodySmall),
                          const Spacer(),
                          const Icon(Icons.star,
                              size: 16, color: AppColors.black),
                          Text(
                            '${shop.rating} (${shop.totalReviews})',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        shop.description ?? 'Aucune description',
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      Text('Produits', style: AppTextStyles.heading2),
                      const Divider(
                        color: AppColors.black,
                        thickness: 2,
                        endIndent: 300,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              if (products.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.black),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = products[index];
                        return ProductCard(
                          product: product,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Détail produit à venir (Module Cart)',
                                ),
                              ),
                            );
                          },
                        );
                      },
                      childCount: products.length,
                    ),
                  ),
                ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 50)),
            ],
          ),
        );
      },
    );
  }
}
