import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../../features/shop/domain/entities/shop.dart';

class ShopCard extends StatelessWidget {
  const ShopCard({
    required this.shop,
    required this.onTap,
    super.key,
  });

  final Shop shop;
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
              // Image
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  color: AppColors.surfaceContainer,
                  child: shop.logoUrl != null && shop.logoUrl!.isNotEmpty
                      ? Image.network(
                          shop.logoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                ),
              ),
              // Info: name (heading5), type badge, rating with star, delivery info
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          shop.type.toUpperCase(),
                          style: AppTextStyles.badge.copyWith(
                            color: AppColors.primary,
                            fontSize: 9,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        shop.name,
                        style: AppTextStyles.heading5,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 14, color: AppColors.guraOrange),
                          const SizedBox(width: 4),
                          Text(
                            shop.rating.toStringAsFixed(1),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${shop.totalReviews})',
                            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                          ),
                          const Spacer(),
                          Icon(Icons.delivery_dining_rounded, size: 12, color: AppColors.textTertiary),
                          const SizedBox(width: 2),
                          Text(
                            shop.deliveryScope ?? 'Bujumbura',
                            style: AppTextStyles.caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildPlaceholder() => Center(
        child: Icon(
          Icons.store_rounded,
          size: 40,
          color: AppColors.primary.withValues(alpha: 0.6),
        ),
      );
}
