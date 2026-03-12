import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/platform_stats.dart';
import '../bloc/admin_bloc.dart';

/// Superadmin dashboard screen with platform-wide statistics.
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(const AdminStatsRequested());
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'fr_BI',
      symbol: 'BIF ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<AdminBloc>().add(const AdminStatsRequested()),
          ),
        ],
      ),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          switch (state.statsStatus) {
            case AdminListStatus.loading:
              return const Center(
                child: CircularProgressIndicator(color: AppColors.black),
              );
            case AdminListStatus.failure:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                    const SizedBox(height: 16),
                    Text('Erreur: ${state.statsError}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<AdminBloc>().add(const AdminStatsRequested()),
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              );
            case AdminListStatus.success:
              final stats = state.stats;
              if (stats == null) {
                return const Center(child: Text('Aucune statistique disponible'));
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<AdminBloc>().add(const AdminStatsRequested());
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Vue d\'ensemble',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _QuickStatsGrid(
                        stats: stats,
                        currencyFormat: currencyFormat,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Revenus',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _RevenueCards(
                        stats: stats,
                        currencyFormat: currencyFormat,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Commandes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _OrdersGrid(stats: stats),
                      const SizedBox(height: 24),
                      const Text(
                        'Actions rapides',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _QuickActionsGrid(context: context),
                    ],
                  ),
                ),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class _QuickStatsGrid extends StatelessWidget {
  const _QuickStatsGrid({
    required this.stats,
    required this.currencyFormat,
  });
  final PlatformStats stats;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
        children: [
          _StatCard(
            label: 'Utilisateurs',
            value: '${stats.totalUsers}',
            subtitle: '+${stats.newUsersToday} aujourd\'hui',
            icon: Icons.people,
            color: Colors.blue,
          ),
          _StatCard(
            label: 'Boutiques',
            value: '${stats.totalShops}',
            subtitle: '${stats.pendingShops} en attente',
            icon: Icons.store,
            color: Colors.green,
            isHighlighted: stats.pendingShops > 0,
          ),
          _StatCard(
            label: 'Produits',
            value: '${stats.totalProducts}',
            subtitle: '${stats.activeProducts} actifs',
            icon: Icons.inventory_2,
            color: Colors.purple,
          ),
          _StatCard(
            label: 'Livreurs',
            value: '${stats.totalDrivers}',
            subtitle: 'actifs',
            icon: Icons.delivery_dining,
            color: Colors.orange,
          ),
        ],
      );
}

class _RevenueCards extends StatelessWidget {
  const _RevenueCards({
    required this.stats,
    required this.currencyFormat,
  });
  final PlatformStats stats;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Revenus Total',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currencyFormat.format(stats.totalRevenue),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _MiniStat(
                      label: 'Aujourd\'hui',
                      value: currencyFormat.format(stats.revenueToday),
                    ),
                    _MiniStat(
                      label: 'Cette semaine',
                      value: currencyFormat.format(stats.revenueThisWeek),
                    ),
                    _MiniStat(
                      label: 'Ce mois',
                      value: currencyFormat.format(stats.revenueThisMonth),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Commissions',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currencyFormat.format(stats.totalCommissions),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF27AE60),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Payouts en attente',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currencyFormat.format(stats.pendingPayouts),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
  });
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
}

class _OrdersGrid extends StatelessWidget {
  const _OrdersGrid({required this.stats});
  final PlatformStats stats;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _OrderStat(
                  label: 'Total',
                  value: stats.totalOrders,
                  color: Colors.blue,
                ),
                _OrderStat(
                  label: 'Aujourd\'hui',
                  value: stats.ordersToday,
                  color: Colors.green,
                ),
                _OrderStat(
                  label: 'Cette semaine',
                  value: stats.ordersThisWeek,
                  color: Colors.purple,
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _OrderStat(
                  label: 'En attente',
                  value: stats.pendingOrders,
                  color: Colors.orange,
                ),
                _OrderStat(
                  label: 'En transit',
                  value: stats.inTransitOrders,
                  color: Colors.blue,
                ),
                _OrderStat(
                  label: 'Livrées',
                  value: stats.deliveredOrders,
                  color: Colors.green,
                ),
                _OrderStat(
                  label: 'Annulées',
                  value: stats.cancelledOrders,
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      );
}

class _OrderStat extends StatelessWidget {
  const _OrderStat({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(
            '$value',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
        ],
      );
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid({required this.context});
  final BuildContext context;

  @override
  Widget build(BuildContext context) => GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          _ActionButton(
            icon: Icons.people,
            label: 'Utilisateurs',
            onTap: () => context.push('/admin/users'),
          ),
          _ActionButton(
            icon: Icons.store,
            label: 'Boutiques',
            onTap: () => context.push('/admin/shops'),
          ),
          _ActionButton(
            icon: Icons.receipt_long,
            label: 'Commandes',
            onTap: () => context.push('/admin/orders'),
          ),
          _ActionButton(
            icon: Icons.account_balance_wallet,
            label: 'Transactions',
            onTap: () => context.push('/admin/transactions'),
          ),
        ],
      );
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: AppColors.black),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.color,
    this.isHighlighted = false,
  });
  final String label;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isHighlighted ? color.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHighlighted ? color : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                if (isHighlighted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTextStyles.heading2.copyWith(fontSize: 22),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
}
