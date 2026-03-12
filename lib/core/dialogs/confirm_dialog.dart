import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    Key? key,
    required this.title,
    required this.content,
    this.confirmText = 'Confirmer',
    this.cancelText = 'Annuler',
    required this.onConfirm,
    this.isDestructive = false,
  }) : super(key: key);
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(title, style: AppTextStyles.heading3),
        content: Text(content, style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Close
            child: Text(
              cancelText,
              style: AppTextStyles.button.copyWith(color: AppColors.darkGray),
            ),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.of(context)
                  .pop(); // Close logic handled here or by caller?
              // Usually caller should handle nav if async.
              // But for simple dialog, closing on click is standard.
            },
            child: Text(
              confirmText,
              style: AppTextStyles.button.copyWith(
                color: isDestructive ? AppColors.danger : AppColors.black,
              ),
            ),
          ),
        ],
      );
}
