part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
  @override
  List<Object?> get props => [];
}

class OrderListRequested extends OrderEvent {
  const OrderListRequested();
}

class OrderDetailRequested extends OrderEvent {
  const OrderDetailRequested(this.orderId);
  final String orderId;
  @override
  List<Object?> get props => [orderId];
}

class OrderCreateRequested extends OrderEvent {
  const OrderCreateRequested(this.orderData);
  final Map<String, dynamic> orderData;
  @override
  List<Object?> get props => [orderData];
}

class OrderConfirmShopRequested extends OrderEvent {
  const OrderConfirmShopRequested(this.orderId);
  final String orderId;
  @override
  List<Object?> get props => [orderId];
}

class OrderConfirmCustomerRequested extends OrderEvent {
  const OrderConfirmCustomerRequested(this.orderId);
  final String orderId;
  @override
  List<Object?> get props => [orderId];
}
