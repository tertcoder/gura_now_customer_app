import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../notifications/presentation/pages/notifications_screen.dart';
import '../../../shop/presentation/bloc/shop_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ShopBloc, ShopState>(
        buildWhen: (prev, next) =>
            prev.listStatus != next.listStatus || prev.shops != next.shops,
        builder: (context, state) {
          if (state.listStatus == ShopListStatus.initial) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<ShopBloc>().add(const ShopListRequested());
            });
          }
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  // Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Bienvenue sur',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                    colors: [
                                      AppColors.accent,
                                      AppColors.accentPurple
                                    ],
                                  ).createShader(bounds),
                                  child: const Text(
                                    'Gura Now',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const NotificationBadge(),
                        ],
                      ),
                    ),
                  ),

                  // Search Bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: AppSearchField(
                        hint: 'Rechercher une boutique...',
                        onChanged: (value) {
                          // TODO: Implement filtering
                        },
                      ),
                    ),
                  ),

                  // Categories
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        children: const [
                          _CategoryChip(label: 'Tout', isSelected: true),
                          _CategoryChip(label: 'Mode'),
                          _CategoryChip(label: 'Électronique'),
                          _CategoryChip(label: 'Alimentation'),
                          _CategoryChip(label: 'Beauté'),
                          _CategoryChip(label: 'Maison'),
                        ],
                      ),
                    ),
                  ),

                  // Section Title
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Boutiques populaires',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Voir tout',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Shop Grid
                  _shopGridSliver(context, state),

                  // Bottom padding
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 100),
                  ),
                ],
              ),
            ),
          );
        },
      );

  Widget _shopGridSliver(BuildContext context, ShopState state) {
    if (state.listStatus == ShopListStatus.loading) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    }
    if (state.listStatus == ShopListStatus.failure) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyState.error(
          message: state.listError ?? 'Erreur',
          onRetry: () =>
              context.read<ShopBloc>().add(const ShopListRequested()),
        ),
      );
    }
    final shops = state.filteredShops;
    if (shops.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyState.search(),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final shop = shops[index];
            return ShopCard(
              shop: shop,
              onTap: () => context.push('/shop/${shop.id}', extra: shop),
            );
          },
          childCount: shops.length,
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    this.isSelected = false,
  });
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: FilterChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (_) {
            // TODO: Implement category filter
          },
          backgroundColor: AppColors.surfaceContainer,
          selectedColor: AppColors.accent.withValues(alpha: 0.2),
          labelStyle: TextStyle(
            color: isSelected ? AppColors.accent : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
}
