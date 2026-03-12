import 'package:dartz/dartz.dart' hide Order;
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetOrderDetailUseCase implements UseCase<Order, GetOrderDetailParams> {
  GetOrderDetailUseCase(this._repository);
  final OrderRepository _repository;

  @override
  Future<Either<Failure, Order>> call(GetOrderDetailParams params) async =>
      await _repository.getOrderDetail(params.id);
}

class GetOrderDetailParams extends Equatable {
  final String id;

  const GetOrderDetailParams(this.id);

  @override
  List<Object> get props => [id];
}
