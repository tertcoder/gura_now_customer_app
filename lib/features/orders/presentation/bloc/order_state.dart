part of 'order_bloc.dart';

enum OrderListStatus { initial, loading, success, failure }
enum OrderDetailStatus { initial, loading, success, failure }
enum OrderActionStatus { initial, loading, success, failure }

class OrderState extends Equatable {
  const OrderState({
    this.listStatus = OrderListStatus.initial,
    this.orders = const [],
    this.listError,
    this.detailStatus = OrderDetailStatus.initial,
    this.selectedOrder,
    this.detailError,
    this.createStatus = OrderActionStatus.initial,
    this.createdOrder,
    this.createError,
    this.actionStatus = OrderActionStatus.initial,
    this.actionError,
  });

  final OrderListStatus listStatus;
  final List<Order> orders;
  final String? listError;
  final OrderDetailStatus detailStatus;
  final Order? selectedOrder;
  final String? detailError;
  final OrderActionStatus createStatus;
  final Order? createdOrder;
  final String? createError;
  final OrderActionStatus actionStatus;
  final String? actionError;

  List<Order> get activeOrders => orders
      .where((o) =>
          o.status == OrderStatus.pending ||
          o.status == OrderStatus.confirmed ||
          o.status == OrderStatus.shipped)
      .toList();
  List<Order> get historyOrders => orders
      .where((o) =>
          o.status != OrderStatus.pending &&
          o.status != OrderStatus.confirmed &&
          o.status != OrderStatus.shipped)
      .toList();

  @override
  List<Object?> get props => [
        listStatus,
        orders,
        listError,
        detailStatus,
        selectedOrder,
        detailError,
        createStatus,
        createdOrder,
        createError,
        actionStatus,
        actionError,
      ];

  OrderState copyWith({
    OrderListStatus? listStatus,
    List<Order>? orders,
    String? listError,
    OrderDetailStatus? detailStatus,
    Order? selectedOrder,
    String? detailError,
    OrderActionStatus? createStatus,
    Order? createdOrder,
    String? createError,
    OrderActionStatus? actionStatus,
    String? actionError,
  }) {
    return OrderState(
      listStatus: listStatus ?? this.listStatus,
      orders: orders ?? this.orders,
      listError: listError,
      detailStatus: detailStatus ?? this.detailStatus,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      detailError: detailError,
      createStatus: createStatus ?? this.createStatus,
      createdOrder: createdOrder ?? this.createdOrder,
      createError: createError,
      actionStatus: actionStatus ?? this.actionStatus,
      actionError: actionError,
    );
  }
}
