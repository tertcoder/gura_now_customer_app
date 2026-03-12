part of 'admin_bloc.dart';

enum AdminListStatus { initial, loading, success, failure }
enum AdminActionStatus { initial, loading, success, failure }

class AdminState extends Equatable {
  const AdminState({
    this.statsStatus = AdminListStatus.initial,
    this.stats,
    this.statsError,
    this.usersStatus = AdminListStatus.initial,
    this.users = const [],
    this.usersError,
    this.shopsStatus = AdminListStatus.initial,
    this.shops = const [],
    this.shopsError,
    this.ordersStatus = AdminListStatus.initial,
    this.orders = const [],
    this.ordersError,
    this.transactionsStatus = AdminListStatus.initial,
    this.transactions = const [],
    this.transactionsError,
    this.actionStatus = AdminActionStatus.initial,
    this.actionError,
  });

  final AdminListStatus statsStatus;
  final PlatformStats? stats;
  final String? statsError;
  final AdminListStatus usersStatus;
  final List<dynamic> users;
  final String? usersError;
  final AdminListStatus shopsStatus;
  final List<dynamic> shops;
  final String? shopsError;
  final AdminListStatus ordersStatus;
  final List<dynamic> orders;
  final String? ordersError;
  final AdminListStatus transactionsStatus;
  final List<dynamic> transactions;
  final String? transactionsError;
  final AdminActionStatus actionStatus;
  final String? actionError;

  @override
  List<Object?> get props => [
        statsStatus,
        stats,
        statsError,
        usersStatus,
        users,
        usersError,
        shopsStatus,
        shops,
        shopsError,
        ordersStatus,
        orders,
        ordersError,
        transactionsStatus,
        transactions,
        transactionsError,
        actionStatus,
        actionError,
      ];

  AdminState copyWith({
    AdminListStatus? statsStatus,
    PlatformStats? stats,
    String? statsError,
    AdminListStatus? usersStatus,
    List<dynamic>? users,
    String? usersError,
    AdminListStatus? shopsStatus,
    List<dynamic>? shops,
    String? shopsError,
    AdminListStatus? ordersStatus,
    List<dynamic>? orders,
    String? ordersError,
    AdminListStatus? transactionsStatus,
    List<dynamic>? transactions,
    String? transactionsError,
    AdminActionStatus? actionStatus,
    String? actionError,
  }) {
    return AdminState(
      statsStatus: statsStatus ?? this.statsStatus,
      stats: stats ?? this.stats,
      statsError: statsError,
      usersStatus: usersStatus ?? this.usersStatus,
      users: users ?? this.users,
      usersError: usersError,
      shopsStatus: shopsStatus ?? this.shopsStatus,
      shops: shops ?? this.shops,
      shopsError: shopsError,
      ordersStatus: ordersStatus ?? this.ordersStatus,
      orders: orders ?? this.orders,
      ordersError: ordersError,
      transactionsStatus: transactionsStatus ?? this.transactionsStatus,
      transactions: transactions ?? this.transactions,
      transactionsError: transactionsError,
      actionStatus: actionStatus ?? this.actionStatus,
      actionError: actionError,
    );
  }
}
