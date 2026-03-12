import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../review/presentation/widgets/review_form_modal.dart';
import '../../domain/entities/order.dart';
import '../bloc/order_bloc.dart';

final _currencyFormat = NumberFormat('#,###', 'fr');

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key, required this.orderId});
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
              content: Text(state.actionError!),
              backgroundColor: AppColors.danger,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
        if (state.actionStatus == OrderActionStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Statut mis à jour !'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: const Text('Détail commande'),
              backgroundColor: AppColors.background,
              foregroundColor: AppColors.textPrimary,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => context.pop(),
              ),
            ),
            body: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }
        if (state.detailStatus == OrderDetailStatus.failure ||
            state.selectedOrder == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: const Text('Détail commande'),
              backgroundColor: AppColors.background,
              foregroundColor: AppColors.textPrimary,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => context.pop(),
              ),
            ),
            body: EmptyState.error(
              message: state.detailError ?? 'Commande non trouvée',
              onRetry: () => context.read<OrderBloc>().add(OrderDetailRequested(widget.orderId)),
            ),
          );
        }

        final order = state.selectedOrder!;
        final isCustomer = currentUser?.role == 'customer';
        final isActionLoading = state.actionStatus == OrderActionStatus.loading;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Détail commande'),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '#GN-${order.id.length >= 8 ? order.id.substring(0, 8).toUpperCase() : order.id.toUpperCase()}',
                      style: AppTextStyles.heading2,
                    ),
                    StatusBadge.fromStatus(_orderStatusToString(order.status)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd MMM yyyy à HH:mm', 'fr').format(order.createdAt),
                  style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                ),
                const SizedBox(height: 24),

                _OrderStepper(currentStatus: order.status),
                const SizedBox(height: 24),

                _SectionTitle(title: 'Articles'),
                const SizedBox(height: 8),
                ...order.items.map((item) => _OrderItemRow(
                      productId: item.productId,
                      quantity: item.quantity,
                      price: item.price,
                    )),
                const SizedBox(height: 16),

                _SectionTitle(title: 'Adresse de livraison'),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderGray),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined, color: AppColors.textSecondary, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          order.shippingAddress,
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total payé', style: AppTextStyles.heading5),
                    Text(
                      '${_currencyFormat.format(order.total.round())} BIF',
                      style: AppTextStyles.priceLarge.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                if (order.status == OrderStatus.shipped && isCustomer)
                  CustomButton(
                    text: 'Confirmer la réception',
                    backgroundColor: AppColors.success,
                    isLoading: isActionLoading,
                    onPressed: () {
                      context.read<OrderBloc>().add(OrderConfirmCustomerRequested(order.id));
                    },
                  ),
                if (order.status == OrderStatus.delivered && isCustomer) ...[
                  CustomButton(
                    text: 'Laisser un avis',
                    isOutlined: true,
                    onPressed: () {
                      showReviewFormModal(
                        context: context,
                        targetName: 'cette commande',
                        reviewType: 'shop',
                        orderId: order.id,
                        onSubmit: (rating, comment) async {
                          // TODO: call review API when available
                          await Future.delayed(const Duration(milliseconds: 500));
                        },
                      );
                    },
                  ),
                ],
                if (order.status == OrderStatus.pending && currentUser?.role == 'shop_owner')
                  CustomButton(
                    text: 'Accepter & préparer',
                    backgroundColor: AppColors.warning,
                    isLoading: isActionLoading,
                    onPressed: () {
                      context.read<OrderBloc>().add(OrderConfirmShopRequested(order.id));
                    },
                  ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      },
    );
  }
}

String _orderStatusToString(OrderStatus status) {
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Text(title, style: AppTextStyles.heading5);
}

class _OrderItemRow extends StatelessWidget {
  const _OrderItemRow({
    required this.productId,
    required this.quantity,
    required this.price,
  });
  final String productId;
  final int quantity;
  final double price;

  @override
  Widget build(BuildContext context) {
    final total = price * quantity;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.shopping_bag_outlined, color: AppColors.textTertiary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Article ${productId.length >= 6 ? productId.substring(0, 6) : productId}',
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '$quantity × ${_currencyFormat.format(price.round())} BIF',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Text(
            '${_currencyFormat.format(total.round())} BIF',
            style: AppTextStyles.priceSmall.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _OrderStepper extends StatelessWidget {
  const _OrderStepper({required this.currentStatus});
  final OrderStatus currentStatus;

  static const _steps = [
    (OrderStatus.pending, 'Commande créée'),
    (OrderStatus.confirmed, 'Confirmée boutique'),
    (OrderStatus.shipped, 'En livraison'),
    (OrderStatus.delivered, 'Livrée'),
  ];

  @override
  Widget build(BuildContext context) {
    var currentIndex = _steps.indexWhere((s) => s.$1 == currentStatus);
    if (currentIndex < 0) currentIndex = 0;
    final isCancelled = currentStatus == OrderStatus.cancelled;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGray),
      ),
      child: Column(
        children: [
          for (var i = 0; i < _steps.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StepDot(
                  isCompleted: !isCancelled && i < currentIndex,
                  isCurrent: !isCancelled && i == currentIndex,
                  isCancelled: isCancelled,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _steps[i].$2,
                        style: AppTextStyles.label.copyWith(
                          color: (!isCancelled && (i < currentIndex || i == currentIndex))
                              ? AppColors.textPrimary
                              : AppColors.textTertiary,
                          fontWeight: !isCancelled && i == currentIndex ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      if (i < _steps.length - 1) const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
            if (i < _steps.length - 1)
              Padding(
                padding: const EdgeInsets.only(left: 11, top: 4),
                child: Container(
                  width: 2,
                  height: 20,
                  decoration: BoxDecoration(
                    color: !isCancelled && i < currentIndex ? AppColors.primary : AppColors.borderGray,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.isCompleted,
    required this.isCurrent,
    required this.isCancelled,
  });
  final bool isCompleted;
  final bool isCurrent;
  final bool isCancelled;

  @override
  Widget build(BuildContext context) {
    Color color = AppColors.textTertiary;
    if (isCompleted) color = AppColors.primary;
    if (isCurrent) color = AppColors.primary;
    if (isCancelled) color = AppColors.statusCancelled;

    return SizedBox(
      width: 24,
      height: 24,
      child: isCurrent
          ? _PulsingDot(color: color)
          : Container(
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: isCompleted || isCurrent
                    ? null
                    : Border.all(color: AppColors.borderGray, width: 2),
              ),
              child: isCompleted
                  ? const Icon(Icons.check_rounded, size: 14, color: AppColors.textOnPrimary)
                  : null,
            ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot({required this.color});
  final Color color;

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.5, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: _animation.value),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.4),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      );
}
