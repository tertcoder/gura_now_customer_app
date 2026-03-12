import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.black),
            ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.darkGray),
              ),
            ],
          ],
        ),
      );
}
