import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../../features/orders/domain/entities/order.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    required this.order,
    required this.onTap,
    super.key,
  });

  final Order order;
  final VoidCallback onTap;

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppColors.warning;
      case OrderStatus.confirmed:
        return const Color(0xFF27AE60);
      case OrderStatus.shipped:
        return Colors.blue;
      case OrderStatus.delivered:
        return const Color(0xFF1E8449);
      case OrderStatus.cancelled:
        return AppColors.danger;
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'En attente';
      case OrderStatus.confirmed:
        return 'Confirmée';
      case OrderStatus.shipped:
        return 'En livraison';
      case OrderStatus.delivered:
        return 'Livrée';
      case OrderStatus.cancelled:
        return 'Annulée';
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd MMM yyyy, HH:mm').format(order.createdAt);
    final statusColor = _getStatusColor(order.status);
    final statusText = _getStatusText(order.status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.lightGray),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${order.id.substring(0, 8).toUpperCase()}',
                  style: AppTextStyles.bodyLarge
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  dateStr,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.darkGray),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    statusText.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${order.total.toStringAsFixed(0)} Fbu',
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.mediumGray,
                    ),
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
