import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    required this.message,
    super.key,
    this.icon = Icons.info_outline,
    this.buttonText,
    this.onButtonPressed,
  });

  final String message;
  final IconData icon;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: AppColors.mediumGray),
            const SizedBox(height: 16),
            Text(
              message,
              style:
                  AppTextStyles.bodyLarge.copyWith(color: AppColors.darkGray),
              textAlign: TextAlign.center,
            ),
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  buttonText!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      );
}
