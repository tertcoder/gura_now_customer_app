import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/order.dart';
import '../bloc/order_bloc.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({
    super.key,
    required this.orderId,
  });
  final String orderId;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(OrderDetailRequested(widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthBloc>().state.user;

    return BlocConsumer<OrderBloc, OrderState>(
      listenWhen: (prev, next) =>
          prev.actionStatus != next.actionStatus ||
          prev.detailStatus != next.detailStatus,
      listener: (context, state) {
        if (state.actionStatus == OrderActionStatus.failure &&
            state.actionError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: ${state.actionError}'),
              backgroundColor: AppColors.danger,
            ),
          );
        }
        if (state.actionStatus == OrderActionStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Statut mis à jour !'),
              backgroundColor: Color(0xFF27AE60),
            ),
          );
          context.read<OrderBloc>().add(OrderDetailRequested(widget.orderId));
        }
      },
      buildWhen: (prev, next) =>
          prev.detailStatus != next.detailStatus ||
          prev.selectedOrder != next.selectedOrder,
      builder: (context, state) {
        if (state.detailStatus == OrderDetailStatus.initial ||
            state.detailStatus == OrderDetailStatus.loading) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              title: const Text('Détail Commande'),
              backgroundColor: AppColors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.black),
                onPressed: () => context.pop(),
              ),
            ),
            body: const Center(
                child: CircularProgressIndicator(color: AppColors.black)),
          );
        }
        if (state.detailStatus == OrderDetailStatus.failure ||
            state.selectedOrder == null) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              title: const Text('Détail Commande'),
              backgroundColor: AppColors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.black),
                onPressed: () => context.pop(),
              ),
            ),
            body: Center(child: Text('Erreur: ${state.detailError ?? "Non trouvée"}')),
          );
        }

        final order = state.selectedOrder!;
        final isCustomer = currentUser?.role == 'customer';
        final isShopOwner = currentUser?.role == 'shop_owner';
        final isActionLoading = state.actionStatus == OrderActionStatus.loading;

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            title: const Text('Détail Commande'),
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.black),
              onPressed: () => context.pop(),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('#${order.id.substring(0, 8).toUpperCase()}',
                    style: AppTextStyles.heading2),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd MMM yyyy à HH:mm').format(order.createdAt),
                  style:
                      AppTextStyles.bodySmall.copyWith(color: AppColors.darkGray),
                ),
                const SizedBox(height: 24),
                _OrderStepper(currentStatus: order.status),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Adresse de livraison',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(order.shippingAddress,
                          style: AppTextStyles.bodyMedium),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Articles',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            color: AppColors.lightGray,
                            child: const Icon(Icons.shopping_bag,
                                color: AppColors.mediumGray),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Article #${item.productId.substring(0, 6)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text('${item.quantity} x ${item.price} Fbu'),
                              ],
                            ),
                          ),
                          Text(
                              '${(item.price * item.quantity).toStringAsFixed(0)} Fbu'),
                        ],
                      ),
                    )),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Payé',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('${order.total.toStringAsFixed(0)} Fbu',
                        style: AppTextStyles.heading3),
                  ],
                ),
                const SizedBox(height: 48),
                if (order.status == OrderStatus.shipped && isCustomer)
                  CustomButton(
                    text: 'CONFIRMER RÉCEPTION',
                    backgroundColor: const Color(0xFF27AE60),
                    isLoading: isActionLoading,
                    onPressed: () {
                      context
                          .read<OrderBloc>()
                          .add(OrderConfirmCustomerRequested(order.id));
                    },
                  ),
                if (order.status == OrderStatus.pending && isShopOwner)
                  CustomButton(
                    text: 'ACCEPTER & PRÉPARER',
                    backgroundColor: AppColors.warning,
                    isLoading: isActionLoading,
                    onPressed: () {
                      context
                          .read<OrderBloc>()
                          .add(OrderConfirmShopRequested(order.id));
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OrderStepper extends StatelessWidget {
  const _OrderStepper({required this.currentStatus});
  final OrderStatus currentStatus;

  @override
  Widget build(BuildContext context) {
    final steps = [
      OrderStatus.pending,
      OrderStatus.confirmed,
      OrderStatus.shipped,
      OrderStatus.delivered
    ];
    var currentIndex = steps.indexOf(currentStatus);
    if (currentStatus == OrderStatus.cancelled) currentIndex = -1;

    return Row(
      children: List.generate(steps.length, (index) {
        final isActive = index <= currentIndex;
        final isLast = index == steps.length - 1;
        return Expanded(
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.black : AppColors.lightGray,
                  shape: BoxShape.circle,
                ),
                child: isActive
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2,
                    color: isActive ? AppColors.black : AppColors.lightGray,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
