import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../../features/cart/data/models/cart_item.dart';

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
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.lightGray),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(4),
                image: item.product.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(item.product.imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: item.product.imageUrl == null
                  ? const Icon(
                      Icons.shopping_bag_outlined,
                      color: AppColors.mediumGray,
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
                          style: AppTextStyles.bodyMedium
                              .copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        onTap: () => onRemove(item.product.id),
                        child: const Icon(
                          Icons.close,
                          size: 20,
                          color: AppColors.danger,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.product.price.toStringAsFixed(0)} Fbu',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.darkGray),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _QuantityButton(
                        icon: Icons.remove,
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
                          style: AppTextStyles.bodyMedium
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      _QuantityButton(
                        icon: Icons.add,
                        onTap: () => onUpdateQuantity(item.product.id, item.quantity + 1),
                      ),
                      const Spacer(),
                      Text(
                        '${item.totalPrice.toStringAsFixed(0)} Fbu',
                        style: AppTextStyles.bodyMedium
                            .copyWith(fontWeight: FontWeight.bold),
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
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderGray),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(icon, size: 16, color: AppColors.black),
        ),
      );
}
