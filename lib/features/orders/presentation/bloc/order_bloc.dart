import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/confirm_customer_usecase.dart';
import '../../domain/usecases/confirm_order_usecase.dart';
import '../../domain/usecases/create_order_usecase.dart';
import '../../domain/usecases/get_order_detail_usecase.dart';
import '../../domain/usecases/get_orders_usecase.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc({
    required GetOrdersUseCase getOrdersUseCase,
    required GetOrderDetailUseCase getOrderDetailUseCase,
    required CreateOrderUseCase createOrderUseCase,
    required ConfirmOrderUseCase confirmOrderUseCase,
    required ConfirmCustomerUseCase confirmCustomerUseCase,
  })  : _getOrdersUseCase = getOrdersUseCase,
        _getOrderDetailUseCase = getOrderDetailUseCase,
        _createOrderUseCase = createOrderUseCase,
        _confirmOrderUseCase = confirmOrderUseCase,
        _confirmCustomerUseCase = confirmCustomerUseCase,
        super(const OrderState()) {
    on<OrderListRequested>(_onListRequested);
    on<OrderDetailRequested>(_onDetailRequested);
    on<OrderCreateRequested>(_onCreateRequested);
    on<OrderConfirmShopRequested>(_onConfirmShopRequested);
    on<OrderConfirmCustomerRequested>(_onConfirmCustomerRequested);
  }

  final GetOrdersUseCase _getOrdersUseCase;
  final GetOrderDetailUseCase _getOrderDetailUseCase;
  final CreateOrderUseCase _createOrderUseCase;
  final ConfirmOrderUseCase _confirmOrderUseCase;
  final ConfirmCustomerUseCase _confirmCustomerUseCase;

  Future<void> _onListRequested(
    OrderListRequested event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(listStatus: OrderListStatus.loading, listError: null));
    final result = await _getOrdersUseCase(NoParams());
    result.fold(
      (f) => emit(state.copyWith(
          listStatus: OrderListStatus.failure, listError: f.message)),
      (orders) => emit(state.copyWith(
          listStatus: OrderListStatus.success,
          orders: List<Order>.from(orders))),
    );
  }

  Future<void> _onDetailRequested(
    OrderDetailRequested event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(
        detailStatus: OrderDetailStatus.loading,
        detailError: null,
        selectedOrder: null));
    final result =
        await _getOrderDetailUseCase(GetOrderDetailParams(event.orderId));
    result.fold(
      (f) => emit(state.copyWith(
          detailStatus: OrderDetailStatus.failure, detailError: f.message)),
      (order) => emit(state.copyWith(
          detailStatus: OrderDetailStatus.success, selectedOrder: order)),
    );
  }

  Future<void> _onCreateRequested(
    OrderCreateRequested event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(
        createStatus: OrderActionStatus.loading, createError: null));
    final result =
        await _createOrderUseCase(CreateOrderParams(orderData: event.orderData));
    result.fold(
      (f) => emit(state.copyWith(
          createStatus: OrderActionStatus.failure, createError: f.message)),
      (order) => emit(state.copyWith(
          createStatus: OrderActionStatus.success, createdOrder: order)),
    );
  }

  Future<void> _onConfirmShopRequested(
    OrderConfirmShopRequested event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(
        actionStatus: OrderActionStatus.loading, actionError: null));
    final result =
        await _confirmOrderUseCase(ConfirmOrderParams(event.orderId));
    result.fold(
      (f) => emit(state.copyWith(
          actionStatus: OrderActionStatus.failure, actionError: f.message)),
      (_) => emit(state.copyWith(actionStatus: OrderActionStatus.success)),
    );
  }

  Future<void> _onConfirmCustomerRequested(
    OrderConfirmCustomerRequested event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(
        actionStatus: OrderActionStatus.loading, actionError: null));
    final result =
        await _confirmCustomerUseCase(ConfirmCustomerParams(event.orderId));
    result.fold(
      (f) => emit(state.copyWith(
          actionStatus: OrderActionStatus.failure, actionError: f.message)),
      (_) => emit(state.copyWith(actionStatus: OrderActionStatus.success)),
    );
  }
}
