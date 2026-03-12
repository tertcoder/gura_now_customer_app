import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderModel> createOrder(Map<String, dynamic> orderData);
  Future<List<OrderModel>> getOrders();
  Future<OrderModel> getOrderDetail(String id);
  Future<void> confirmOrder(String orderId); // Shop confirms
  Future<void> confirmCustomer(String orderId); // Customer confirms
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  OrderRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Future<OrderModel> createOrder(Map<String, dynamic> orderData) async {
    final data = await _apiClient.post(ApiEndpoints.ordersCreate, orderData);
    return OrderModel.fromJson(data);
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    final data = await _apiClient.get(ApiEndpoints.ordersList);
    final List<dynamic> orders = data['orders'] ?? data['data'] ?? data;
    return orders.map((json) => OrderModel.fromJson(json)).toList();
  }

  @override
  Future<OrderModel> getOrderDetail(String id) async {
    final path = ApiEndpoints.replacePathParam(
      ApiEndpoints.ordersDetail,
      'order_id',
      id,
    );
    final data = await _apiClient.get(path);
    return OrderModel.fromJson(data['order'] ?? data);
  }

  @override
  Future<void> confirmOrder(String orderId) async {
    final path = ApiEndpoints.replacePathParam(
      ApiEndpoints.ordersConfirmShop,
      'order_id',
      orderId,
    );
    await _apiClient.put(path, {});
  }

  @override
  Future<void> confirmCustomer(String orderId) async {
    final path = ApiEndpoints.replacePathParam(
      ApiEndpoints.ordersConfirmCustomer,
      'order_id',
      orderId,
    );
    await _apiClient.put(path, {});
  }
}

