import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/order_card.dart';
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
            backgroundColor: AppColors.white,
            appBar: AppBar(
              title: Text('Mes Commandes', style: AppTextStyles.heading2),
              centerTitle: true,
              backgroundColor: AppColors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.black),
                onPressed: () => context.go('/home'),
              ),
              bottom: const TabBar(
                labelColor: AppColors.black,
                unselectedLabelColor: AppColors.darkGray,
                indicatorColor: AppColors.black,
                tabs: [
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
          child: CircularProgressIndicator(color: AppColors.black));
    }
    if (state.listStatus == OrderListStatus.failure) {
      return Center(child: Text('Erreur: ${state.listError}'));
    }
    return TabBarView(
      children: [
        _OrderListView(orders: state.activeOrders),
        _OrderListView(orders: state.historyOrders),
      ],
    );
  }
}

class _OrderListView extends StatelessWidget {
  const _OrderListView({required this.orders});
  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          'Aucune commande',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkGray),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderCard(
          order: order,
          onTap: () => context.push('/order/${order.id}'),
        );
      },
    );
  }
}
