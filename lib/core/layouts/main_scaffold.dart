import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/cart/presentation/bloc/cart_bloc.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({required this.child, super.key});

  final Widget child;

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _calculateSelectedIndex(BuildContext context, String role) {
    final location = GoRouterState.of(context).uri.toString();

    if (role == 'shop_owner') {
      if (location.startsWith('/dashboard')) return 0;
      if (location.startsWith('/orders')) return 1;
      if (location.startsWith('/products')) return 2;
      if (location.startsWith('/profile')) return 3;
      return 0;
    } else if (role == 'driver') {
      if (location.startsWith('/driver')) return 0;
      if (location.startsWith('/orders')) return 1;
      if (location.startsWith('/profile')) return 2;
      return 0;
    } else {
      if (location.startsWith('/home')) return 0;
      if (location.startsWith('/cart')) return 1;
      if (location.startsWith('/orders')) return 2;
      if (location.startsWith('/profile')) return 3;
      return 0;
    }
  }

  void _onItemTapped(int index, BuildContext context, String role) {
    if (role == 'shop_owner') {
      switch (index) {
        case 0:
          context.go('/dashboard');
        case 1:
          context.go('/orders');
        case 2:
          context.go('/products');
        case 3:
          context.go('/profile');
      }
    } else if (role == 'driver') {
      switch (index) {
        case 0:
          context.go('/driver-deliveries');
        case 1:
          context.go('/orders');
        case 2:
          context.go('/profile');
      }
    } else {
      switch (index) {
        case 0:
          context.go('/home');
        case 1:
          context.go('/cart');
        case 2:
          context.go('/orders');
        case 3:
          context.go('/profile');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        final cartCount = cartState.itemCount;
        return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (prev, next) => prev.user != next.user,
      builder: (context, state) {
        final role = state.user?.role ?? 'customer';
        return Scaffold(
      backgroundColor: AppColors.background,
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: const Border(
            top: BorderSide(
              color: AppColors.borderGray,
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _buildNavItems(context, role, cartCount),
            ),
          ),
        ),
      ),
    );
          },
        );
      },
    );
  }

  List<Widget> _buildNavItems(
      BuildContext context, String role, int cartCount) {
    final selectedIndex = _calculateSelectedIndex(context, role);

    if (role == 'shop_owner') {
      return [
        _NavItem(
          icon: Icons.dashboard_outlined,
          selectedIcon: Icons.dashboard,
          label: 'Dashboard',
          isSelected: selectedIndex == 0,
          onTap: () => _onItemTapped(0, context, role),
        ),
        _NavItem(
          icon: Icons.receipt_long_outlined,
          selectedIcon: Icons.receipt_long,
          label: 'Commandes',
          isSelected: selectedIndex == 1,
          onTap: () => _onItemTapped(1, context, role),
        ),
        _NavItem(
          icon: Icons.inventory_2_outlined,
          selectedIcon: Icons.inventory_2,
          label: 'Produits',
          isSelected: selectedIndex == 2,
          onTap: () => _onItemTapped(2, context, role),
        ),
        _NavItem(
          icon: Icons.person_outline,
          selectedIcon: Icons.person,
          label: 'Profil',
          isSelected: selectedIndex == 3,
          onTap: () => _onItemTapped(3, context, role),
        ),
      ];
    } else if (role == 'driver') {
      return [
        _NavItem(
          icon: Icons.delivery_dining_outlined,
          selectedIcon: Icons.delivery_dining,
          label: 'Livraisons',
          isSelected: selectedIndex == 0,
          onTap: () => _onItemTapped(0, context, role),
        ),
        _NavItem(
          icon: Icons.history_outlined,
          selectedIcon: Icons.history,
          label: 'Historique',
          isSelected: selectedIndex == 1,
          onTap: () => _onItemTapped(1, context, role),
        ),
        _NavItem(
          icon: Icons.person_outline,
          selectedIcon: Icons.person,
          label: 'Profil',
          isSelected: selectedIndex == 2,
          onTap: () => _onItemTapped(2, context, role),
        ),
      ];
    } else {
      return [
        _NavItem(
          icon: Icons.home_outlined,
          selectedIcon: Icons.home,
          label: 'Accueil',
          isSelected: selectedIndex == 0,
          onTap: () => _onItemTapped(0, context, role),
        ),
        _NavItem(
          icon: Icons.shopping_cart_outlined,
          selectedIcon: Icons.shopping_cart,
          label: 'Panier',
          isSelected: selectedIndex == 1,
          onTap: () => _onItemTapped(1, context, role),
          badge: cartCount > 0 ? cartCount : null,
        ),
        _NavItem(
          icon: Icons.receipt_long_outlined,
          selectedIcon: Icons.receipt_long,
          label: 'Commandes',
          isSelected: selectedIndex == 2,
          onTap: () => _onItemTapped(2, context, role),
        ),
        _NavItem(
          icon: Icons.person_outline,
          selectedIcon: Icons.person,
          label: 'Profil',
          isSelected: selectedIndex == 3,
          onTap: () => _onItemTapped(3, context, role),
        ),
      ];
    }
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badge,
  });
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int? badge;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.accent.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    isSelected ? selectedIcon : icon,
                    color:
                        isSelected ? AppColors.accent : AppColors.textSecondary,
                    size: 24,
                  ),
                  if (badge != null)
                    Positioned(
                      top: -6,
                      right: -10,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.danger,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          badge! > 99 ? '99+' : '$badge',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color:
                      isSelected ? AppColors.accent : AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );
}
