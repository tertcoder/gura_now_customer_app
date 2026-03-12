import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/admin_repository.dart';

/// Use case for getting users list
class GetUsersUseCase implements UseCase<Map<String, dynamic>, GetUsersParams> {
  GetUsersUseCase(this._repository);

  final AdminRepository _repository;

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
    GetUsersParams params,
  ) async {
    return await _repository.getUsers(
      page: params.page,
      perPage: params.perPage,
      role: params.role,
      isActive: params.isActive,
      search: params.search,
    );
  }
}

class GetUsersParams extends Equatable {
  const GetUsersParams({
    this.page = 1,
    this.perPage = 20,
    this.role,
    this.isActive,
    this.search,
  });

  final int page;
  final int perPage;
  final String? role;
  final bool? isActive;
  final String? search;

  @override
  List<Object?> get props => [page, perPage, role, isActive, search];
}
