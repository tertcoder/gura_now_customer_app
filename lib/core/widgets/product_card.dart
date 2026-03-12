import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../../features/shop/domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.product,
    required this.onTap,
    super.key,
  });

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderGray),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: AppColors.surfaceContainer,
                  child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                      ? Image.network(
                          product.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.shopping_bag_outlined,
                            color: AppColors.textTertiary,
                            size: 40,
                          ),
                        )
                      : const Icon(
                          Icons.shopping_bag_outlined,
                          color: AppColors.textTertiary,
                          size: 40,
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppTextStyles.heading5,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${product.price.toStringAsFixed(0)} BIF',
                      style: AppTextStyles.priceSmall.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
