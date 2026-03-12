import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/delivery.dart';
import '../repositories/delivery_repository.dart';

class AcceptDeliveryUseCase implements UseCase<Delivery, AcceptDeliveryParams> {
  AcceptDeliveryUseCase(this._repository);
  final DeliveryRepository _repository;

  @override
  Future<Either<Failure, Delivery>> call(AcceptDeliveryParams params) async {
    return await _repository.acceptDelivery(params.deliveryId);
  }
}

class AcceptDeliveryParams extends Equatable {
  final String deliveryId;
  const AcceptDeliveryParams(this.deliveryId);
  @override
  List<Object> get props => [deliveryId];
}
