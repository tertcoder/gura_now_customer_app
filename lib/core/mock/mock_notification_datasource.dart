/// Mock implementation of Notification Remote Data Source for testing without backend.
library;

import '../../features/notifications/data/datasources/notification_remote_datasource.dart';
import '../../features/notifications/data/models/notification_model.dart';
import 'mock_data.dart';

/// Mock notification data source that uses local mock data instead of API calls.
class MockNotificationRemoteDataSource implements NotificationRemoteDataSource {
  @override
  Future<List<NotificationModel>> getNotifications({
    bool unreadOnly = false,
    int skip = 0,
    int limit = 50,
  }) async {
    // Simulate network delay
    await MockData.simulateDelay();

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    return MockData.getNotifications(
      userId: MockData.currentUserId,
      unreadOnly: unreadOnly,
      skip: skip,
      limit: limit,
    );
  }

  @override
  Future<int> getUnreadCount() async {
    // Simulate network delay
    await MockData.simulateDelay(milliseconds: 200);

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    return MockData.getUnreadCount(userId: MockData.currentUserId);
  }

  @override
  Future<NotificationModel> markAsRead(String notificationId) async {
    // Simulate network delay
    await MockData.simulateDelay(milliseconds: 300);

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    final notifIndex =
        MockData.notifications.indexWhere((n) => n.id == notificationId);

    if (notifIndex == -1) {
      throw Exception('Notification not found');
    }

    final notification = MockData.notifications[notifIndex];
    final updatedNotification = notification.markAsRead();

    MockData.notifications[notifIndex] = updatedNotification;

    return updatedNotification;
  }

  @override
  Future<int> markAllAsRead() async {
    // Simulate network delay
    await MockData.simulateDelay(milliseconds: 500);

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    var count = 0;

    // Mark all unread notifications as read
    for (var i = 0; i < MockData.notifications.length; i++) {
      final notification = MockData.notifications[i];
      if (notification.userId == MockData.currentUserId &&
          !notification.isRead) {
        MockData.notifications[i] = notification.markAsRead();
        count++;
      }
    }

    return count;
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    // Simulate network delay
    await MockData.simulateDelay(milliseconds: 300);

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    MockData.notifications.removeWhere((n) => n.id == notificationId);
  }

  @override
  Future<FCMTokenModel> registerFcmToken(FCMTokenCreateRequest request) async {
    // Simulate network delay
    await MockData.simulateDelay();

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    // Create mock FCM token
    final token = FCMTokenModel(
      id: 'fcm-${DateTime.now().millisecondsSinceEpoch}',
      userId: MockData.currentUserId!,
      fcmToken: request.fcmToken,
      deviceType: request.deviceType,
      deviceName: request.deviceName,
      isActive: true,
      createdAt: DateTime.now(),
      lastUsedAt: DateTime.now(),
    );

    return token;
  }

  @override
  Future<List<FCMTokenModel>> getFcmTokens({bool activeOnly = true}) async {
    // Simulate network delay
    await MockData.simulateDelay();

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    // Return mock FCM tokens
    return [
      FCMTokenModel(
        id: 'fcm-1',
        userId: MockData.currentUserId!,
        fcmToken: 'mock_fcm_token_1',
        deviceType: 'android',
        deviceName: 'Samsung Galaxy S21',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        lastUsedAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<void> deactivateFcmToken(String tokenId) async {
    // Simulate network delay
    await MockData.simulateDelay(milliseconds: 300);

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    // In mock mode, just simulate the deactivation
    // No actual state change needed
  }
}
