import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'app_button.dart';

/// A widget for displaying empty states with an icon, title, and optional action.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.iconSize = 80,
  });

  /// Empty cart state.
  factory EmptyState.cart({VoidCallback? onBrowse}) {
    return EmptyState(
      icon: Icons.shopping_cart_outlined,
      title: 'Votre panier est vide',
      subtitle: 'Parcourez nos produits et ajoutez-les à votre panier',
      actionLabel: 'Parcourir',
      onAction: onBrowse,
    );
  }

  /// No orders state.
  factory EmptyState.orders({VoidCallback? onBrowse}) {
    return EmptyState(
      icon: Icons.receipt_long_outlined,
      title: 'Aucune commande',
      subtitle: 'Vos commandes apparaîtront ici',
      actionLabel: 'Commander',
      onAction: onBrowse,
    );
  }

  /// No products state.
  factory EmptyState.products({VoidCallback? onAdd}) {
    return EmptyState(
      icon: Icons.inventory_2_outlined,
      title: 'Aucun produit',
      subtitle: 'Ajoutez des produits à votre boutique',
      actionLabel: 'Ajouter',
      onAction: onAdd,
    );
  }

  /// No notifications state.
  factory EmptyState.notifications() {
    return const EmptyState(
      icon: Icons.notifications_off_outlined,
      title: 'Aucune notification',
      subtitle: 'Vous n\'avez pas de nouvelles notifications',
    );
  }

  /// No search results state.
  factory EmptyState.search({String? query}) {
    return EmptyState(
      icon: Icons.search_off,
      title: 'Aucun résultat',
      subtitle: query != null
          ? 'Aucun résultat pour "$query"'
          : 'Aucun résultat trouvé',
    );
  }

  /// No deliveries state.
  factory EmptyState.deliveries() {
    return const EmptyState(
      icon: Icons.delivery_dining_outlined,
      title: 'Aucune livraison',
      subtitle: 'Les livraisons disponibles apparaîtront ici',
    );
  }

  /// Error state.
  factory EmptyState.error({String? message, VoidCallback? onRetry}) {
    return EmptyState(
      icon: Icons.error_outline,
      title: 'Une erreur est survenue',
      subtitle: message ?? 'Veuillez réessayer',
      actionLabel: 'Réessayer',
      onAction: onRetry,
    );
  }
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final double iconSize;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: iconSize,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 24),
                AppButton(
                  label: actionLabel!,
                  onPressed: onAction,
                  isFullWidth: false,
                ),
              ],
            ],
          ),
        ),
      );
}
