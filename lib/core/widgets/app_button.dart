import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Primary elevated button with loading state.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.isFullWidth = true,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 52,
    this.borderRadius = 12,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final bool isFullWidth;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final button = isOutlined
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: foregroundColor ?? AppColors.textPrimary,
              minimumSize: Size(isFullWidth ? double.infinity : 0, height),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              side: BorderSide(
                color: backgroundColor ?? AppColors.borderGray,
              ),
            ),
            child: _buildChild(),
          )
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor ?? AppColors.accent,
              foregroundColor: foregroundColor ?? AppColors.textOnAccent,
              minimumSize: Size(isFullWidth ? double.infinity : 0, height),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              elevation: 0,
            ),
            child: _buildChild(),
          );

    return button;
  }

  Widget _buildChild() {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: isOutlined ? AppColors.accent : AppColors.textOnAccent,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// Icon button with background.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 44,
    this.iconSize = 22,
  });
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.surfaceContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor ?? AppColors.textPrimary,
            size: iconSize,
          ),
        ),
      );
}

/// Danger/destructive button.
class AppDangerButton extends StatelessWidget {
  const AppDangerButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => AppButton(
        label: label,
        onPressed: onPressed,
        isLoading: isLoading,
        icon: icon,
        backgroundColor: AppColors.danger,
        foregroundColor: AppColors.white,
      );
}
