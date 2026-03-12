# Mock Data Implementation Guide

This document explains how to use the mock data system in the Gura Now (Gura Now) frontend application.

## Overview

The mock data system allows you to develop and test the UI without a working backend. All API calls are intercepted and return mock data from local sources.

## Features

✅ **Complete Mock Data Coverage**

- Authentication (login, register, logout)
- Shops (list, details)
- Orders (create, list, details, confirm)
- Payments (submit proof, verify, history, balances)
- Notifications (list, mark as read, FCM tokens)
- Deliveries (available, accept, pickup, track, complete)
- Admin (stats, users, shops, orders, transactions)

✅ **Realistic Data**

- Sample users with different roles (customer, shop_owner, driver, admin)
- Multiple shops with products
- Order history with various statuses
- Payment proofs and transaction history
- Active deliveries and tracking

✅ **Network Simulation**

- Realistic delays (300-1000ms) to simulate network latency
- Random delays for more realistic behavior

## Quick Start

### Enable Mock Mode

1. Open `lib/src/core/mock/mock_config.dart`
2. Set `useMockData = true`

```dart
/// Global flag to enable/disable mock data mode.
const bool useMockData = true;  // Set to false when backend is ready
```

3. Run the app - all API calls will now use mock data!

### Test Users

You can log in with any of these test accounts (any password will work in mock mode):

| Role       | Phone         | Name          |
| ---------- | ------------- | ------------- |
| Customer   | +250788123456 | Jean Baptiste |
| Shop Owner | +250788234567 | Marie Claire  |
| Driver     | +250788345678 | Eric Mugisha  |
| Admin      | +250788456789 | Admin User    |

## Architecture

### File Structure

```
lib/src/core/mock/
├── mock_config.dart              # Configuration (enable/disable mock mode)
├── mock_data.dart                # Central mock data repository
├── mock_auth_datasource.dart     # Mock authentication
├── mock_shop_datasource.dart     # Mock shops
├── mock_order_datasource.dart    # Mock orders
├── mock_payment_datasource.dart  # Mock payments
├── mock_notification_datasource.dart # Mock notifications
├── mock_delivery_datasource.dart # Mock deliveries
└── mock_admin_datasource.dart    # Mock admin operations
```

### How It Works

1. **Provider Layer**: Each repository checks the `useMockData` flag
2. **Mock/Real Switch**: If true, uses mock data source; if false, uses real API
3. **Mock Data Sources**: Implement the same interface as real data sources
4. **Central Data Store**: `MockData` class holds all sample data

```dart
// Example from auth_repository_impl.dart
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);

  final AuthRemoteDataSource remoteDataSource;
  if (useMockData) {
    remoteDataSource = MockAuthRemoteDataSource();
  } else {
    final dioClient = ref.watch(dioClientProvider);
    remoteDataSource = AuthRemoteDataSourceImpl(dioClient);
  }

  return AuthRepositoryImpl(remoteDataSource, secureStorage);
});
```

## Customizing Mock Data

### Adding New Mock Data

Edit `lib/src/core/mock/mock_data.dart`:

```dart
static final List<ShopModel> shops = [
  const ShopModel(
    id: 'shop-5',
    name: 'Your New Shop',
    description: 'A great shop',
    type: 'Grocery',
    rating: 4.9,
    totalReviews: 200,
  ),
  // ... add more
];
```

### Modifying Existing Data

1. Open `mock_data.dart`
2. Find the relevant data list (users, shops, orders, etc.)
3. Add, remove, or modify entries
4. Restart the app to see changes

### Simulating Different Scenarios

You can modify mock data sources to simulate:

**Success Scenarios:**

```dart
// In mock_order_datasource.dart
Future<OrderModel> createOrder(Map<String, dynamic> orderData) async {
  await MockData.simulateDelay();
  // ... create order successfully
  return newOrder;
}
```

**Error Scenarios:**

