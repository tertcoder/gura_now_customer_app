import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A colored badge for displaying status.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.isPulsing = false,
  });

  /// Create a badge from a status string.
  factory StatusBadge.fromStatus(String status) {
    final color = AppColors.getStatusColor(status);
    return StatusBadge(
      label: _getStatusLabel(status),
      backgroundColor: color.withValues(alpha: 0.15),
      textColor: color,
    );
  }
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool isPulsing;

  static String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'En attente';
      case 'confirmed':
        return 'Confirmé';
      case 'preparing':
        return 'En préparation';
      case 'ready':
        return 'Prêt';
      case 'shipped':
      case 'in_transit':
      case 'en_cours':
        return 'En cours';
      case 'delivered':
        return 'Livré';
      case 'cancelled':
        return 'Annulé';
      case 'active':
        return 'Actif';
      case 'inactive':
        return 'Inactif';
      case 'suspended':
        return 'Suspendu';
      case 'approved':
        return 'Approuvé';
      case 'rejected':
        return 'Rejeté';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.surfaceContainer;
    final fgColor = textColor ?? AppColors.textPrimary;

    final Widget badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isPulsing) ...[
            _PulsingDot(color: fgColor),
            const SizedBox(width: 6),
          ],
          if (icon != null) ...[
            Icon(icon, size: 14, color: fgColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: fgColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    return badge;
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot({required this.color});
  final Color color;

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: _animation.value),
            shape: BoxShape.circle,
          ),
        ),
      );
}
