import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({
    Key? key,
    required this.orderId,
  }) : super(key: key);
  final String orderId;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.white,
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 100,
                color: Color(0xFF27AE60), // Green Success
              ),
              const SizedBox(height: 32),
              Text(
                'Commande Confirmée !',
                style: AppTextStyles.heading1.copyWith(color: AppColors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Votre commande a été créée avec succès.',
                style: AppTextStyles.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'ID: ${orderId.substring(0, 8).toUpperCase()}',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.darkGray),
              ),
              const SizedBox(height: 48),
              CustomButton(
                text: 'VOIR LA COMMANDE',
                backgroundColor: const Color(0xFF27AE60),
                onPressed: () {
                  // Navigate to Order Detail
                  // context.go('/order/$orderId'); // Route needs to be defined in Prompt 15
                  // For now back to home or orders list if simpler
                  context
                      .go('/orders'); // Assuming orders list route will exist.
                  // Alternatively: context.go('/home');
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/home'),
                child: Text(
                  'Retour à l\'accueil',
                  style: AppTextStyles.button.copyWith(color: AppColors.black),
                ),
              ),
            ],
          ),
        ),
      );
}
