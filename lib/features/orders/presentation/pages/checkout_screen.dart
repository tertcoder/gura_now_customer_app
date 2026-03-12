import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../bloc/order_bloc.dart';

final _currencyFormat = NumberFormat('#,###', 'fr');

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
  File? _paymentProofImage;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickPaymentProof() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null && mounted) {
      setState(() => _paymentProofImage = File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        final cartItems = cartState.items;
        final subtotal = cartState.totalPrice;
        const deliveryFee = 500.0;
        final total = subtotal + deliveryFee;

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
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state.createStatus == OrderActionStatus.loading;
            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                title: Text('Checkout', style: AppTextStyles.heading2),
                backgroundColor: AppColors.background,
                elevation: 0,
                foregroundColor: AppColors.textPrimary,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => context.pop(),
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _SectionTitle(title: 'Résumé commande'),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderGray),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${cartItems.length} article${cartItems.length > 1 ? 's' : ''}',
                                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                                ),
                                Text(
                                  '${_currencyFormat.format(subtotal.round())} BIF',
                                  style: AppTextStyles.priceSmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Divider(height: 1, color: AppColors.borderGray),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total', style: AppTextStyles.label.copyWith(color: AppColors.textPrimary)),
                                Text(
                                  '${_currencyFormat.format(total.round())} BIF',
                                  style: AppTextStyles.price.copyWith(color: AppColors.primary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      _SectionTitle(title: 'Adresse de livraison'),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _addressController,
                        label: 'Adresse exacte',
                        hint: 'Quartier, Avenue, N°...',
                        maxLines: 2,
                        prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.textSecondary, size: 20),
                        validator: (v) => (v == null || v.toString().trim().isEmpty) ? 'Adresse requise' : null,
                      ),
                      const SizedBox(height: 24),

                      _SectionTitle(title: 'Mode de livraison'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _OptionCard(
                              label: 'Livraison à domicile',
                              icon: Icons.delivery_dining_rounded,
                              isSelected: _deliveryMode == 'delivery',
                              onTap: () => setState(() => _deliveryMode = 'delivery'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _OptionCard(
                              label: 'Retrait en boutique',
                              icon: Icons.store_rounded,
                              isSelected: _deliveryMode == 'pickup',
                              onTap: () => setState(() => _deliveryMode = 'pickup'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      _SectionTitle(title: 'Paiement'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _OptionCard(
                              label: 'Espèces',
                              icon: Icons.payments_rounded,
                              isSelected: _paymentMethod == 'cash',
                              onTap: () => setState(() => _paymentMethod = 'cash'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _OptionCard(
                              label: 'Mobile Money',
                              icon: Icons.phone_android_rounded,
                              isSelected: _paymentMethod == 'mobile_money',
                              onTap: () => setState(() => _paymentMethod = 'mobile_money'),
                            ),
                          ),
                        ],
                      ),
                      if (_paymentMethod == 'mobile_money') ...[
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: _pickPaymentProof,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _paymentProofImage != null ? AppColors.primary : AppColors.borderGray,
                              ),
                            ),
                            child: _paymentProofImage != null
                                ? Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          _paymentProofImage!,
                                          height: 120,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Preuve de paiement ajoutée',
                                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.success),
                                      ),
                                      TextButton(
                                        onPressed: () => setState(() => _paymentProofImage = null),
                                        child: Text('Changer', style: AppTextStyles.link),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.upload_file_rounded, color: AppColors.textSecondary, size: 24),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Ajouter preuve (Ecocash/Lumicash)',
                                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),

                      _SectionTitle(title: 'Total final'),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderGray),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total à payer', style: AppTextStyles.heading5),
                            Text(
                              '${_currencyFormat.format(total.round())} BIF',
                              style: AppTextStyles.priceLarge.copyWith(color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      CustomButton(
                        text: 'Confirmer la commande',
                        backgroundColor: AppColors.primary,
                        isLoading: isLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final orderData = {
                              'shipping_address': _addressController.text.trim(),
                              'delivery_mode': _deliveryMode,
                              'payment_method': _paymentMethod,
                              'items': cartItems
                                  .map((e) => {
                                        'product_id': e.product.id,
                                        'quantity': e.quantity,
                                        'price': e.product.price,
                                      })
                                  .toList(),
                            };
                            context.read<OrderBloc>().add(OrderCreateRequested(orderData));
                          }
                        },
                      ),
                      const SizedBox(height: 80),
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: AppTextStyles.heading4,
      );
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.borderGray,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 28, color: isSelected ? AppColors.primary : AppColors.textSecondary),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
}
