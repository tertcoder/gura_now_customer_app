import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/shop_balance.dart';
import '../repositories/payment_repository.dart';

/// Use case for getting shop balance
class GetShopBalanceUseCase
    implements UseCase<ShopBalance, GetShopBalanceParams> {
  GetShopBalanceUseCase(this._repository);

  final PaymentRepository _repository;

  @override
  Future<Either<Failure, ShopBalance>> call(GetShopBalanceParams params) async {
    return await _repository.getShopBalance(params.shopId);
  }
}

class GetShopBalanceParams extends Equatable {
  const GetShopBalanceParams({required this.shopId});

  final String shopId;

  @override
  List<Object?> get props => [shopId];
}
