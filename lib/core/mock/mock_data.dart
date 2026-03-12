/// Central mock data repository for Gura Now application.
/// This file contains all mock data used throughout the app for development.
library;

import 'dart:math';

import '../../features/auth/data/models/user_model.dart';
import '../../features/shop/data/models/shop_model.dart';
import '../../features/orders/data/models/order_model.dart';
import '../../features/orders/data/models/order_item_model.dart';
import '../../features/orders/domain/entities/order.dart';
import '../../features/payment/data/models/payment_proof_model.dart';
import '../../features/notifications/data/models/notification_model.dart';
import '../../features/driver/data/models/delivery_model.dart';

/// Mock data repository providing sample data for all features.
class MockData {
  static final _random = Random();

  // Current user simulation
  static String? _currentUserId;
  static String? _currentUserRole;
  static String? _authToken;

  /// Initialize mock data with a logged-in user.
  static void login(String userId, String role, String token) {
    _currentUserId = userId;
    _currentUserRole = role;
    _authToken = token;
  }

  /// Clear login data.
  static void logout() {
    _currentUserId = null;
    _currentUserRole = null;
    _authToken = null;
  }

  /// Check if user is logged in.
  static bool get isLoggedIn => _currentUserId != null;

  /// Get current user ID.
  static String? get currentUserId => _currentUserId;

  /// Get current user role.
  static String? get currentUserRole => _currentUserRole;

  /// Get auth token.
  static String? get authToken => _authToken;

  // ============================================
  // USER MOCK DATA
  // ============================================

