import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/notifications/presentation/bloc/notification_bloc.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Notification bell icon with unread count badge
class NotificationBadge extends StatelessWidget {
  const NotificationBadge({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          final unreadCount = state.unreadCount;

          return GestureDetector(
            onTap: () {
              context.push('/notifications');
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.borderGray,
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      unreadCount > 0
                          ? Icons.notifications_active_rounded
                          : Icons.notifications_outlined,
                      color: unreadCount > 0
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      size: 22,
                    ),
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          gradient: AppColors.gradientPrimary,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          unreadCount > 99 ? '99+' : '$unreadCount',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
}
