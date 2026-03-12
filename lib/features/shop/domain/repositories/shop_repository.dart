import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/shop.dart';

abstract class ShopRepository {
  Future<Either<Failure, List<Shop>>> getShops({
    String? category,
    int limit = 20,
    int offset = 0,
  });
  Future<Either<Failure, Shop>> getShopDetail(String id);
}
