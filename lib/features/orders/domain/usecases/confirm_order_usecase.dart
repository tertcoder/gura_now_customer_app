import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/order_repository.dart';

class ConfirmOrderUseCase implements UseCase<void, ConfirmOrderParams> {
  ConfirmOrderUseCase(this._repository);
  final OrderRepository _repository;

  @override
  Future<Either<Failure, void>> call(ConfirmOrderParams params) async =>
      await _repository.confirmOrder(params.orderId);
}

class ConfirmOrderParams extends Equatable {
  final String orderId;
  const ConfirmOrderParams(this.orderId);
  @override
  List<Object> get props => [orderId];
}
