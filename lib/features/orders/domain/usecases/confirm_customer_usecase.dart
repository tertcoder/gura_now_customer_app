import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/order_repository.dart';

class ConfirmCustomerUseCase implements UseCase<void, ConfirmCustomerParams> {
  ConfirmCustomerUseCase(this._repository);
  final OrderRepository _repository;

  @override
  Future<Either<Failure, void>> call(ConfirmCustomerParams params) async =>
      await _repository.confirmCustomer(params.orderId);
}

class ConfirmCustomerParams extends Equatable {
  final String orderId;
  const ConfirmCustomerParams(this.orderId);
  @override
  List<Object> get props => [orderId];
}
