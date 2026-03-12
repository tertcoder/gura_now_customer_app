import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/payment_repository.dart';

/// Use case for getting payment proofs
class GetPaymentProofsUseCase
    implements UseCase<Map<String, dynamic>, GetPaymentProofsParams> {
  GetPaymentProofsUseCase(this._repository);

  final PaymentRepository _repository;

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
    GetPaymentProofsParams params,
  ) async {
    return await _repository.getPaymentProofs(
      page: params.page,
      perPage: params.perPage,
      shopId: params.shopId,
      status: params.status,
    );
  }
}

class GetPaymentProofsParams extends Equatable {
  const GetPaymentProofsParams({
    this.page = 1,
    this.perPage = 20,
    this.shopId,
    this.status,
  });

  final int page;
  final int perPage;
  final String? shopId;
  final String? status;

  @override
  List<Object?> get props => [page, perPage, shopId, status];
}
