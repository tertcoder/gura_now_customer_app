import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';
import '../bloc/cart_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final cartItems = state.items;
        final subtotal = state.totalPrice;

        final commission = subtotal * 0.05;
        final total = subtotal + commission;

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            title: Text('Mon Panier', style: AppTextStyles.heading2),
            backgroundColor: AppColors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.black),
              onPressed: () => context.pop(),
            ),
            actions: [
              if (cartItems.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.black),
                  onPressed: () => context.read<CartBloc>().add(const CartCleared()),
                ),
            ],
          ),
          body: cartItems.isEmpty
              ? EmptyStateWidget(
                  message: 'Votre panier est vide',
                  icon: Icons.shopping_cart_outlined,
                  buttonText: 'Commencer mes achats',
                  onButtonPressed: () => context.go('/home'),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
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
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _SummaryRow(label: 'Sous-total', value: subtotal),
                          const SizedBox(height: 8),
                          _SummaryRow(label: 'Commission (5%)', value: commission),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Divider(color: AppColors.borderGray),
                          ),
                          _SummaryRow(label: 'Total', value: total, isTotal: true),
                          const SizedBox(height: 24),
                          CustomButton(
                            text: 'PASSER LA COMMANDE',
                            backgroundColor: const Color(0xFF27AE60),
                            onPressed: () => context.push('/checkout'),
                          ),
                        ],
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
    this.isTotal = false,
  });

  final String label;
  final double value;
  final bool isTotal;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)
                : AppTextStyles.bodyMedium.copyWith(color: AppColors.darkGray),
          ),
          Text(
            '${value.toStringAsFixed(0)} Fbu',
            style: isTotal
                ? AppTextStyles.heading3
                : AppTextStyles.bodyMedium
                    .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      );
}
