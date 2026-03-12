import 'package:dartz/dartz.dart' hide Order;
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class CreateOrderUseCase implements UseCase<Order, CreateOrderParams> {
  CreateOrderUseCase(this._repository);
  final OrderRepository _repository;

  @override
  Future<Either<Failure, Order>> call(CreateOrderParams params) async =>
      await _repository.createOrder(params.orderData);
}

class CreateOrderParams extends Equatable {
  final Map<String, dynamic> orderData;

  const CreateOrderParams({required this.orderData});

  @override
  List<Object> get props => [orderData];
}
