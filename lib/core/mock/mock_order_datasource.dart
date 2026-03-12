/// Mock implementation of Order Remote Data Source for testing without backend.
library;

import '../../features/orders/data/datasources/order_remote_datasource.dart';
import '../../features/orders/data/models/order_item_model.dart';
import '../../features/orders/data/models/order_model.dart';
import '../../features/orders/domain/entities/order.dart';
import 'mock_data.dart';

/// Mock order data source that uses local mock data instead of API calls.
class MockOrderRemoteDataSource implements OrderRemoteDataSource {
  @override
  Future<OrderModel> createOrder(Map<String, dynamic> orderData) async {
    // Simulate network delay
    await MockData.simulateDelay();

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    // Extract order data
    final items = (orderData['items'] as List<dynamic>)
        .map((item) => OrderItemModel.fromJson(item as Map<String, dynamic>))
        .toList();

    final total = items.fold<double>(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    // Create new order
    final newOrder = OrderModel(
      id: 'order-${DateTime.now().millisecondsSinceEpoch}',
      customerId: MockData.currentUserId!,
      shopId: orderData['shop_id'] as String,
      items: items,
      status: OrderStatus.pending,
      total: total,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      shippingAddress: orderData['shipping_address'] as String,
    );

    // Add to mock data
    MockData.orders.add(newOrder);

    return newOrder;
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    // Simulate network delay
    await MockData.simulateDelay();

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    // Return orders for current user
    return MockData.getOrders(userId: MockData.currentUserId);
  }

  @override
  Future<OrderModel> getOrderDetail(String id) async {
    // Simulate network delay
    await MockData.simulateDelay();

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    final order = MockData.getOrderById(id);

    if (order == null) {
      throw Exception('Order not found');
    }

    // Verify the order belongs to current user or is from their shop
    if (order.customerId != MockData.currentUserId &&
        MockData.currentUserRole != 'admin') {
      throw Exception('Not authorized to view this order');
    }

    return order;
  }

  @override
  Future<void> confirmOrder(String orderId) async {
    // Simulate network delay
    await MockData.simulateDelay();

    final orderIndex = MockData.orders.indexWhere((o) => o.id == orderId);
    if (orderIndex == -1) {
      throw Exception('Order not found');
    }

    // Update order status
    final order = MockData.orders[orderIndex];
    final updatedOrder = OrderModel(
      id: order.id,
      customerId: order.customerId,
      shopId: order.shopId,
      items: order.items.cast<OrderItemModel>(),
      status: OrderStatus.confirmed,
      total: order.total,
      createdAt: order.createdAt,
      updatedAt: DateTime.now(),
      shippingAddress: order.shippingAddress,
    );

    MockData.orders[orderIndex] = updatedOrder;
  }

  @override
  Future<void> confirmCustomer(String orderId) async {
    // Simulate network delay
    await MockData.simulateDelay();

    final orderIndex = MockData.orders.indexWhere((o) => o.id == orderId);
    if (orderIndex == -1) {
      throw Exception('Order not found');
    }

    // In mock, this doesn't change status, just confirms receipt
    // Could add a field to track customer confirmation if needed
  }
}
