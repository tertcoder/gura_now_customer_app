import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../bloc/admin_bloc.dart';

/// Admin screen for managing all orders.
class OrdersManagementScreen extends StatefulWidget {
  const OrdersManagementScreen({super.key});

  @override
  State<OrdersManagementScreen> createState() => _OrdersManagementScreenState();
}

class _OrdersManagementScreenState extends State<OrdersManagementScreen> {
  String _selectedStatus = 'all';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  final List<Map<String, String>> _statusFilters = [
    {'value': 'all', 'label': 'Tous'},
    {'value': 'pending', 'label': 'En attente'},
    {'value': 'confirmed', 'label': 'Confirmé'},
    {'value': 'shipped', 'label': 'En cours'},
    {'value': 'delivered', 'label': 'Livré'},
    {'value': 'cancelled', 'label': 'Annulé'},
  ];

  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(const AdminOrdersRequested());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      appBar: AppBar(
        title: const Text('Gestion des Commandes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<AdminBloc>().add(AdminOrdersRequested(status: _selectedStatus == 'all' ? null : _selectedStatus)),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(
                bottom: BorderSide(color: AppColors.borderGray),
              ),
            ),
            child: Column(
              children: [
                AppSearchField(
                  controller: _searchController,
                  hint: 'Rechercher par numéro ou client...',
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                  onClear: () {
                    setState(() => _searchQuery = '');
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _statusFilters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final filter = _statusFilters[index];
                      final isSelected = _selectedStatus == filter['value'];
                      return FilterChip(
                        label: Text(filter['label']!),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedStatus = filter['value']!;
                          });
                          context.read<AdminBloc>().add(AdminOrdersRequested(status: _selectedStatus == 'all' ? null : _selectedStatus));
                        },
                        backgroundColor: AppColors.surfaceContainer,
                        selectedColor: AppColors.accent.withValues(alpha: 0.2),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? AppColors.accent
                              : AppColors.textSecondary,
                        ),
                        side: BorderSide.none,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<AdminBloc, AdminState>(
              builder: (context, state) {
                switch (state.ordersStatus) {
                  case AdminListStatus.loading:
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.accent),
                    );
                  case AdminListStatus.failure:
                    return EmptyState.error(
                      message: state.ordersError ?? 'Erreur',
                      onRetry: () => context.read<AdminBloc>().add(const AdminOrdersRequested()),
                    );
                  case AdminListStatus.success:
                    final orders = state.orders
                        .map((e) => e as Map<String, dynamic>)
                        .toList();
                    final filteredOrders = _filterOrders(orders);

                    if (filteredOrders.isEmpty) {
                      return EmptyState.search(query: _searchQuery);
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<AdminBloc>().add(AdminOrdersRequested(status: _selectedStatus == 'all' ? null : _selectedStatus));
                      },
                      color: AppColors.accent,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredOrders.length,
                        itemBuilder: (context, index) {
                          final order = filteredOrders[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _OrderCard(
                              order: order,
                              currencyFormat: currencyFormat,
                              onTap: () => _showOrderDetail(context, order),
                            ),
                          );
                        },
                      ),
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _filterOrders(List<Map<String, dynamic>> orders) =>
      orders.where((order) {
        if (_selectedStatus != 'all' && order['status'] != _selectedStatus) {
          return false;
        }
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          final orderNumber =
              (order['order_number'] as String? ?? '').toLowerCase();
          final customerName =
              (order['customer_name'] as String? ?? '').toLowerCase();
          return orderNumber.contains(query) || customerName.contains(query);
        }
        return true;
      }).toList();

  void _showOrderDetail(BuildContext context, Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _OrderDetailModal(order: order),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
    required this.currencyFormat,
    required this.onTap,
  });
  final Map<String, dynamic> order;
  final NumberFormat currencyFormat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final total = (order['total_amount'] as num?)?.toDouble() ?? 0;
    final itemCount = order['item_count'] as int? ?? 0;

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['order_number'] as String? ?? '',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order['customer_name'] as String? ?? '',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge.fromStatus(order['status'] as String? ?? 'pending'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _InfoItem(
                icon: Icons.store,
                label: order['shop_name'] as String? ?? '',
              ),
              const SizedBox(width: 16),
              _InfoItem(
                icon: Icons.shopping_bag,
                label: '$itemCount article${itemCount > 1 ? 's' : ''}',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                _formatDate(order['created_at'] as String?),
                style: const TextStyle(
                  color: AppColors.textDisabled,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Text(
                '${currencyFormat.format(total)} BIF',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (_) {
      return '';
    }
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.label,
  });
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      );
}

class _OrderDetailModal extends StatelessWidget {
  const _OrderDetailModal({required this.order});
  final Map<String, dynamic> order;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'fr_BI',
      symbol: '',
      decimalDigits: 0,
    );
    final total = (order['total_amount'] as num?)?.toDouble() ?? 0;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderGray,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['order_number'] as String? ?? '',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    StatusBadge.fromStatus(
                        order['status'] as String? ?? 'pending'),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.borderGray),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle('Client'),
                  const SizedBox(height: 8),
                  _DetailRow('Nom', order['customer_name'] as String? ?? ''),
                  _DetailRow(
                      'Téléphone', order['customer_phone'] as String? ?? ''),
                  _DetailRow(
                      'Adresse', order['delivery_address'] as String? ?? ''),
                  const SizedBox(height: 20),
                  const _SectionTitle('Boutique'),
                  const SizedBox(height: 8),
                  _DetailRow('Nom', order['shop_name'] as String? ?? ''),
                  const SizedBox(height: 20),
                  const _SectionTitle('Détails'),
                  const SizedBox(height: 8),
                  _DetailRow('Articles', '${order['item_count']}'),
                  _DetailRow('Sous-total',
                      '${currencyFormat.format(total - 2000)} BIF'),
                  const _DetailRow('Livraison', '2,000 BIF'),
                  _DetailRow('Total', '${currencyFormat.format(total)} BIF',
                      isBold: true),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  if (order['status'] == 'pending') ...[
                    Expanded(
                      child: AppButton(
                        label: 'Annuler',
                        isOutlined: true,
                        backgroundColor: AppColors.danger,
                        foregroundColor: AppColors.danger,
                        onPressed: () {
                          // TODO: Cancel order
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: AppButton(
                      label: 'Voir détails',
                      onPressed: () {
                        Navigator.pop(context);
                        // TODO: Navigate to full order detail
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value, {this.isBold = false});
  final String label;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      );
}
