import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc(this._repository) : super(const NotificationState()) {
    on<NotificationsLoadRequested>(_onLoadRequested);
    on<UnreadCountRequested>(_onUnreadCountRequested);
    on<NotificationMarkReadRequested>(_onMarkReadRequested);
    on<NotificationsMarkAllReadRequested>(_onMarkAllReadRequested);
    on<NotificationDeletedRequested>(_onDeletedRequested);
  }

  final NotificationRepository _repository;

  Future<void> _onLoadRequested(
    NotificationsLoadRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(listStatus: NotificationListStatus.loading, listError: null));
    final result = await _repository.getNotifications(
      unreadOnly: event.unreadOnly,
      skip: event.skip,
      limit: event.limit,
    );
    result.fold(
      (f) => emit(state.copyWith(listStatus: NotificationListStatus.failure, listError: f.message)),
      (list) => emit(state.copyWith(listStatus: NotificationListStatus.success, notifications: list)),
    );
  }

  Future<void> _onUnreadCountRequested(
    UnreadCountRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(unreadCountStatus: NotificationListStatus.loading, unreadCountError: null));
    final result = await _repository.getUnreadCount();
    result.fold(
      (f) => emit(state.copyWith(unreadCountStatus: NotificationListStatus.failure, unreadCountError: f.message)),
      (count) => emit(state.copyWith(unreadCountStatus: NotificationListStatus.success, unreadCount: count)),
    );
  }

  Future<void> _onMarkReadRequested(
    NotificationMarkReadRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(actionStatus: NotificationActionStatus.loading, actionError: null));
    final result = await _repository.markAsRead(event.notificationId);
    result.fold(
      (f) => emit(state.copyWith(actionStatus: NotificationActionStatus.failure, actionError: f.message)),
      (_) {
        emit(state.copyWith(actionStatus: NotificationActionStatus.success));
        add(const UnreadCountRequested());
        add(const NotificationsLoadRequested());
      },
    );
  }

  Future<void> _onMarkAllReadRequested(
    NotificationsMarkAllReadRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(actionStatus: NotificationActionStatus.loading, actionError: null));
    final result = await _repository.markAllAsRead();
    result.fold(
      (f) => emit(state.copyWith(actionStatus: NotificationActionStatus.failure, actionError: f.message)),
      (_) {
        emit(state.copyWith(actionStatus: NotificationActionStatus.success));
        add(const UnreadCountRequested());
        add(const NotificationsLoadRequested());
      },
    );
  }

  Future<void> _onDeletedRequested(
    NotificationDeletedRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(actionStatus: NotificationActionStatus.loading, actionError: null));
    final result = await _repository.deleteNotification(event.notificationId);
    result.fold(
      (f) => emit(state.copyWith(actionStatus: NotificationActionStatus.failure, actionError: f.message)),
      (_) {
        emit(state.copyWith(actionStatus: NotificationActionStatus.success));
        add(const UnreadCountRequested());
        add(const NotificationsLoadRequested());
      },
    );
  }
}
