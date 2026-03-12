import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../bloc/admin_bloc.dart';

/// Admin screen for managing users.
class UsersManagementScreen extends StatefulWidget {
  const UsersManagementScreen({super.key});

  @override
  State<UsersManagementScreen> createState() => _UsersManagementScreenState();
}

class _UsersManagementScreenState extends State<UsersManagementScreen> {
  String? _selectedRole;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(const AdminUsersRequested());
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
        title: const Text('Gestion des Utilisateurs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<AdminBloc>().add(AdminUsersRequested(role: _selectedRole, search: _searchQuery.isEmpty ? null : _searchQuery)),
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
                    context.read<AdminBloc>().add(AdminUsersRequested(role: _selectedRole, search: value.isEmpty ? null : value));
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
                        isSelected: _selectedRole == null,
                        onTap: () {
                          setState(() => _selectedRole = null);
                          context.read<AdminBloc>().add(AdminUsersRequested(search: _searchQuery.isEmpty ? null : _searchQuery));
                        },
                      ),
                      _FilterChip(
                        label: 'Clients',
                        isSelected: _selectedRole == 'customer',
                        onTap: () {
                          setState(() => _selectedRole = 'customer');
                          context.read<AdminBloc>().add(AdminUsersRequested(role: 'customer', search: _searchQuery.isEmpty ? null : _searchQuery));
                        },
                      ),
                      _FilterChip(
                        label: 'Vendeurs',
                        isSelected: _selectedRole == 'shop_owner',
                        onTap: () {
                          setState(() => _selectedRole = 'shop_owner');
                          context.read<AdminBloc>().add(AdminUsersRequested(role: 'shop_owner', search: _searchQuery.isEmpty ? null : _searchQuery));
                        },
                      ),
                      _FilterChip(
                        label: 'Livreurs',
                        isSelected: _selectedRole == 'driver',
                        onTap: () {
                          setState(() => _selectedRole = 'driver');
                          context.read<AdminBloc>().add(AdminUsersRequested(role: 'driver', search: _searchQuery.isEmpty ? null : _searchQuery));
                        },
                      ),
                      _FilterChip(
                        label: 'Admins',
                        isSelected: _selectedRole == 'admin',
                        onTap: () {
                          setState(() => _selectedRole = 'admin');
                          context.read<AdminBloc>().add(AdminUsersRequested(role: 'admin', search: _searchQuery.isEmpty ? null : _searchQuery));
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
                switch (state.usersStatus) {
                  case AdminListStatus.loading:
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.accent),
                    );
                  case AdminListStatus.failure:
                    return EmptyState.error(
                      message: state.usersError ?? 'Erreur',
                      onRetry: () => context.read<AdminBloc>().add(const AdminUsersRequested()),
                    );
                  case AdminListStatus.success:
                    final users = state.users
                        .map((e) => e as Map<String, dynamic>)
                        .toList();
                    final filtered = _filterUsers(users);
                    if (filtered.isEmpty) {
                      return EmptyState.search(query: _searchQuery);
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<AdminBloc>().add(AdminUsersRequested(role: _selectedRole, search: _searchQuery.isEmpty ? null : _searchQuery));
                      },
                      color: AppColors.accent,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final user = filtered[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _UserCard(user: user),
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

  List<Map<String, dynamic>> _filterUsers(List<Map<String, dynamic>> users) =>
      users.where((user) {
        if (_selectedRole != null && user['role'] != _selectedRole) {
          return false;
        }
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          final name = (user['full_name'] as String? ?? '').toLowerCase();
          final phone = (user['phone_number'] as String? ?? '').toLowerCase();
          return name.contains(query) || phone.contains(query);
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

class _UserCard extends StatelessWidget {
  const _UserCard({required this.user});
  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    final role = user['role'] as String? ?? 'customer';
    final isActive = user['is_active'] as bool? ?? true;
    final isVerified = user['is_verified'] as bool? ?? false;

    return AppCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: _getRoleColor(role).withValues(alpha: 0.15),
            child: Icon(
              _getRoleIcon(role),
              color: _getRoleColor(role),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        user['full_name'] as String? ?? 'Utilisateur',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (isVerified)
                      const Icon(
                        Icons.verified,
                        size: 16,
                        color: AppColors.accent,
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  user['phone_number'] as String? ?? '',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getRoleColor(role).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _getRoleLabel(role),
                        style: TextStyle(
                          color: _getRoleColor(role),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (!isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.danger.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Suspendu',
                          style: TextStyle(
                            color: AppColors.danger,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: AppColors.textSecondary,
            ),
            color: AppColors.surface,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'view',
                child: Row(
                  children: [
                    Icon(Icons.visibility, size: 18),
                    SizedBox(width: 8),
                    Text('Voir'),
                  ],
                ),
              ),
              if (isActive)
                PopupMenuItem(
                  value: 'suspend',
                  child: Row(
                    children: [
                      const Icon(Icons.block, size: 18, color: AppColors.danger),
                      const SizedBox(width: 8),
                      const Text('Suspendre',
                          style: TextStyle(color: AppColors.danger)),
                    ],
                  ),
                )
              else
                const PopupMenuItem(
                  value: 'activate',
                  child: Row(
                    children: [
                      Icon(Icons.check_circle,
                          size: 18, color: AppColors.success),
                      SizedBox(width: 8),
                      Text('Activer',
                          style: TextStyle(color: AppColors.success)),
                    ],
                  ),
                ),
            ],
            onSelected: (value) {
              final userId = user['id'] as String?;
              if (userId == null) return;
              if (value == 'suspend') {
                context.read<AdminBloc>().add(AdminUserSuspended(userId));
              } else if (value == 'activate') {
                context.read<AdminBloc>().add(AdminUserUnsuspended(userId));
              }
            },
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
      case 'superadmin':
        return AppColors.accentPurple;
      case 'shop_owner':
        return AppColors.success;
      case 'driver':
        return AppColors.warning;
      default:
        return AppColors.accent;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'admin':
      case 'superadmin':
        return Icons.admin_panel_settings;
      case 'shop_owner':
        return Icons.store;
      case 'driver':
        return Icons.delivery_dining;
      default:
        return Icons.person;
    }
  }

  String _getRoleLabel(String role) {
    switch (role) {
      case 'admin':
        return 'Admin';
      case 'superadmin':
        return 'Super Admin';
      case 'shop_owner':
        return 'Vendeur';
      case 'driver':
        return 'Livreur';
      default:
        return 'Client';
    }
  }
}
