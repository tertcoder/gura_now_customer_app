import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Spec: Slide 1 Découvrez des boutiques, 2 Commandez facilement, 3 Livraison rapide
  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Découvrez\ndes boutiques',
      subtitle:
          'Explorez des centaines de boutiques locales et trouvez tout ce dont vous avez besoin.',
      imagePlaceholder: 'browse_shops',
      icon: Icons.store_rounded,
    ),
    OnboardingData(
      title: 'Commandez\nfacilement',
      subtitle:
          'Ajoutez vos produits au panier et passez commande en quelques clics depuis votre téléphone.',
      imagePlaceholder: 'easy_order',
      icon: Icons.shopping_cart_rounded,
    ),
    OnboardingData(
      title: 'Livraison\nrapide',
      subtitle:
          'Recevez vos commandes rapidement grâce à notre réseau de livreurs fiables.',
      imagePlaceholder: 'fast_delivery',
      icon: Icons.delivery_dining_rounded,
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _goToWelcome();
    }
  }

  void _goToWelcome() {
    context.go('/welcome');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 8),
                child: TextButton(
                  onPressed: _goToWelcome,
                  child: Text(
                    'Passer',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  return _OnboardingPage(data: _pages[index]);
                },
              ),
            ),

            // Bottom section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Page indicator - consistent primary color
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _pages.length,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: AppColors.primary,
                      dotColor: AppColors.surfaceContainer,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 4,
                      spacing: 6,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Navigation buttons
                  Row(
                    children: [
                      // Back button (hidden on first page)
                      AnimatedOpacity(
                        opacity: _currentPage > 0 ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: IconButton(
                            onPressed: _currentPage > 0
                                ? () {
                                    _pageController.previousPage(
                                      duration:
                                          const Duration(milliseconds: 400),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                : null,
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),

                      // Next/Get Started button - consistent primary gradient
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: _currentPage == _pages.length - 1 ? 220 : 56,
                        height: 56,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _nextPage,
                            borderRadius: BorderRadius.circular(16),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: AppColors.gradientPrimary,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppColors.guraRed.withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: _currentPage == _pages.length - 1
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Commencer',
                                              style: AppTextStyles.button
                                                  .copyWith(
                                                color: AppColors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Icon(
                                              Icons.arrow_forward_rounded,
                                              color: AppColors.white,
                                              size: 20,
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Suivant',
                                              style: AppTextStyles.button
                                                  .copyWith(
                                                color: AppColors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Icon(
                                              Icons.arrow_forward_rounded,
                                              color: AppColors.white,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});

  final OnboardingData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Spacer(flex: 1),

          // Image placeholder with decorative elements - consistent primary color
          Stack(
            alignment: Alignment.center,
            children: [
              // Background gradient circle
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.guraRed.withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              // Decorative shapes
              Positioned(
                top: 20,
                right: 30,
                child: _DecorativeShape(
                  color: AppColors.guraOrange,
                  size: 40,
                  rotation: 0.3,
                ),
              ),
              Positioned(
                bottom: 40,
                left: 20,
                child: _DecorativeShape(
                  color: AppColors.guraRed,
                  size: 32,
                  rotation: -0.2,
                ),
              ),

              // Main image placeholder
              // TODO: Replace with actual onboarding images
              // Image should be: ${data.imagePlaceholder}
              // Style: Modern 3D illustration or high-quality photo
              Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: AppColors.borderGray,
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          AppColors.gradientPrimary.createShader(bounds),
                      child: Icon(
                        data.icon,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Image Placeholder',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textDisabled,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Spacer(flex: 1),

          // Text content - consistent primary gradient for titles
          ShaderMask(
            shaderCallback: (bounds) =>
                AppColors.gradientPrimary.createShader(bounds),
            child: Text(
              data.title,
              style: AppTextStyles.heading1.copyWith(
                color: Colors.white,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            data.subtitle,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const Spacer(flex: 1),
        ],
      ),
    );
  }
}

class _DecorativeShape extends StatelessWidget {
  const _DecorativeShape({
    required this.color,
    required this.size,
    required this.rotation,
  });

  final Color color;
  final double size;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(size * 0.3),
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final String imagePlaceholder;
  final IconData icon;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.imagePlaceholder,
    required this.icon,
  });
}
