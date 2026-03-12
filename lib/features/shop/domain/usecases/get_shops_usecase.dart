import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/shop.dart';
import '../repositories/shop_repository.dart';

class GetShopsUseCase implements UseCase<List<Shop>, GetShopsParams> {
  GetShopsUseCase(this._repository);
  final ShopRepository _repository;

  @override
  Future<Either<Failure, List<Shop>>> call(GetShopsParams params) async =>
      await _repository.getShops(
        category: params.category,
        limit: params.limit,
        offset: params.offset,
      );
}

class GetShopsParams extends Equatable {
  final String? category;
  final int limit;
  final int offset;

  const GetShopsParams({
    this.category,
    this.limit = 20,
    this.offset = 0,
  });

  @override
  List<Object?> get props => [category, limit, offset];
}
