import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/order.dart';
import '../bloc/order_bloc.dart';

class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});

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
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: Text('Mes Commandes', style: AppTextStyles.heading2),
              centerTitle: true,
              backgroundColor: AppColors.background,
              elevation: 0,
              foregroundColor: AppColors.textPrimary,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => context.go('/home'),
              ),
              bottom: TabBar(
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelStyle: AppTextStyles.label,
                tabs: const [
                  Tab(text: 'En cours'),
                  Tab(text: 'Historique'),
                ],
              ),
            ),
            body: _body(context, state),
          ),
        );
      },
    );
  }

  Widget _body(BuildContext context, OrderState state) {
    if (state.listStatus == OrderListStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (state.listStatus == OrderListStatus.failure) {
      return EmptyState.error(
        message: state.listError ?? 'Erreur de chargement',
        onRetry: () => context.read<OrderBloc>().add(const OrderListRequested()),
      );
    }
    return TabBarView(
      children: [
        _OrderListView(
          orders: state.activeOrders,
          onRefresh: () => context.read<OrderBloc>().add(const OrderListRequested()),
        ),
        _OrderListView(
          orders: state.historyOrders,
          onRefresh: () => context.read<OrderBloc>().add(const OrderListRequested()),
        ),
      ],
    );
  }
}

class _OrderListView extends StatelessWidget {
  const _OrderListView({
    required this.orders,
    required this.onRefresh,
  });
  final List<Order> orders;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return EmptyState.orders(onBrowse: () => context.go('/home'));
    }
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return OrderCard(
            order: order,
            onTap: () => context.push('/order/${order.id}'),
          );
        },
      ),
    );
  }
}
