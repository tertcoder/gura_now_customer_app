import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/notification.dart' as domain;
import '../bloc/notification_bloc.dart';

/// Notifications center screen.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>()
      ..add(const NotificationsLoadRequested())
      ..add(const UnreadCountRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        final unreadCount = state.unreadCount;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Notifications'),
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            actions: [
              if (unreadCount > 0)
                TextButton(
                  onPressed: () {
                    context.read<NotificationBloc>().add(const NotificationsMarkAllReadRequested());
                  },
                  child: const Text('Tout lire'),
                ),
            ],
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, NotificationState state) {
    switch (state.listStatus) {
      case NotificationListStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        );
      case NotificationListStatus.failure:
        return EmptyState.error(
          message: state.listError ?? 'Erreur',
          onRetry: () => context.read<NotificationBloc>().add(const NotificationsLoadRequested()),
        );
      case NotificationListStatus.success:
        final notifications = state.notifications;
        if (notifications.isEmpty) {
          return EmptyState.notifications();
        }
        return RefreshIndicator(
          onRefresh: () async {
            context.read<NotificationBloc>()
              ..add(const NotificationsLoadRequested())
              ..add(const UnreadCountRequested());
          },
          color: AppColors.accent,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _NotificationTile(
                notification: notification,
                onTap: () => _handleNotificationTap(context, notification),
                onDismiss: () {
                  context.read<NotificationBloc>().add(NotificationDeletedRequested(notification.id));
                },
              );
            },
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _handleNotificationTap(BuildContext context, domain.Notification notification) {
    // Mark as read
    if (!notification.isRead) {
      context.read<NotificationBloc>().add(NotificationMarkReadRequested(notification.id));
    }

    // Navigate based on type
    final type = notification.type ?? 'info';
    switch (type) {
      case 'order_status':
      case 'order_delivered':
        final orderId = notification.relatedOrderId;
        if (orderId != null) {
          context.push('/order/$orderId');
        }
        break;
      case 'delivery':
        final orderId = notification.relatedOrderId;
        if (orderId != null) {
          context.push('/order/$orderId');
        }
        break;
      case 'promotion':
        final shopId = notification.relatedShopId;
        if (shopId != null) {
          context.push('/shop/$shopId');
        }
        break;
    }
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });
  final domain.Notification notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final type = notification.type ?? 'info';

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: AppColors.danger,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: AppColors.white),
      ),
      onDismissed: (_) => onDismiss(),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: notification.isRead ? AppColors.background : AppColors.surfaceLight,
            border: Border(
              left: BorderSide(
                color: notification.isRead ? Colors.transparent : AppColors.primary,
                width: 3,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _getTypeColor(type).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getTypeIcon(type),
                  color: _getTypeColor(type),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: notification.isRead
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(notification.createdAt),
                      style: const TextStyle(
                        color: AppColors.textDisabled,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'order_status':
        return AppColors.info;
      case 'delivery':
        return AppColors.warning;
      case 'order_delivered':
      case 'success':
        return AppColors.success;
      case 'promotion':
        return AppColors.accentPurple;
      case 'error':
        return AppColors.danger;
      case 'warning':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'order_status':
        return Icons.shopping_bag;
      case 'delivery':
        return Icons.delivery_dining;
      case 'order_delivered':
      case 'success':
        return Icons.check_circle;
      case 'promotion':
        return Icons.local_offer;
      case 'error':
        return Icons.error;
      case 'warning':
        return Icons.warning;
      default:
        return Icons.notifications;
    }
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    } else {
      return DateFormat('dd MMM', 'fr_FR').format(date);
    }
  }
}

/// Notification badge widget for AppBar.
class NotificationBadge extends StatelessWidget {
  const NotificationBadge({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      buildWhen: (prev, next) => prev.unreadCount != next.unreadCount,
      builder: (context, state) {
        final unreadCount = state.unreadCount;
        return IconButton(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_outlined),
              if (unreadCount > 0)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.danger,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      unreadCount > 99 ? '99+' : '$unreadCount',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          onPressed: onTap ?? () => context.push('/notifications'),
        );
      },
    );
  }
}
