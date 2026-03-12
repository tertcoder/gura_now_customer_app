import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A styled card with optional glassmorphism effect.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.backgroundColor,
    this.showBorder = true,
    this.isGlass = false,
    this.onTap,
    this.gradient,
  });
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final bool showBorder;
  final bool isGlass;
  final VoidCallback? onTap;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final Widget card = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: isGlass
            ? AppColors.surface.withValues(alpha: 0.7)
            : (backgroundColor ?? AppColors.surface),
        borderRadius: BorderRadius.circular(borderRadius),
        border: showBorder
            ? Border.all(
                color: AppColors.borderGray,
                width: 1,
              )
            : null,
        gradient: gradient,
        boxShadow: isGlass
            ? [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: card,
      );
    }

    return card;
  }
}

/// A gradient accent card for highlighting important content.
class AppAccentCard extends StatelessWidget {
  const AppAccentCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.gradient = AppColors.gradientAccent,
  });
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) => Container(
        margin: margin,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(20),
          child: child,
        ),
      );
}
