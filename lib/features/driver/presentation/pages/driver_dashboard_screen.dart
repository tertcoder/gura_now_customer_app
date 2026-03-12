import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/delivery.dart';
import '../bloc/driver_bloc.dart';

/// Driver dashboard screen with stats, availability toggle, and delivery list.
class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DriverBloc>()
      ..add(const DriverStatsRequested())
      ..add(const DriverAvailableDeliveriesRequested());
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'fr_BI',
      symbol: '',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<DriverBloc, DriverState>(
          listenWhen: (a, b) => a.actionStatus != b.actionStatus,
          listener: (context, state) {
            if (state.actionStatus == DriverActionStatus.success) {
              context.read<DriverBloc>().add(const DriverAvailableDeliveriesRequested());
            }
          },
          builder: (context, state) {
            final isOnline = state.isOnline;
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bonjour, Livreur',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Tableau de bord',
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _OnlineToggle(
                              isOnline: isOnline,
                              onChanged: (value) {
                                context.read<DriverBloc>().add(DriverOnlineChanged(value));
                                if (value) {
                                  context.read<DriverBloc>()
                                    ..add(const DriverAvailableDeliveriesRequested())
                                    ..add(const DriverStatsRequested());
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildStats(state, currencyFormat),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
                    child: Text(
                      'Livraisons disponibles',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                _buildDeliveriesList(context, state, currencyFormat),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStats(DriverState state, NumberFormat currencyFormat) {
    switch (state.statsStatus) {
      case DriverListStatus.loading:
        return _StatsGridSkeleton();
      case DriverListStatus.success:
        final stats = state.stats;
        if (stats == null) return const SizedBox.shrink();
        return _StatsGrid(stats: stats, currencyFormat: currencyFormat);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildDeliveriesList(
    BuildContext context,
    DriverState state,
    NumberFormat currencyFormat,
  ) {
    switch (state.availableStatus) {
      case DriverListStatus.loading:
        return const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          ),
        );
      case DriverListStatus.failure:
        return SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyState.error(
            message: state.availableError ?? 'Erreur',
            onRetry: () => context.read<DriverBloc>().add(const DriverAvailableDeliveriesRequested()),
          ),
        );
      case DriverListStatus.success:
        final items = state.availableDeliveries;
        if (items.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyState.deliveries(),
          );
        }
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final delivery = items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _DeliveryCard(
                    delivery: delivery,
                    currencyFormat: currencyFormat,
                    onAccept: () {
                      context.read<DriverBloc>().add(DriverAcceptDeliveryRequested(delivery.id));
                      context.push('/driver/delivery/${delivery.id}');
                    },
                  ),
                );
              },
              childCount: items.length,
            ),
          ),
        );
      default:
        return const SliverFillRemaining(hasScrollBody: false, child: SizedBox.shrink());
    }
  }
}

class _OnlineToggle extends StatelessWidget {
  const _OnlineToggle({
    required this.isOnline,
    required this.onChanged,
  });
  final bool isOnline;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => onChanged(!isOnline),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isOnline
                ? AppColors.success.withValues(alpha: 0.15)
                : AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isOnline ? AppColors.success : AppColors.borderGray,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: isOnline ? AppColors.success : AppColors.textSecondary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isOnline ? 'En ligne' : 'Hors ligne',
                style: TextStyle(
                  color: isOnline ? AppColors.success : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({
    required this.stats,
    required this.currencyFormat,
  });
  final DriverStats stats;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.delivery_dining,
              label: 'Total',
              value: '${stats.totalDeliveries}',
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.attach_money,
              label: 'Gains Aujourd\'hui',
              value: '${currencyFormat.format(stats.earningsToday)} BIF',
              color: AppColors.accentGold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.star,
              label: 'Note',
              value: stats.averageRating.toStringAsFixed(1),
              color: AppColors.accentPurple,
            ),
          ),
        ],
      );
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
}

class _StatsGridSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Row(
        children: [
          Expanded(child: ShimmerLoading(height: 100)),
          SizedBox(width: 12),
          Expanded(child: ShimmerLoading(height: 100)),
          SizedBox(width: 12),
          Expanded(child: ShimmerLoading(height: 100)),
        ],
      );
}

class _DeliveryCard extends StatelessWidget {
  const _DeliveryCard({
    required this.delivery,
    required this.currencyFormat,
    required this.onAccept,
  });
  final Delivery delivery;
  final NumberFormat currencyFormat;
  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.store,
                    color: AppColors.accent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        delivery.shopName ?? 'Shop',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${(delivery.estimatedDistanceKm ?? 0).toStringAsFixed(1)} km',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accentGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${currencyFormat.format(delivery.deliveryFee)} BIF',
                    style: const TextStyle(
                      color: AppColors.accentGold,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _AddressRow(
              icon: Icons.store,
              color: AppColors.accent,
              label: 'Pickup',
              address: delivery.pickupAddress,
            ),
            Container(
              margin: const EdgeInsets.only(left: 11),
              width: 2,
              height: 20,
              color: AppColors.borderGray,
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'Accepter',
              onPressed: onAccept,
              icon: Icons.check,
            ),
          ],
        ),
      );
}

class _AddressRow extends StatelessWidget {
  const _AddressRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.address,
  });
  final IconData icon;
  final Color color;
  final String label;
  final String address;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                Text(
                  address,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      );
}
