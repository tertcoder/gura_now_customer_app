import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../bloc/admin_bloc.dart';

/// Admin screen for managing shops.
class ShopsManagementScreen extends StatefulWidget {
  const ShopsManagementScreen({super.key});

  @override
  State<ShopsManagementScreen> createState() => _ShopsManagementScreenState();
}

class _ShopsManagementScreenState extends State<ShopsManagementScreen> {
  String? _selectedStatus;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(const AdminShopsRequested());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Gestion des Boutiques'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<AdminBloc>().add(AdminShopsRequested(status: _selectedStatus, search: _searchQuery.isEmpty ? null : _searchQuery)),
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
                  hint: 'Rechercher...',
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                    context.read<AdminBloc>().add(AdminShopsRequested(status: _selectedStatus, search: value.isEmpty ? null : value));
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _FilterChip(
                        label: 'Tous',
                        isSelected: _selectedStatus == null,
                        onTap: () {
                          setState(() => _selectedStatus = null);
                          context.read<AdminBloc>().add(AdminShopsRequested(search: _searchQuery.isEmpty ? null : _searchQuery));
                        },
                      ),
                      _FilterChip(
                        label: 'Actif',
                        isSelected: _selectedStatus == 'active',
                        onTap: () {
                          setState(() => _selectedStatus = 'active');
                          context.read<AdminBloc>().add(AdminShopsRequested(status: 'active', search: _searchQuery.isEmpty ? null : _searchQuery));
                        },
                      ),
                      _FilterChip(
                        label: 'En attente',
                        isSelected: _selectedStatus == 'pending',
                        onTap: () {
                          setState(() => _selectedStatus = 'pending');
                          context.read<AdminBloc>().add(AdminShopsRequested(status: 'pending', search: _searchQuery.isEmpty ? null : _searchQuery));
                        },
                      ),
                      _FilterChip(
                        label: 'Suspendu',
                        isSelected: _selectedStatus == 'suspended',
                        onTap: () {
                          setState(() => _selectedStatus = 'suspended');
                          context.read<AdminBloc>().add(AdminShopsRequested(status: 'suspended', search: _searchQuery.isEmpty ? null : _searchQuery));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<AdminBloc, AdminState>(
              builder: (context, state) {
                switch (state.shopsStatus) {
                  case AdminListStatus.loading:
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.accent),
                    );
                  case AdminListStatus.failure:
                    return EmptyState.error(
                      message: state.shopsError ?? 'Erreur',
                      onRetry: () => context.read<AdminBloc>().add(const AdminShopsRequested()),
                    );
                  case AdminListStatus.success:
                    final shops = state.shops
                        .map((e) => e as Map<String, dynamic>)
                        .toList();
                    final filtered = _filterShops(shops);
                    if (filtered.isEmpty) {
                      return EmptyState.search(query: _searchQuery);
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<AdminBloc>().add(AdminShopsRequested(status: _selectedStatus, search: _searchQuery.isEmpty ? null : _searchQuery));
                      },
                      color: AppColors.accent,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final shop = filtered[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _ShopCard(shop: shop),
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

  List<Map<String, dynamic>> _filterShops(List<Map<String, dynamic>> shops) =>
      shops.where((shop) {
        if (_selectedStatus != null && shop['status'] != _selectedStatus) {
          return false;
        }
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          final name = (shop['name'] as String? ?? '').toLowerCase();
          final owner = (shop['owner_name'] as String? ?? '').toLowerCase();
          return name.contains(query) || owner.contains(query);
        }
        return true;
      }).toList();
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: FilterChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (_) => onTap(),
          backgroundColor: AppColors.surfaceContainer,
          selectedColor: AppColors.accent.withValues(alpha: 0.2),
          labelStyle: TextStyle(
            color: isSelected ? AppColors.accent : AppColors.textSecondary,
          ),
          side: BorderSide.none,
        ),
      );
}

class _ShopCard extends StatelessWidget {
  const _ShopCard({required this.shop});
  final Map<String, dynamic> shop;

  @override
  Widget build(BuildContext context) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.store, color: AppColors.accent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shop['name'] as String? ?? '',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        shop['owner_name'] as String? ?? '',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadge.fromStatus(shop['status'] as String? ?? 'pending'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _InfoItem(
                  icon: Icons.category,
                  label: shop['category'] as String? ?? '',
                ),
                const SizedBox(width: 16),
                _InfoItem(
                  icon: Icons.inventory_2,
                  label: '${shop['total_products']} produits',
                ),
                const SizedBox(width: 16),
                _InfoItem(
                  icon: Icons.star,
                  label:
                      '${(shop['rating'] as num?)?.toStringAsFixed(1) ?? '0.0'}',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Voir',
                    onPressed: () {
                      // TODO: View shop details
                    },
                    isOutlined: true,
                  ),
                ),
                const SizedBox(width: 12),
                if (shop['status'] == 'pending')
                  Expanded(
                    child: AppButton(
                      label: 'Approuver',
                      onPressed: () {
                        final shopId = shop['id'] as String?;
                        if (shopId != null) {
                          context.read<AdminBloc>().add(AdminShopStatusUpdated(shopId, 'active'));
                        }
                      },
                      backgroundColor: AppColors.success,
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
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
              fontSize: 12,
            ),
          ),
        ],
      );
}
