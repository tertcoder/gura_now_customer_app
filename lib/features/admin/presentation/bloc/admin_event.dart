part of 'admin_bloc.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();
  @override
  List<Object?> get props => [];
}

class AdminStatsRequested extends AdminEvent {
  const AdminStatsRequested();
}

class AdminUsersRequested extends AdminEvent {
  const AdminUsersRequested({this.page = 1, this.perPage = 20, this.role, this.isActive, this.search});
  final int page;
  final int perPage;
  final String? role;
  final bool? isActive;
  final String? search;
  @override
  List<Object?> get props => [page, perPage, role, isActive, search];
}

class AdminUserRoleUpdated extends AdminEvent {
  const AdminUserRoleUpdated(this.userId, this.newRole);
  final String userId;
  final String newRole;
  @override
  List<Object?> get props => [userId, newRole];
}

class AdminUserSuspended extends AdminEvent {
  const AdminUserSuspended(this.userId, {this.suspendedUntil, this.reason});
  final String userId;
  final String? suspendedUntil;
  final String? reason;
  @override
  List<Object?> get props => [userId, suspendedUntil, reason];
}

class AdminUserUnsuspended extends AdminEvent {
  const AdminUserUnsuspended(this.userId);
  final String userId;
  @override
  List<Object?> get props => [userId];
}

class AdminShopsRequested extends AdminEvent {
  const AdminShopsRequested({this.page = 1, this.perPage = 20, this.status, this.city, this.search});
  final int page;
  final int perPage;
  final String? status;
  final String? city;
  final String? search;
  @override
  List<Object?> get props => [page, perPage, status, city, search];
}

class AdminShopStatusUpdated extends AdminEvent {
  const AdminShopStatusUpdated(this.shopId, this.newStatus, {this.reason});
  final String shopId;
  final String newStatus;
  final String? reason;
  @override
  List<Object?> get props => [shopId, newStatus, reason];
}

class AdminOrdersRequested extends AdminEvent {
  const AdminOrdersRequested({this.page = 1, this.perPage = 20, this.status, this.paymentStatus});
  final int page;
  final int perPage;
  final String? status;
  final String? paymentStatus;
  @override
  List<Object?> get props => [page, perPage, status, paymentStatus];
}

class AdminTransactionsRequested extends AdminEvent {
  const AdminTransactionsRequested({this.page = 1, this.perPage = 20, this.type, this.status});
  final int page;
  final int perPage;
  final String? type;
  final String? status;
  @override
  List<Object?> get props => [page, perPage, type, status];
}
