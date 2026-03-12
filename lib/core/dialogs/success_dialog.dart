import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({
    Key? key,
    required this.title,
    required this.message,
    this.buttonText = 'OK',
    this.onPressed,
  }) : super(key: key);
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF27AE60), size: 60),
            const SizedBox(height: 16),
            Text(title,
                style: AppTextStyles.heading3, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(message,
                style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onPressed != null) onPressed!();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(buttonText,
                    style: const TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      );
}
