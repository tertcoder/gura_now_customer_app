import 'package:flutter/material.dart';

/// Interactive star rating widget.
class StarRatingWidget extends StatelessWidget {
  const StarRatingWidget({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 32,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.grey,
    this.onRatingChanged,
    this.readOnly = false,
  });
  final int rating;
  final int maxRating;
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final ValueChanged<int>? onRatingChanged;
  final bool readOnly;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(maxRating, (index) {
          final starIndex = index + 1;
          return GestureDetector(
            onTap: readOnly ? null : () => onRatingChanged?.call(starIndex),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Icon(
                starIndex <= rating ? Icons.star : Icons.star_border,
                size: size,
                color: starIndex <= rating ? activeColor : inactiveColor,
              ),
            ),
          );
        }),
      );
}

/// Compact star rating display (read-only).
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
              return Icon(Icons.star, size: size, color: Colors.amber);
            } else if (starIndex == rating.floor() + 1 && rating % 1 >= 0.5) {
              return Icon(Icons.star_half, size: size, color: Colors.amber);
            } else {
              return Icon(Icons.star_border,
                  size: size, color: Colors.grey[300]);
            }
          }),
          if (showCount) ...[
            const SizedBox(width: 4),
            Text(
              rating.toStringAsFixed(1),
              style: TextStyle(
                fontSize: size * 0.8,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (reviewCount > 0) ...[
              Text(
                ' ($reviewCount)',
                style: TextStyle(
                  fontSize: size * 0.7,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ],
      );
}
