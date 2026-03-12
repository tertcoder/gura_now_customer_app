import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/auth_bloc.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0A0A0A),
                Color(0xFF0F0F0F),
                Color(0xFF0A0A0A),
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Background decorative elements
                Positioned(
                  top: -80,
                  right: -80,
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.guraRed.withValues(alpha: 0.12),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  left: -60,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.guraOrange.withValues(alpha: 0.08),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 150,
                  right: -40,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.guraBlue.withValues(alpha: 0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Main content
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Spacer(flex: 2),

                      // Image placeholder area with cards
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: _WelcomeImageSection(),
                        ),
                      ),

                      const Spacer(flex: 2),

                      // Welcome text
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            children: [
                              Text(
                                'Bienvenue!',
                                style: AppTextStyles.heading1.copyWith(
                                  fontSize: 36,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Connectez-vous pour continuer\nou créez un nouveau compte.',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(flex: 1),

                      // Buttons — "Se Connecter" primary first, "Créer un compte" outlined
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            children: [
                              // Se Connecter (primary red, full-width)
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: AppColors.gradientPrimary,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.guraRed
                                            .withValues(alpha: 0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context.read<AuthBloc>().add(
                                            const AuthSkipLoginRequested(),
                                          );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: Text(
                                      'Se connecter',
                                      style: AppTextStyles.button.copyWith(
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Créer un compte (outlined red, full-width)
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: OutlinedButton(
                                  onPressed: () => context.push('/register'),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    'Créer un compte',
                                    style: AppTextStyles.button.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Terms
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          'En continuant, vous acceptez nos Conditions\nd\'utilisation et Politique de confidentialité',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textDisabled,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _WelcomeImageSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SizedBox(
        height: 280,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Back card (tilted left)
            Positioned(
              left: 20,
              child: Transform.rotate(
                angle: -0.15,
                child: _ImageCard(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.guraOrange.withValues(alpha: 0.3),
                      AppColors.guraOrange.withValues(alpha: 0.1),
                    ],
                  ),
                  size: 160,
                ),
              ),
            ),

            // Back card (tilted right)
            Positioned(
              right: 20,
              child: Transform.rotate(
                angle: 0.15,
                child: _ImageCard(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.guraBlue.withValues(alpha: 0.3),
                      AppColors.guraBlue.withValues(alpha: 0.1),
                    ],
                  ),
                  size: 160,
                ),
              ),
            ),

            // Front card (center)
            _ImageCard(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.guraRed.withValues(alpha: 0.2),
                  AppColors.surface,
                ],
              ),
              size: 200,
              isMain: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // TODO: Replace with actual welcome image
                  // Image should be: Happy customer with shopping bags
                  // or a collage of Burundian products/marketplace
                  Image.asset(
                    AppAssets.logoIconColor,
                    width: 80,
                    height: 80,
                  ),
                  // const SizedBox(height: 16),
                  // Container(
                  //   padding:
                  //       const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  //   decoration: BoxDecoration(
                  //     gradient: AppColors.gradientPrimary,
                  //     borderRadius: BorderRadius.circular(20),
                  //   ),
                  //   child: Text(
                  //     'GURA NOW',
                  //     style: AppTextStyles.labelSmall.copyWith(
                  //       color: AppColors.white,
                  //       fontWeight: FontWeight.w700,
                  //       letterSpacing: 1.5,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _ImageCard extends StatelessWidget {
  const _ImageCard({
    required this.gradient,
    required this.size,
    this.isMain = false,
    this.child,
  });

  final Gradient gradient;
  final double size;
  final bool isMain;
  final Widget? child;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isMain
                ? AppColors.borderLight.withValues(alpha: 0.5)
                : AppColors.borderGray.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: isMain
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: child,
      );
}
