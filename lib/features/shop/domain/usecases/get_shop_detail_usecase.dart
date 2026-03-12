import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/shop.dart';
import '../repositories/shop_repository.dart';

class GetShopDetailUseCase implements UseCase<Shop, GetShopDetailParams> {
  GetShopDetailUseCase(this._repository);
  final ShopRepository _repository;

  @override
  Future<Either<Failure, Shop>> call(GetShopDetailParams params) async =>
      await _repository.getShopDetail(params.id);
}

class GetShopDetailParams extends Equatable {
  final String id;

  const GetShopDetailParams(this.id);

  @override
  List<Object> get props => [id];
}
