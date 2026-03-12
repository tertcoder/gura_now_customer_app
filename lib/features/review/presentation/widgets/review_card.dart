import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: reviewerImage != null
                      ? NetworkImage(reviewerImage!)
                      : null,
                  child: reviewerImage == null
                      ? Text(
                          reviewerName.isNotEmpty
                              ? reviewerName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                // Name and Rating
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reviewerName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
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
                // Date
                Text(
                  _formatDate(createdAt),
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            // Comment
            if (comment != null && comment!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                comment!,
                style: TextStyle(
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
            ],
            // Hidden indicator
            if (!isVisible) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.visibility_off,
                        size: 14, color: Colors.red[400]),
                    const SizedBox(width: 4),
                    Text(
                      'Avis masqué',
                      style: TextStyle(
                        color: Colors.red[400],
                        fontSize: 12,
                      ),
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

    if (difference.inDays == 0) {
      return 'Aujourd\'hui';
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jours';
    } else {
      return DateFormat('dd MMM yyyy', 'fr_FR').format(date);
    }
  }
}

/// Widget to display review statistics.
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            // Average Rating
            Column(
              children: [
                Text(
                  averageRating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                StarRatingDisplay(
                  rating: averageRating,
                  showCount: false,
                ),
                const SizedBox(height: 4),
                Text(
                  '$totalReviews avis',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
            // Distribution Bars
            Expanded(
              child: Column(
                children: List.generate(5, (index) {
                  final starCount = 5 - index;
                  final count = distribution[starCount] ?? 0;
                  final percentage =
                      totalReviews > 0 ? count / totalReviews : 0.0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Text(
                          '$starCount',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const Icon(Icons.star, size: 12, color: Colors.amber),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: percentage,
                              backgroundColor: Colors.grey[200],
                              valueColor: const AlwaysStoppedAnimation(
                                Colors.amber,
                              ),
                              minHeight: 8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 24,
                          child: Text(
                            '$count',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
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
