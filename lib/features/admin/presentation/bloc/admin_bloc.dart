import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/platform_stats.dart';
import '../../domain/repositories/admin_repository.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc(this._repository) : super(const AdminState()) {
    on<AdminStatsRequested>(_onStatsRequested);
    on<AdminUsersRequested>(_onUsersRequested);
    on<AdminUserRoleUpdated>(_onUserRoleUpdated);
    on<AdminUserSuspended>(_onUserSuspended);
    on<AdminUserUnsuspended>(_onUserUnsuspended);
    on<AdminShopsRequested>(_onShopsRequested);
    on<AdminShopStatusUpdated>(_onShopStatusUpdated);
    on<AdminOrdersRequested>(_onOrdersRequested);
    on<AdminTransactionsRequested>(_onTransactionsRequested);
  }

  final AdminRepository _repository;

  Future<void> _onStatsRequested(
    AdminStatsRequested event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(statsStatus: AdminListStatus.loading, statsError: null));
    final result = await _repository.getStats();
    result.fold(
      (f) => emit(state.copyWith(statsStatus: AdminListStatus.failure, statsError: f.message)),
      (stats) => emit(state.copyWith(statsStatus: AdminListStatus.success, stats: stats)),
    );
  }

  Future<void> _onUsersRequested(
    AdminUsersRequested event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(usersStatus: AdminListStatus.loading, usersError: null));
    final result = await _repository.getUsers(
      page: event.page,
      perPage: event.perPage,
      role: event.role,
      isActive: event.isActive,
      search: event.search,
    );
    result.fold(
      (f) => emit(state.copyWith(usersStatus: AdminListStatus.failure, usersError: f.message)),
      (data) {
        final users = (data['items'] as List? ?? []);
        emit(state.copyWith(usersStatus: AdminListStatus.success, users: users));
      },
    );
  }

  Future<void> _onUserRoleUpdated(
    AdminUserRoleUpdated event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(actionStatus: AdminActionStatus.loading, actionError: null));
    final result = await _repository.updateUserRole(event.userId, event.newRole);
    result.fold(
      (f) => emit(state.copyWith(actionStatus: AdminActionStatus.failure, actionError: f.message)),
      (_) {
        emit(state.copyWith(actionStatus: AdminActionStatus.success));
        add(const AdminUsersRequested());
      },
    );
  }

  Future<void> _onUserSuspended(
    AdminUserSuspended event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(actionStatus: AdminActionStatus.loading, actionError: null));
    final result = await _repository.suspendUser(
      event.userId,
      suspendedUntil: event.suspendedUntil,
      reason: event.reason ?? 'Violation of terms of service',
    );
    result.fold(
      (f) => emit(state.copyWith(actionStatus: AdminActionStatus.failure, actionError: f.message)),
      (_) {
        emit(state.copyWith(actionStatus: AdminActionStatus.success));
        add(const AdminUsersRequested());
      },
    );
  }

  Future<void> _onUserUnsuspended(
    AdminUserUnsuspended event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(actionStatus: AdminActionStatus.loading, actionError: null));
    final result = await _repository.unsuspendUser(event.userId);
    result.fold(
      (f) => emit(state.copyWith(actionStatus: AdminActionStatus.failure, actionError: f.message)),
      (_) {
        emit(state.copyWith(actionStatus: AdminActionStatus.success));
        add(const AdminUsersRequested());
      },
    );
  }

  Future<void> _onShopsRequested(
    AdminShopsRequested event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(shopsStatus: AdminListStatus.loading, shopsError: null));
    final result = await _repository.getShops(
      page: event.page,
      perPage: event.perPage,
      status: event.status,
      city: event.city,
      search: event.search,
    );
    result.fold(
      (f) => emit(state.copyWith(shopsStatus: AdminListStatus.failure, shopsError: f.message)),
      (data) {
        final shops = (data['items'] as List? ?? []);
        emit(state.copyWith(shopsStatus: AdminListStatus.success, shops: shops));
      },
    );
  }

  Future<void> _onShopStatusUpdated(
    AdminShopStatusUpdated event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(actionStatus: AdminActionStatus.loading, actionError: null));
    final result = await _repository.updateShopStatus(
      event.shopId,
      event.newStatus,
      reason: event.reason,
    );
    result.fold(
      (f) => emit(state.copyWith(actionStatus: AdminActionStatus.failure, actionError: f.message)),
      (_) {
        emit(state.copyWith(actionStatus: AdminActionStatus.success));
        add(const AdminShopsRequested());
      },
    );
  }

  Future<void> _onOrdersRequested(
    AdminOrdersRequested event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(ordersStatus: AdminListStatus.loading, ordersError: null));
    final result = await _repository.getOrders(
      page: event.page,
      perPage: event.perPage,
      status: event.status,
      paymentStatus: event.paymentStatus,
    );
    result.fold(
      (f) => emit(state.copyWith(ordersStatus: AdminListStatus.failure, ordersError: f.message)),
      (data) {
        final orders = (data['items'] as List? ?? []);
        emit(state.copyWith(ordersStatus: AdminListStatus.success, orders: orders));
      },
    );
  }

  Future<void> _onTransactionsRequested(
    AdminTransactionsRequested event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(transactionsStatus: AdminListStatus.loading, transactionsError: null));
    final result = await _repository.getTransactions(
      page: event.page,
      perPage: event.perPage,
      type: event.type,
      status: event.status,
    );
    result.fold(
      (f) => emit(state.copyWith(transactionsStatus: AdminListStatus.failure, transactionsError: f.message)),
      (data) {
        final transactions = (data['items'] as List? ?? []);
        emit(state.copyWith(transactionsStatus: AdminListStatus.success, transactions: transactions));
      },
    );
  }
}
