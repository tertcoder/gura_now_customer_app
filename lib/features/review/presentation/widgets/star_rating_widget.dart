import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Interactive star rating widget (primary red for active).
class StarRatingWidget extends StatelessWidget {
  const StarRatingWidget({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 32,
    this.activeColor,
    this.inactiveColor,
    this.onRatingChanged,
    this.readOnly = false,
  });
  final int rating;
  final int maxRating;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final ValueChanged<int>? onRatingChanged;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final active = activeColor ?? AppColors.primary;
    final inactive = inactiveColor ?? AppColors.textTertiary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        final starIndex = index + 1;
        return GestureDetector(
          onTap: readOnly ? null : () => onRatingChanged?.call(starIndex),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Icon(
              starIndex <= rating ? Icons.star_rounded : Icons.star_border_rounded,
              size: size,
              color: starIndex <= rating ? active : inactive,
            ),
          ),
        );
      }),
    );
  }
}

/// Compact star rating display (read-only, primary red).
class StarRatingDisplay extends StatelessWidget {
  const StarRatingDisplay({
    super.key,
    required this.rating,
    this.reviewCount = 0,
    this.size = 16,
    this.showCount = true,
  });
  final double rating;
  final int reviewCount;
  final double size;
  final bool showCount;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(5, (index) {
            final starIndex = index + 1;
            if (starIndex <= rating.floor()) {
              return Icon(Icons.star_rounded, size: size, color: AppColors.primary);
            } else if (starIndex == rating.floor() + 1 && rating % 1 >= 0.5) {
              return Icon(Icons.star_half_rounded, size: size, color: AppColors.primary);
            } else {
              return Icon(Icons.star_border_rounded, size: size, color: AppColors.textTertiary);
            }
          }),
          if (showCount) ...[
            const SizedBox(width: 4),
            Text(
              rating.toStringAsFixed(1),
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            if (reviewCount > 0)
              Text(
                ' ($reviewCount)',
                style: AppTextStyles.caption,
              ),
          ],
        ],
      );
}
