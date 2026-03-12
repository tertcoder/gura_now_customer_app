import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/delivery.dart';
import '../repositories/delivery_repository.dart';

class GetAvailableDeliveriesUseCase
    implements UseCase<List<Delivery>, GetAvailableDeliveriesParams> {
  GetAvailableDeliveriesUseCase(this._repository);
  final DeliveryRepository _repository;

  @override
  Future<Either<Failure, List<Delivery>>> call(
      GetAvailableDeliveriesParams params) async {
    return await _repository.getAvailableDeliveries(
      page: params.page,
      perPage: params.perPage,
    );
  }
}

class GetAvailableDeliveriesParams extends Equatable {
  final int page;
  final int perPage;
  const GetAvailableDeliveriesParams({
    this.page = 1,
    this.perPage = 20,
  });
  @override
  List<Object> get props => [page, perPage];
}
