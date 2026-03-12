import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/order_card.dart';
import '../../../orders/domain/entities/order.dart';
import '../../../orders/presentation/bloc/order_bloc.dart';

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      buildWhen: (prev, next) =>
          prev.listStatus != next.listStatus || prev.orders != next.orders,
      builder: (context, state) {
        if (state.listStatus == OrderListStatus.initial) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<OrderBloc>().add(const OrderListRequested());
          });
        }
        if (state.listStatus == OrderListStatus.loading) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              title: const Text('Tableau de Bord'),
              backgroundColor: AppColors.white,
              elevation: 0,
            ),
            body: const Center(
                child: CircularProgressIndicator(color: AppColors.black)),
          );
        }
        if (state.listStatus == OrderListStatus.failure) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              title: const Text('Tableau de Bord'),
              backgroundColor: AppColors.white,
              elevation: 0,
            ),
            body: Center(child: Text('Erreur: ${state.listError}')),
          );
        }
        final orders = state.orders;
        return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Tableau de Bord'),
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.black),
            onPressed: () {},
          )
        ],
      ),
      body: _buildBody(context, orders),
    );
      },
    );
  }

  Widget _buildBody(BuildContext context, List<Order> orders) {
    final totalOrders = orders.length;
    final pendingOrders =
        orders.where((o) => o.status == OrderStatus.pending).toList();
    final pendingCount = pendingOrders.length;
    final revenue = orders
        .where((o) =>
            o.status == OrderStatus.delivered ||
            o.status == OrderStatus.confirmed)
        .fold(0.0, (sum, order) => sum + order.total);

    return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true, // Vital for nesting in ScrollView
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.4,
                  children: [
                    _StatCard(
                      label: 'Total Commandes',
                      value: '$totalOrders',
                      icon: Icons.shopping_bag,
                      color: Colors.blue,
                    ),
                    _StatCard(
                      label: 'En Attente',
                      value: '$pendingCount',
                      icon: Icons.hourglass_empty,
                      color: AppColors.warning,
                      isHighlighted: pendingCount > 0,
                    ),
                    _StatCard(
                      label: 'Ventes Totales',
                      value: revenue.toStringAsFixed(0), // Shorten?
                      suffix: ' Fbu',
                      icon: Icons.monetization_on,
                      color: const Color(0xFF27AE60),
                      fullWidth: true, // Custom logic needed or just span 2?
                      // GridView fixed count makes conditional span hard.
                      // For now, simple card.
                    ),
                    const _StatCard(
                      label: 'Produits',
                      value: '12', // Mock, need product provider
                      icon: Icons.inventory_2,
                      color: Colors.purple,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Pending Orders Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Commandes en attente',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    TextButton(
                      onPressed: () => context.go('/orders'), // Go to full list
                      child: const Text('Voir tout'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (pendingOrders.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Aucune commande en attente'),
                  )
                else
                  ...pendingOrders.take(5).map((order) => OrderCard(
                        order: order,
                        onTap: () => context.push('/order/${order.id}'),
                      )),
              ],
            ),
          );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    this.suffix,
    required this.icon,
    required this.color,
    this.isHighlighted = false,
    this.fullWidth = false,
  });
  final String label;
  final String value;
  final String? suffix;
  final IconData icon;
  final Color color;
  final bool isHighlighted;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isHighlighted ? color.withOpacity(0.1) : AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border:
              Border.all(color: isHighlighted ? color : AppColors.lightGray),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const Spacer(),
            Text(
              value + (suffix ?? ''),
              style: AppTextStyles.heading2.copyWith(fontSize: 24),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(label,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.darkGray)),
          ],
        ),
      );
}
