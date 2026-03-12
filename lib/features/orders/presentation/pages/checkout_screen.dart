import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../bloc/order_bloc.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();

  String _deliveryMode = 'delivery';
  String _paymentMethod = 'cash';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        final cartItems = cartState.items;
        final subtotal = cartState.totalPrice;
        final commission = subtotal * 0.05;
        final total = subtotal + commission;

        return BlocConsumer<OrderBloc, OrderState>(
          listenWhen: (prev, next) => prev.createStatus != next.createStatus,
          listener: (context, state) {
            if (state.createStatus == OrderActionStatus.success &&
                state.createdOrder != null) {
              context.read<CartBloc>().add(const CartCleared());
              context.go('/order-success/${state.createdOrder!.id}');
            } else if (state.createStatus == OrderActionStatus.failure &&
                state.createError != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.createError!),
                  backgroundColor: AppColors.danger,
                ),
              );
            }
          },
          buildWhen: (prev, next) => prev.createStatus != next.createStatus,
          builder: (context, state) {
            final isLoading = state.createStatus == OrderActionStatus.loading;
            return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text('Caisse', style: AppTextStyles.heading2),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Order Summary
              Text('Résumé de la commande',
                  style: AppTextStyles.heading3),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    ...cartItems.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${item.quantity}x ${item.product.name}'),
                              Text('${item.totalPrice.toStringAsFixed(0)} Fbu'),
                            ],
                          ),
                        )),
                    const Divider(color: AppColors.borderGray),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total avec comm.',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${total.toStringAsFixed(0)} Fbu',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 2. Delivery Address
              Text('Adresse de livraison', style: AppTextStyles.heading3),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Adresse exacte',
                hint: 'Quartier, Avenue, N°...',
                controller: _addressController,
                maxLines: 2,
                prefixIcon: const Icon(Icons.location_on_outlined,
                    color: AppColors.mediumGray),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Adresse requise' : null,
              ),
              const SizedBox(height: 32),

              // 3. Delivery Mode
              Text('Mode de livraison', style: AppTextStyles.heading3),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _deliveryMode,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                items: const [
                  DropdownMenuItem(
                      value: 'delivery', child: Text('Livraison à domicile')),
                  DropdownMenuItem(
                      value: 'pickup',
                      child: Text('Retrait en boutique (Pickup)')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _deliveryMode = val);
                },
              ),
              const SizedBox(height: 32),

              // 4. Payment Method
              Text('Moyen de paiement', style: AppTextStyles.heading3),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _paymentMethod,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                items: const [
                  DropdownMenuItem(
                      value: 'cash', child: Text('Cash à la livraison')),
                  DropdownMenuItem(
                      value: 'mobile_money',
                      child: Text('Mobile Money (Lumicash/Ecocash)')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _paymentMethod = val);
                },
              ),

              if (_paymentMethod == 'mobile_money') ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.mediumGray, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file, color: AppColors.mediumGray),
                      SizedBox(width: 8),
                      Text('Ajouter preuve de paiement (Capture)'),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 48),

              // Confirm Button
              CustomButton(
                text: 'CONFIRMER LA COMMANDE',
                backgroundColor: const Color(0xFF27AE60),
                isLoading: isLoading,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Prepare data
                    final orderData = {
                      // Backend expects structure...
                      // Based on OrderModel it creates items.
                      // Usually POST /orders expects:
                      // { "items": [{product_id, quantity...}], "shipping_address": "...", "payment_method": "..." }
                      // Note: Check backend schema if strictly needed, but assuming generic standard for now.
                      // Actually, let's include shop_id if cart creates separate orders per shop?
                      // Or assume single shop cart? Prompt didn't specify multi-shop split.
                      // We will assume simpler cart for now or take the shopId from the first item if needed.

                      'shipping_address': _addressController.text,
                      'delivery_mode': _deliveryMode,
                      'payment_method': _paymentMethod,
                      'items': cartItems
                          .map((e) => {
                                'product_id': e.product.id,
                                'quantity': e.quantity,
                                'price': e.product
                                    .price, // Optional if backend recalculates
                              })
                          .toList(),
                      // 'shop_id': cartItems.first.product.shopId, // If backend needs it
                    };

                    context
                        .read<OrderBloc>()
                        .add(OrderCreateRequested(orderData));
                  }
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
            );
          },
        );
      },
    );
  }
}
