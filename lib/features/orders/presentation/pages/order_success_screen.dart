import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.success.withValues(alpha: 0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.success.withValues(alpha: 0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 48,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Commande confirmée !',
                  style: AppTextStyles.heading1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Votre commande a été créée avec succès.',
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'N° #GN-${orderId.length >= 8 ? orderId.substring(0, 8).toUpperCase() : orderId.toUpperCase()}',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
                ),
                const SizedBox(height: 48),
                CustomButton(
                  text: 'Voir la commande',
                  backgroundColor: AppColors.primary,
                  onPressed: () => context.go('/order/$orderId'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.go('/home'),
                  child: Text(
                    'Retour à l\'accueil',
                    style: AppTextStyles.button.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
