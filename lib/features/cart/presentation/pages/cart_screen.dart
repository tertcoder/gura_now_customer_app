import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';
import '../bloc/cart_bloc.dart';

final _currencyFormat = NumberFormat('#,###', 'fr');

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final cartItems = state.items;
        final subtotal = state.totalPrice;
        const deliveryFee = 500.0; // ~500 BIF
        final total = subtotal + deliveryFee;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Mon Panier', style: AppTextStyles.heading2),
                if (cartItems.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${cartItems.length}',
                      style: AppTextStyles.badge.copyWith(fontSize: 12),
                    ),
                  ),
                ],
              ],
            ),
            backgroundColor: AppColors.background,
            elevation: 0,
            centerTitle: true,
            foregroundColor: AppColors.textPrimary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => context.pop(),
            ),
            actions: [
              if (cartItems.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: AppColors.textSecondary),
                  onPressed: () => context.read<CartBloc>().add(const CartCleared()),
                ),
            ],
          ),
          body: cartItems.isEmpty
              ? EmptyState(
                  icon: Icons.shopping_cart_outlined,
                  title: 'Votre panier est vide',
                  subtitle: 'Ajoutez des articles depuis les boutiques',
                  actionLabel: 'Explorer les boutiques',
                  onAction: () => context.go('/home'),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) => CartItemWidget(
                          item: cartItems[index],
                          onRemove: (productId) => context.read<CartBloc>().add(CartItemRemoved(productId)),
                          onUpdateQuantity: (productId, quantity) => context.read<CartBloc>().add(CartQuantityUpdated(productId, quantity)),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        border: Border(top: BorderSide(color: AppColors.borderGray)),
                      ),
                      child: SafeArea(
                        top: false,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _SummaryRow(label: 'Sous-total', value: subtotal, format: _currencyFormat),
                            const SizedBox(height: 8),
                            _SummaryRow(label: 'Frais de livraison', value: deliveryFee, format: _currencyFormat, hint: '~'),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Divider(color: AppColors.borderGray),
                            ),
                            _SummaryRow(label: 'Total', value: total, isTotal: true, format: _currencyFormat),
                            const SizedBox(height: 24),
                            CustomButton(
                              text: 'Passer la commande',
                              backgroundColor: AppColors.primary,
                              onPressed: () => context.push('/checkout'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.format,
    this.isTotal = false,
    this.hint,
  });

  final String label;
  final double value;
  final NumberFormat format;
  final bool isTotal;
  final String? hint;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)
                : AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          Text(
            '${hint ?? ''}${format.format(value.round())} BIF',
            style: isTotal
                ? AppTextStyles.priceLarge.copyWith(color: AppColors.primary)
                : AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
          ),
        ],
      );
}
