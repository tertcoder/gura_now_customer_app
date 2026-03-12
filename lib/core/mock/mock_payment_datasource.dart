/// Mock implementation of Payment Remote Data Source
/// for testing without backend
library;

import 'dart:io';

import '../../features/orders/domain/entities/order.dart';
import '../../features/payment/data/datasources/payment_remote_datasource.dart';
import '../../features/payment/data/models/payment_history_model.dart';
import '../../features/payment/data/models/payment_proof_model.dart';
import '../../features/payment/data/models/shop_balance_model.dart';
import 'mock_data.dart';

/// Mock payment data source that uses local mock data instead of API calls.
class MockPaymentRemoteDataSource implements PaymentRemoteDataSource {
  @override
  Future<PaymentProofModel> submitPaymentProof({
    required String orderId,
    required String paymentMethod,
    required List<File> images,
    String? referenceNumber,
    String? notes,
  }) async {
    // Simulate network delay
    await MockData.simulateDelay(milliseconds: 1000);

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    // Find the order
    final order = MockData.getOrderById(orderId);
    if (order == null) {
      throw Exception('Order not found');
    }

    // Create image URLs from files (in mock, just use placeholders)
    final imageUrls = images
        .asMap()
        .entries
        .map((entry) => {
              'url': 'https://picsum.photos/seed/proof${entry.key}/400/600',
              'type': 'payment_proof'
            })
        .toList();

    // Create new payment proof
    final newProof = PaymentProofModel(
      id: 'pay-${DateTime.now().millisecondsSinceEpoch}',
      orderId: orderId,
      orderNumber: 'ORD-${orderId.substring(orderId.length - 3)}',
      uploadedBy: MockData.currentUserId!,
      uploaderName: 'Current User',
      imageUrls: imageUrls,
      status: 'pending',
      createdAt: DateTime.now(),
    );

    // Add to mock data
    MockData.paymentProofs.add(newProof);

    return newProof;
  }

  @override
  Future<PaginatedPaymentProofs> getPaymentProofs({
    int page = 1,
    int perPage = 20,
    String? shopId,
    String? status,
  }) async {
    // Simulate network delay
    await MockData.simulateDelay();

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    var filtered = MockData.paymentProofs;

    // Filter by status if provided
    if (status != null) {
      filtered = filtered.where((proof) => proof.status == status).toList();
    }

    // Filter by shop if provided
    if (shopId != null) {
      filtered = filtered.where((proof) {
        final order = MockData.getOrderById(proof.orderId);
        return order?.shopId == shopId;
      }).toList();
    }

    // Paginate
    final start = (page - 1) * perPage;
    final paginatedItems = filtered.skip(start).take(perPage).toList();
    final totalPages = (filtered.length / perPage).ceil();

    return PaginatedPaymentProofs(
      items: paginatedItems,
      total: filtered.length,
      page: page,
      perPage: perPage,
      pages: totalPages,
    );
  }

  @override
  Future<PaymentProofModel> getPaymentProof(String proofId) async {
    // Simulate network delay
    await MockData.simulateDelay();

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    final proof = MockData.getPaymentProofById(proofId);

    if (proof == null) {
      throw Exception('Payment proof not found');
    }

    return proof;
  }

  @override
  Future<PaymentProofModel> validatePaymentProof(
    String proofId,
    PaymentProofValidateRequest request,
  ) async {
    // Simulate network delay
    await MockData.simulateDelay();

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    // Only admins can validate
    if (MockData.currentUserRole != 'admin') {
      throw Exception('Not authorized to validate payment proofs');
    }

    final proofIndex =
        MockData.paymentProofs.indexWhere((p) => p.id == proofId);
    if (proofIndex == -1) {
      throw Exception('Payment proof not found');
    }

    final proof = MockData.paymentProofs[proofIndex];

    // Update the proof
    final updatedProof = PaymentProofModel(
      id: proof.id,
      orderId: proof.orderId,
      orderNumber: proof.orderNumber,
      uploadedBy: proof.uploadedBy,
      uploaderName: proof.uploaderName,
      imageUrls: proof.imageUrls,
      status: request.status,
      validatedBy: MockData.currentUserId,
      validatorName: 'Admin User',
      validatedAt: DateTime.now(),
      rejectionReason: request.rejectionReason,
      createdAt: proof.createdAt,
    );

    MockData.paymentProofs[proofIndex] = updatedProof;

    return updatedProof;
  }

  @override
  Future<PaymentHistory> getPaymentHistory({
    int page = 1,
    int perPage = 20,
  }) async {
    // Simulate network delay
    await MockData.simulateDelay();

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    // Create mock payment history from orders
    final history = <PaymentHistoryItemModel>[];

    for (final order in MockData.orders) {
      if (order.customerId == MockData.currentUserId) {
        history.add(PaymentHistoryItemModel(
          id: 'hist-${order.id}',
          orderId: order.id,
          orderNumber: 'ORD-${order.id.substring(order.id.length - 3)}',
          type: 'order_payment',
          amount: order.total,
          currency: 'BIF',
          paymentMethod: 'momo',
          status:
              order.status == OrderStatus.delivered ? 'completed' : 'pending',
          createdAt: order.createdAt,
          description: 'Payment for order ${order.id}',
        ));
      }
    }

    // Paginate
    final start = (page - 1) * perPage;
    final paginatedItems = history.skip(start).take(perPage).toList();
    final totalPages = (history.length / perPage).ceil();

    return PaymentHistory(
      items: paginatedItems,
      total: history.length,
      page: page,
      perPage: perPage,
      pages: totalPages,
    );
  }

  @override
  Future<ShopBalanceModel> getShopBalance(String shopId) async {
    // Simulate network delay
    await MockData.simulateDelay();

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    // Calculate mock balance
    final shop = MockData.getShopById(shopId);
    if (shop == null) {
      throw Exception('Shop not found');
    }

    // Calculate totals from orders
    final shopOrders =
        MockData.orders.where((o) => o.shopId == shopId).toList();
    final totalSales = shopOrders
        .where((o) => o.status == OrderStatus.delivered)
        .fold<double>(0, (sum, order) => sum + order.total);
    final pendingOrders = shopOrders
        .where((o) =>
            o.status != OrderStatus.delivered &&
            o.status != OrderStatus.cancelled)
        .fold<double>(0, (sum, order) => sum + order.total);

    return ShopBalanceModel(
      shopId: shopId,
      shopName: shop.name,
      totalSales: totalSales,
      totalCommissions: totalSales * 0.05, // 5% commission
      pendingOrdersValue: pendingOrders,
      availableBalance: totalSales * 0.95, // After commission
      totalWithdrawn: 0,
    );
  }
}
