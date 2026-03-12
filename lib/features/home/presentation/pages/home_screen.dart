import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../shop/domain/entities/shop.dart';
import '../../../shop/presentation/bloc/shop_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'Tout';
  String _searchQuery = '';

  final List<String> _categories = [
    'Tout',
    'Mode',
    'Électronique',
    'Alimentation',
    'Beauté',
    'Maison',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterShops(String query) {
    setState(() => _searchQuery = query.toLowerCase());
  }

  void _selectCategory(String category) {
    setState(() => _selectedCategory = category);
    // Filter by category
    if (category == 'Tout') {
      context.read<ShopBloc>().add(const ShopCategoryFilterChanged(null));
    } else {
      context.read<ShopBloc>().add(ShopCategoryFilterChanged(category));
    }
  }

  List<Shop> _filterShopsBySearch(List<Shop> shops) {
    if (_searchQuery.isEmpty) {
      return shops;
    }
    return shops
        .where((shop) =>
            shop.name.toLowerCase().contains(_searchQuery) ||
            shop.type.toLowerCase().contains(_searchQuery))
        .toList();
  }

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
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<ShopBloc>().add(const ShopListRequested());
                },
                color: AppColors.primary,
                backgroundColor: AppColors.surface,
                child: CustomScrollView(
                  slivers: [
                    // Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bienvenue sur',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  ShaderMask(
                                    shaderCallback: (bounds) =>
                                        AppColors.gradientPrimary
                                            .createShader(bounds),
                                    child: Text(
                                      'Gura Now',
                                      style: AppTextStyles.heading1.copyWith(
                                        color: Colors.white,
                                        fontSize: 32,
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
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        child: AppSearchField(
                          hint: 'Rechercher une boutique...',
                          controller: _searchController,
                          onChanged: _filterShops,
                        ),
                      ),
                    ),

                    // Featured Shops Banner
                    if (state.listStatus == ShopListStatus.success &&
                        state.shops.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _FeaturedShopsBanner(
                            shops: state.shops.take(3).toList(),
                          ),
                        ),
                      ),

                    // Promo Banner
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        child: _PromoBanner(),
                      ),
                    ),

                    // Categories
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: _CategoryChip(
                                label: category,
                                isSelected: _selectedCategory == category,
                                onTap: () => _selectCategory(category),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Section Title
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Boutiques populaires',
                              style: AppTextStyles.heading4,
                            ),
                            GestureDetector(
                              onTap: () {
                                // TODO: Navigate to all shops
                              },
                              child: Text(
                                'Voir tout',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Shop Grid
                    _shopGridSliver(context, state),

                    // Bottom padding for nav bar
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 100),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );

  Widget _shopGridSliver(BuildContext context, ShopState state) {
    if (state.listStatus == ShopListStatus.loading) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 16),
              Text(
                'Chargement des boutiques...',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state.listStatus == ShopListStatus.failure) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyState.error(
          message: state.listError ?? 'Erreur de chargement',
          onRetry: () =>
              context.read<ShopBloc>().add(const ShopListRequested()),
        ),
      );
    }

    final shops = _filterShopsBySearch(state.filteredShops);
    if (shops.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyState(
          icon: Icons.search_off_rounded,
          title: 'Aucune boutique trouvée',
          subtitle: _searchController.text.isNotEmpty
              ? 'Essayez de modifier votre recherche'
              : 'Aucune boutique disponible pour le moment',
        ),
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

/// Featured shops carousel banner
class _FeaturedShopsBanner extends StatelessWidget {
  const _FeaturedShopsBanner({required this.shops});

  final List<Shop> shops;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: shops.length,
          itemBuilder: (context, index) {
            final shop = shops[index];
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _FeaturedShopCard(
                shop: shop,
                onTap: () => context.push('/shop/${shop.id}', extra: shop),
              ),
            );
          },
        ),
      );
}

/// Featured shop hero card with gradient overlay
class _FeaturedShopCard extends StatelessWidget {
  const _FeaturedShopCard({
    required this.shop,
    required this.onTap,
  });

  final Shop shop;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 320,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: AppColors.gradientPrimary,
            boxShadow: [
              BoxShadow(
                color: AppColors.guraRed.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'POPULAIRE',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),

                    // Shop info
                    Text(
                      shop.name,
                      style: AppTextStyles.heading4.copyWith(
                        color: AppColors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: AppColors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            shop.deliveryScope ?? 'Bujumbura',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.white.withValues(alpha: 0.9),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Explorer',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: AppColors.primary,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

/// Promotional banner card
class _PromoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        height: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.guraOrange.withValues(alpha: 0.2),
              AppColors.guraRed.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.guraOrange.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.guraOrange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.local_offer_rounded,
                color: AppColors.guraOrange,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Offres Spéciales',
                    style: AppTextStyles.heading5.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Jusqu\'à -30% sur vos commandes',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.guraOrange.withValues(alpha: 0.5),
              size: 18,
            ),
          ],
        ),
      );
}

/// Category filter chip
class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.gradientPrimary : null,
            color: isSelected ? null : AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(20),
            border: isSelected
                ? null
                : Border.all(
                    color: AppColors.borderGray,
                  ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.guraRed.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: isSelected ? AppColors.white : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      );
}
