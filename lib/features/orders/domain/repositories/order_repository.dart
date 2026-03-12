import 'package:dartz/dartz.dart' hide Order;
import '../../../../core/errors/failures.dart';
import '../entities/order.dart';

abstract class OrderRepository {
  Future<Either<Failure, Order>> createOrder(Map<String, dynamic> orderData);
  Future<Either<Failure, List<Order>>> getOrders();
  Future<Either<Failure, Order>> getOrderDetail(String id);
  Future<Either<Failure, void>> confirmOrder(String orderId);
  Future<Either<Failure, void>> confirmCustomer(String orderId);
}
