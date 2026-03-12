import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../../features/cart/data/models/cart_item.dart';

final _currencyFormat = NumberFormat('#,###', 'fr');

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({
    required this.item,
    required this.onRemove,
    required this.onUpdateQuantity,
    super.key,
  });

  final CartItem item;
  final void Function(String productId) onRemove;
  final void Function(String productId, int quantity) onUpdateQuantity;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderGray),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
                image: item.product.imageUrl != null && item.product.imageUrl!.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(item.product.imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: item.product.imageUrl == null || item.product.imageUrl!.isEmpty
                  ? const Icon(
                      Icons.shopping_bag_outlined,
                      color: AppColors.textTertiary,
                      size: 32,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.product.name,
                          style: AppTextStyles.heading5,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        onTap: () => onRemove(item.product.id),
                        borderRadius: BorderRadius.circular(8),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_currencyFormat.format(item.product.price.round())} BIF / unité',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _QuantityButton(
                        icon: Icons.remove_rounded,
                        onTap: () {
                          if (item.quantity > 1) {
                            onUpdateQuantity(item.product.id, item.quantity - 1);
                          } else {
                            onRemove(item.product.id);
                          }
                        },
                      ),
                      SizedBox(
                        width: 40,
                        child: Text(
                          '${item.quantity}',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      _QuantityButton(
                        icon: Icons.add_rounded,
                        onTap: () => onUpdateQuantity(item.product.id, item.quantity + 1),
                      ),
                      const Spacer(),
                      Text(
                        '${_currencyFormat.format(item.totalPrice.round())} BIF',
                        style: AppTextStyles.priceSmall.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderGray),
            borderRadius: BorderRadius.circular(8),
            color: AppColors.surfaceContainer,
          ),
          child: Icon(icon, size: 18, color: AppColors.textPrimary),
        ),
      );
}
