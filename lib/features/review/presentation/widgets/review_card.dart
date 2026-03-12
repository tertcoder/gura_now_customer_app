import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'star_rating_widget.dart';

/// Card widget for displaying a single review.
class ReviewCard extends StatelessWidget {
  const ReviewCard({
    super.key,
    required this.reviewerName,
    this.reviewerImage,
    required this.rating,
    this.comment,
    required this.createdAt,
    this.isVisible = true,
  });
  final String reviewerName;
  final String? reviewerImage;
  final int rating;
  final String? comment;
  final DateTime createdAt;
  final bool isVisible;

  static String _initials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.length >= 2 ? name.substring(0, 2).toUpperCase() : name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderGray),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.surfaceContainer,
                  backgroundImage: reviewerImage != null && reviewerImage!.isNotEmpty
                      ? NetworkImage(reviewerImage!)
                      : null,
                  child: reviewerImage == null || reviewerImage!.isEmpty
                      ? Text(
                          _initials(reviewerName),
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reviewerName,
                        style: AppTextStyles.heading5,
                      ),
                      const SizedBox(height: 2),
                      StarRatingDisplay(
                        rating: rating.toDouble(),
                        size: 14,
                        showCount: false,
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatDate(createdAt),
                  style: AppTextStyles.caption,
                ),
              ],
            ),
            if (comment != null && comment!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                comment!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
            if (!isVisible) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.danger.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.visibility_off_rounded, size: 14, color: AppColors.danger),
                    const SizedBox(width: 4),
                    Text(
                      'Avis masqué',
                      style: AppTextStyles.caption.copyWith(color: AppColors.danger),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays == 0) return 'Aujourd\'hui';
    if (difference.inDays == 1) return 'Hier';
    if (difference.inDays < 7) return 'Il y a ${difference.inDays} jours';
    return DateFormat('dd MMM yyyy', 'fr_FR').format(date);
  }
}

/// Widget to display review statistics (dark theme).
class ReviewStatsWidget extends StatelessWidget {
  const ReviewStatsWidget({
    super.key,
    required this.totalReviews,
    required this.averageRating,
    required this.distribution,
  });
  final int totalReviews;
  final double averageRating;
  final Map<int, int> distribution;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderGray),
        ),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  averageRating.toStringAsFixed(1),
                  style: AppTextStyles.statLarge.copyWith(color: AppColors.primary),
                ),
                StarRatingDisplay(
                  rating: averageRating,
                  showCount: false,
                ),
                const SizedBox(height: 4),
                Text(
                  '$totalReviews avis',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                children: List.generate(5, (index) {
                  final starCount = 5 - index;
                  final count = distribution[starCount] ?? 0;
                  final percentage = totalReviews > 0 ? count / totalReviews : 0.0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Text('$starCount', style: AppTextStyles.caption),
                        const SizedBox(width: 4),
                        Icon(Icons.star_rounded, size: 12, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: percentage,
                              backgroundColor: AppColors.surfaceContainer,
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                              minHeight: 8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 24,
                          child: Text(
                            '$count',
                            style: AppTextStyles.caption,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      );
}
