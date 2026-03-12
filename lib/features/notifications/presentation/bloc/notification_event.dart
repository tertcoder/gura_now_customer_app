part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object?> get props => [];
}

class NotificationsLoadRequested extends NotificationEvent {
  const NotificationsLoadRequested({this.unreadOnly = false, this.skip = 0, this.limit = 50});
  final bool unreadOnly;
  final int skip;
  final int limit;
  @override
  List<Object?> get props => [unreadOnly, skip, limit];
}

class UnreadCountRequested extends NotificationEvent {
  const UnreadCountRequested();
}

class NotificationMarkReadRequested extends NotificationEvent {
  const NotificationMarkReadRequested(this.notificationId);
  final String notificationId;
  @override
  List<Object?> get props => [notificationId];
}

class NotificationsMarkAllReadRequested extends NotificationEvent {
  const NotificationsMarkAllReadRequested();
}

class NotificationDeletedRequested extends NotificationEvent {
  const NotificationDeletedRequested(this.notificationId);
  final String notificationId;
  @override
  List<Object?> get props => [notificationId];
}