```dart
Future<OrderModel> createOrder(Map<String, dynamic> orderData) async {
  await MockData.simulateDelay();
  throw Exception('Order creation failed - shop is closed');
}
```

**Slow Network:**

```dart
// Increase delay
await MockData.simulateDelay(milliseconds: 3000); // 3 seconds
```

## Testing Workflows

### Customer Flow

1. Log in as customer (+250788123456)
2. Browse shops
3. Add items to cart
4. Create order
5. Submit payment proof
6. Track delivery
7. Confirm receipt

### Shop Owner Flow

1. Log in as shop owner (+250788234567)
2. View incoming orders
3. Confirm orders
4. Check shop balance
5. View payment history

### Driver Flow

1. Log in as driver (+250788345678)
2. View available deliveries
3. Accept delivery
4. Confirm pickup
5. Update location
6. Complete delivery

### Admin Flow

1. Log in as admin (+250788456789)
2. View platform statistics
3. Manage users
4. Manage shops
5. View all orders
6. Verify payment proofs
7. View transactions

## Debugging

### Enable Debug Logs

Set `debugMockMode = true` in `mock_config.dart`:

```dart
const bool debugMockMode = true;
```

You'll see logs like:

```
🎭 [MOCK MODE] Using MockAuthRemoteDataSource
🎭 [MOCK MODE] Using MockShopRemoteDataSource
🎭 [MOCK MODE] Using MockOrderRemoteDataSource
```

### Common Issues

**Problem:** Changes to mock data not reflected

- **Solution:** Hot restart the app (not hot reload)

**Problem:** "Not authenticated" errors

- **Solution:** Log in again - mock auth state is in-memory only

**Problem:** Empty data lists

- **Solution:** Check that you're using the right user account (e.g., customer for orders)

## Switching to Real Backend

When your backend is ready:

1. Set `useMockData = false` in `mock_config.dart`
2. Configure the backend URL in `app_config.dart`
3. Test thoroughly - the interface should work identically!

```dart
// mock_config.dart
const bool useMockData = false; // Now using real API

// app_config.dart
class AppConfig {
  static const String baseUrl = 'https://your-backend-url.com/api';
  // ...
}
```

## Best Practices

1. **Keep mock data realistic** - Use real-world values and scenarios
2. **Match backend format exactly** - Mock data structure should match API responses
3. **Test all user roles** - Verify flows for customer, shop owner, driver, and admin
4. **Simulate errors** - Test error handling by throwing exceptions in mock sources
5. **Keep it updated** - When backend changes, update mock data to match

## Mock Data State

### Persistent State

Mock data is stored in static variables in `MockData` class:

- Survives across screens
- Lost on app restart
- Changes during session are retained

### Current User

```dart
// Login sets current user
MockData.login(userId, role, token);

// Check if logged in
if (MockData.isLoggedIn) {
  // Access current user
  final userId = MockData.currentUserId;
  final role = MockData.currentUserRole;
}

// Logout clears current user
MockData.logout();
```

### Modifying Data at Runtime

You can modify mock data during runtime:

```dart
// Add new order
MockData.orders.add(newOrder);

// Update user
final userIndex = MockData.users.indexWhere((u) => u.id == userId);
MockData.users[userIndex] = updatedUser;

// Delete notification
MockData.notifications.removeWhere((n) => n.id == notifId);
```

## Tips for UI Development

1. **Start with mock mode** - Develop UI flows without waiting for backend
2. **Test edge cases** - Modify mock data to show empty states, errors, etc.
3. **Use different users** - Switch between roles to test different permissions
4. **Verify pagination** - Mock data includes pagination logic
5. **Test real-time updates** - Modify mock data to see UI updates

## Support

For issues or questions about mock data:

1. Check this guide
2. Review mock data source implementations
3. Look at `mock_data.dart` for available sample data
4. Check debug logs when `debugMockMode = true`

---

**Remember:** Mock data is for development only. Always test with real backend before production!
