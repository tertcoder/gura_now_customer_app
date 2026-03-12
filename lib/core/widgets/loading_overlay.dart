import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A loading overlay with spinner and optional message.
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.overlayColor,
  });
  final bool isLoading;
  final Widget child;
  final String? message;
  final Color? overlayColor;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          child,
          if (isLoading)
            Positioned.fill(
              child: Container(
                color:
                    overlayColor ?? AppColors.background.withValues(alpha: 0.8),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _AnimatedLoader(),
                      if (message != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          message!,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
}

/// A full screen loading indicator.
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key, this.message});
  final String? message;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _AnimatedLoader(),
              if (message != null) ...[
                const SizedBox(height: 24),
                Text(
                  message!,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
}

class _AnimatedLoader extends StatefulWidget {
  const _AnimatedLoader();

  @override
  State<_AnimatedLoader> createState() => _AnimatedLoaderState();
}

class _AnimatedLoaderState extends State<_AnimatedLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                startAngle: 0,
                endAngle: _controller.value * 6.28,
                colors: const [
                  AppColors.accent,
                  AppColors.accentPurple,
                  AppColors.accent,
                ],
              ),
            ),
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.background,
              ),
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ),
          );
        },
      );
}

/// Shimmer loading placeholder.
class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 8,
  });
  final double width;
  final double height;
  final double borderRadius;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -1, end: 2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [
                  (_animation.value - 1).clamp(0.0, 1.0),
                  _animation.value.clamp(0.0, 1.0),
                  (_animation.value + 1).clamp(0.0, 1.0),
                ],
                colors: const [
                  AppColors.surface,
                  AppColors.surfaceLight,
                  AppColors.surface,
                ],
              ),
            ),
          );
        },
      );
}
