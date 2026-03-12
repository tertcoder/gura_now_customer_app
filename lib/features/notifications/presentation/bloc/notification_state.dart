part of 'notification_bloc.dart';

enum NotificationListStatus { initial, loading, success, failure }
enum NotificationActionStatus { initial, loading, success, failure }

class NotificationState extends Equatable {
  const NotificationState({
    this.listStatus = NotificationListStatus.initial,
    this.notifications = const [],
    this.listError,
    this.unreadCountStatus = NotificationListStatus.initial,
    this.unreadCount = 0,
    this.unreadCountError,
    this.actionStatus = NotificationActionStatus.initial,
    this.actionError,
  });

  final NotificationListStatus listStatus;
  final List<Notification> notifications;
  final String? listError;
  final NotificationListStatus unreadCountStatus;
  final int unreadCount;
  final String? unreadCountError;
  final NotificationActionStatus actionStatus;
  final String? actionError;

  @override
  List<Object?> get props => [
        listStatus,
        notifications,
        listError,
        unreadCountStatus,
        unreadCount,
        unreadCountError,
        actionStatus,
        actionError,
      ];

  NotificationState copyWith({
    NotificationListStatus? listStatus,
    List<Notification>? notifications,
    String? listError,
    NotificationListStatus? unreadCountStatus,
    int? unreadCount,
    String? unreadCountError,
    NotificationActionStatus? actionStatus,
    String? actionError,
  }) {
    return NotificationState(
      listStatus: listStatus ?? this.listStatus,
      notifications: notifications ?? this.notifications,
      listError: listError,
      unreadCountStatus: unreadCountStatus ?? this.unreadCountStatus,
      unreadCount: unreadCount ?? this.unreadCount,
      unreadCountError: unreadCountError,
      actionStatus: actionStatus ?? this.actionStatus,
      actionError: actionError,
    );
  }
}
