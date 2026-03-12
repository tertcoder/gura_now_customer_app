import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'status_badge.dart';
import '../../features/orders/domain/entities/order.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    required this.order,
    required this.onTap,
    super.key,
  });

  final Order order;
  final VoidCallback onTap;

  static String _statusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.confirmed:
        return 'confirmed';
      case OrderStatus.shipped:
        return 'shipped';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    final dateStr = timeago.format(order.createdAt, locale: 'fr');
    final statusBadge = StatusBadge.fromStatus(_statusToString(order.status));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderGray),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#GN-${order.id.length >= 8 ? order.id.substring(0, 8).toUpperCase() : order.id.toUpperCase()}',
                  style: AppTextStyles.heading5,
                ),
                Text(
                  dateStr,
                  style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                statusBadge,
                Row(
                  children: [
                    Text(
                      '${NumberFormat('#,###', 'fr').format(order.total.round())} BIF',
                      style: AppTextStyles.priceSmall.copyWith(color: AppColors.textPrimary),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 20),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