  static final List<UserModel> users = [
    UserModel(
      id: 'user-1',
      phoneNumber: '+250788123456',
      fullName: 'Jean Baptiste',
      email: 'jean@example.com',
      role: 'customer',
      isActive: true,
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    UserModel(
      id: 'user-2',
      phoneNumber: '+250788234567',
      fullName: 'Marie Claire',
      email: 'marie@example.com',
      role: 'shop_owner',
      isActive: true,
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
    ),
    UserModel(
      id: 'user-3',
      phoneNumber: '+250788345678',
      fullName: 'Eric Mugisha',
      email: 'eric@example.com',
      role: 'driver',
      isActive: true,
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    UserModel(
      id: 'user-4',
      phoneNumber: '+250788456789',
      fullName: 'Admin User',
      email: 'admin@example.com',
      role: 'admin',
      isActive: true,
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
  ];

  static UserModel? getUserById(String id) {
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  static UserModel? getUserByPhone(String phoneNumber) {
    try {
      return users.firstWhere((user) => user.phoneNumber == phoneNumber);
    } catch (e) {
      return null;
    }
  }

  // ============================================
  // SHOP MOCK DATA
  // ============================================

  static final List<ShopModel> shops = [
    const ShopModel(
      id: 'shop-1',
      name: 'Marché Central',
      description: 'Fresh vegetables and fruits daily',
      logoUrl: 'https://picsum.photos/seed/shop1/400/300',
      deliveryScope: 'Gasabo District',
      type: 'Market',
      rating: 4.5,
      totalReviews: 120,
    ),
    const ShopModel(
      id: 'shop-2',
      name: 'Kimironko Market',
      description: 'Traditional African foods and spices',
      logoUrl: 'https://picsum.photos/seed/shop2/400/300',
      deliveryScope: 'Kigali City',
      type: 'Market',
      rating: 4.7,
      totalReviews: 85,
    ),
    const ShopModel(
      id: 'shop-3',
      name: 'Nyabugogo Market',
      description: 'Wholesale and retail marketplace',
      logoUrl: 'https://picsum.photos/seed/shop3/400/300',
      deliveryScope: 'Nyarugenge District',
      type: 'Market',
      rating: 4.2,
      totalReviews: 67,
    ),
    const ShopModel(
      id: 'shop-4',
      name: 'Green Grocer',
      description: 'Organic vegetables and fruits',
      logoUrl: 'https://picsum.photos/seed/shop4/400/300',
      deliveryScope: 'Kigali City',
      type: 'Grocery',
      rating: 4.8,
      totalReviews: 95,
    ),
  ];

  static ShopModel? getShopById(String id) {
    try {
      return shops.firstWhere((shop) => shop.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<ShopModel> getShops(
      {String? category, int limit = 20, int offset = 0}) {
    var filtered = shops;
    if (category != null) {
      filtered = shops.where((shop) => shop.type == category).toList();
    }
    return filtered.skip(offset).take(limit).toList();
  }

  // ============================================
  // ORDER MOCK DATA
  // ============================================

  static final List<OrderModel> orders = [
    OrderModel(
      id: 'order-1',
      customerId: 'user-1',
      shopId: 'shop-1',
      items: const [
        OrderItemModel(
          productId: 'prod-1',
          quantity: 5,
          price: 2000,
        ),
        OrderItemModel(
          productId: 'prod-2',
          quantity: 3,
          price: 1500,
        ),
        OrderItemModel(
          productId: 'prod-3',
          quantity: 10,
          price: 1050,
        ),
      ],
      status: OrderStatus.pending,
      total: 25000,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      shippingAddress: 'KG 15 Ave, Kigali',
    ),
    OrderModel(
      id: 'order-2',
      customerId: 'user-1',
      shopId: 'shop-2',
      items: const [
        OrderItemModel(
          productId: 'prod-4',
          quantity: 2,
          price: 15000,
        ),
        OrderItemModel(
          productId: 'prod-5',
          quantity: 3,
          price: 5000,
        ),
      ],
      status: OrderStatus.confirmed,
      total: 45000,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      shippingAddress: 'KN 3 Rd, Kigali',
    ),
    OrderModel(
      id: 'order-3',
      customerId: 'user-1',
      shopId: 'shop-1',
      items: const [
        OrderItemModel(
          productId: 'prod-6',
          quantity: 1,
          price: 8500,
        ),
        OrderItemModel(
          productId: 'prod-7',
          quantity: 10,
          price: 1000,
        ),
      ],
      status: OrderStatus.delivered,
      total: 18500,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 4)),
      shippingAddress: 'KG 15 Ave, Kigali',
    ),
  ];

  static OrderModel? getOrderById(String id) {
    try {
      return orders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<OrderModel> getOrders({String? status, String? userId}) {
    var filtered = orders;
    if (status != null) {
      filtered = filtered.where((order) => order.status == status).toList();
    }
    if (userId != null) {
      filtered = filtered.where((order) => order.customerId == userId).toList();
    }
    return filtered;
  }

  // ============================================
  // NOTIFICATION MOCK DATA
  // ============================================

  static final List<NotificationModel> notifications = [
    NotificationModel(
      id: 'notif-1',
      userId: 'user-1',
      title: 'Order Confirmed',
      message: 'Your order #order-2 has been confirmed by the shop',
      type: 'order_update',
      relatedOrderId: 'order-2',
      relatedShopId: 'shop-2',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    NotificationModel(
      id: 'notif-2',
      userId: 'user-1',
      title: 'Payment Received',
      message: 'Your payment proof has been verified',
      type: 'payment_update',
      relatedOrderId: 'order-3',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: 'notif-3',
      userId: 'user-1',
      title: 'Order Delivered',
      message: 'Your order #order-3 has been delivered successfully',
      type: 'order_update',
      relatedOrderId: 'order-3',
      relatedShopId: 'shop-1',
      isRead: true,
      readAt: DateTime.now().subtract(const Duration(days: 4, hours: -2)),
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    NotificationModel(
      id: 'notif-4',
      userId: 'user-1',
      title: 'New Products Available',
      message: 'Check out the fresh arrivals at Marché Central',
      type: 'info',
      relatedShopId: 'shop-1',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  static List<NotificationModel> getNotifications({
    String? userId,
    bool unreadOnly = false,
    int skip = 0,
    int limit = 50,
  }) {
    var filtered = notifications;
    if (userId != null) {
      filtered = filtered.where((n) => n.userId == userId).toList();
    }
    if (unreadOnly) {
      filtered = filtered.where((n) => !n.isRead).toList();
    }
    return filtered.skip(skip).take(limit).toList();
  }

  static int getUnreadCount({String? userId}) {
    var filtered = notifications;
    if (userId != null) {
      filtered = filtered.where((n) => n.userId == userId).toList();
    }
    return filtered.where((n) => !n.isRead).length;
  }

  // ============================================
  // PAYMENT MOCK DATA
  // ============================================

  static final List<PaymentProofModel> paymentProofs = [
    PaymentProofModel(
      id: 'pay-1',
      orderId: 'order-3',
      orderNumber: 'ORD-003',
      uploadedBy: 'user-1',
      uploaderName: 'Jean Baptiste',
      imageUrls: const [
        {
          'url': 'https://picsum.photos/seed/pay1/400/600',
          'type': 'payment_proof'
        }
      ],
      status: 'approved',
      validatedBy: 'user-4',
      validatorName: 'Admin User',
      validatedAt: DateTime.now().subtract(const Duration(hours: 1)),
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    PaymentProofModel(
      id: 'pay-2',
      orderId: 'order-2',
      orderNumber: 'ORD-002',
      uploadedBy: 'user-1',
      uploaderName: 'Jean Baptiste',
      imageUrls: const [
        {
          'url': 'https://picsum.photos/seed/pay2/400/600',
          'type': 'payment_proof'
        }
      ],
      status: 'pending',
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
    PaymentProofModel(
      id: 'pay-3',
      orderId: 'order-1',
      orderNumber: 'ORD-001',
      uploadedBy: 'user-1',
      uploaderName: 'Jean Baptiste',
      imageUrls: const [
        {
          'url': 'https://picsum.photos/seed/pay3a/400/600',
          'type': 'payment_proof'
        },
        {
          'url': 'https://picsum.photos/seed/pay3b/400/600',
          'type': 'payment_proof'
        }
      ],
      status: 'rejected',
      validatedBy: 'user-4',
      validatorName: 'Admin User',
      validatedAt: DateTime.now().subtract(const Duration(minutes: 20)),
      rejectionReason: 'Image not clear, please resubmit with better quality',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  static PaymentProofModel? getPaymentProofById(String id) {
    try {
      return paymentProofs.firstWhere((proof) => proof.id == id);
    } catch (e) {
      return null;
    }
  }

  // ============================================
  // DELIVERY MOCK DATA
  // ============================================

  static final List<DeliveryModel> deliveries = [
    DeliveryModel(
      id: 'delivery-1',
      orderId: 'order-2',
      orderNumber: 'ORD-002',
      shopId: 'shop-2',
      shopName: 'Kimironko Market',
      driverId: 'user-3',
      driverName: 'Eric Mugisha',
      pickupAddress: 'Kimironko Market, Gasabo',
      pickupLatitude: -1.9442,
      pickupLongitude: 30.1267,
      pickupPhone: '+250788234567',
      deliveryAddress: 'KN 3 Rd, Kigali',
      deliveryLatitude: -1.9442,
      deliveryLongitude: 30.1267,
      deliveryPhone: '+250788123456',
      estimatedDistanceKm: 3.5,
      deliveryFee: 2000,
      status: 'in_transit',
      acceptedAt: DateTime.now().subtract(const Duration(hours: 1)),
      pickedUpAt: DateTime.now().subtract(const Duration(minutes: 30)),
      driverConfirmedPickup: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    DeliveryModel(
      id: 'delivery-2',
      orderId: 'order-3',
      orderNumber: 'ORD-003',
      shopId: 'shop-1',
      shopName: 'Marché Central',
      driverId: 'user-3',
      driverName: 'Eric Mugisha',
      pickupAddress: 'Marché Central, KG 11 Ave',
      pickupLatitude: -1.9536,
      pickupLongitude: 30.0906,
      pickupPhone: '+250788234567',
      deliveryAddress: 'KG 15 Ave, Kigali',
      deliveryLatitude: -1.9536,
      deliveryLongitude: 30.0906,
      deliveryPhone: '+250788123456',
      estimatedDistanceKm: 2,
      deliveryFee: 1500,
      status: 'completed',
      acceptedAt: DateTime.now().subtract(const Duration(days: 4, hours: -1)),
      pickedUpAt: DateTime.now().subtract(const Duration(days: 4, hours: -2)),
      completedAt: DateTime.now().subtract(const Duration(days: 4, hours: -3)),
      driverConfirmedPickup: true,
      driverConfirmedDelivery: true,
      customerConfirmedDelivery: true,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];

  static final List<AvailableDeliveryModel> availableDeliveries = [
    AvailableDeliveryModel(
      id: 'delivery-3',
      orderId: 'order-1',
      shopName: 'Marché Central',
      shopAddress: 'KG 11 Ave, Gasabo',
      pickupLatitude: -1.9536,
      pickupLongitude: 30.0906,
      deliveryLatitude: -1.9536,
      deliveryLongitude: 30.0906,
      estimatedDistanceKm: 2.5,
      deliveryFee: 1800,
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      expiresAt: DateTime.now().add(const Duration(minutes: 45)),
    ),
    AvailableDeliveryModel(
      id: 'delivery-4',
      orderId: 'order-4',
      shopName: 'Kimironko Market',
      shopAddress: 'Kimironko Road',
      pickupLatitude: -1.9442,
      pickupLongitude: 30.1267,
      deliveryLatitude: -1.9400,
      deliveryLongitude: 30.1300,
      estimatedDistanceKm: 4,
      deliveryFee: 2500,
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      expiresAt: DateTime.now().add(const Duration(minutes: 55)),
    ),
  ];

  static DeliveryModel? getDeliveryById(String id) {
    try {
      return deliveries.firstWhere((delivery) => delivery.id == id);
    } catch (e) {
      return null;
    }
  }

  static AvailableDeliveryModel? getAvailableDeliveryById(String id) {
    try {
      return availableDeliveries.firstWhere((delivery) => delivery.id == id);
    } catch (e) {
      return null;
    }
  }

  // ============================================
  // ADMIN STATS MOCK DATA
  // ============================================

  static Map<String, dynamic> adminStats = {
    'total_users': 1250,
    'total_shops': 45,
    'total_orders': 3420,
    'total_revenue': 45600000.0,
    'active_deliveries': 23,
    'pending_verifications': 8,
  };

  // ============================================
  // HELPER METHODS
  // ============================================

  /// Simulate network delay.
  static Future<void> simulateDelay({int milliseconds = 500}) async {
    await Future.delayed(
        Duration(milliseconds: milliseconds + _random.nextInt(500)));
  }

  /// Generate a mock auth token.
  static String generateMockToken() =>
      'mock_token_${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(10000)}';
}
