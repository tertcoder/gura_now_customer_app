import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/mock/mock_config.dart';
import '../../../../core/mock/mock_shop_datasource.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/shop.dart';
import '../../domain/repositories/shop_repository.dart';
import '../datasources/shop_remote_datasource.dart';

class ShopRepositoryImpl implements ShopRepository {
  ShopRepositoryImpl(this._remoteDataSource);
  final ShopRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<Shop>>> getShops({
    String? category,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final models = await _remoteDataSource.getShops(
        category: category,
        limit: limit,
        offset: offset,
      );
      return Right(models.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Shop>> getShopDetail(String id) async {
    try {
      final model = await _remoteDataSource.getShopDetail(id);
      return Right(model.toEntity());
    } on NotFoundException catch (e) {
      return Left(ServerFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}

final shopRepositoryProvider = Provider<ShopRepository>((ref) {
  final ShopRemoteDataSource remoteDataSource;
  if (useMockData) {
    logMockOperation('Using MockShopRemoteDataSource');
    remoteDataSource = MockShopRemoteDataSource();
  } else {
    final apiClient = ref.watch(apiClientProvider);
    remoteDataSource = ShopRemoteDataSourceImpl(apiClient);
  }
  return ShopRepositoryImpl(remoteDataSource);
});
