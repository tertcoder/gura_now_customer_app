# 🎭 Mock Data - Quick Start

## ⚡ Enable Mock Mode

**File**: `lib/src/core/mock/mock_config.dart`

```dart
const bool useMockData = true;  // ✅ ENABLED
```

## 👥 Test Users (any password works!)

| Role | Phone | Use Case |
|------|-------|----------|
| 🛍️ **Customer** | +250788123456 | Browse, order, pay |
| 🏪 **Shop Owner** | +250788234567 | Manage orders, view balance |
| 🚚 **Driver** | +250788345678 | Accept & deliver orders |
| 👨‍💼 **Admin** | +250788456789 | Platform management |

## 🚀 Run App

```bash
flutter run
```

## 📝 What's Available

✅ 4 Users with different roles
✅ 4 Shops (markets & groceries)
✅ 3 Orders (pending, confirmed, delivered)
✅ 3 Payment proofs
✅ 4 Notifications
✅ 4 Deliveries (active & available)
✅ Complete admin statistics

## 🔄 Switch to Real API

**File**: `lib/src/core/mock/mock_config.dart`

```dart
const bool useMockData = false;  // ❌ DISABLED - Using real API
```

## 📚 Full Documentation

- **Detailed Guide**: `MOCK_DATA_GUIDE.md`
- **Summary**: `MOCK_DATA_SUMMARY.md`

## 🐛 Debug Mode

Enable to see mock operations in console:

```dart
const bool debugMockMode = true;
```

Output:
```
🎭 [MOCK MODE] Using MockAuthRemoteDataSource
🎭 [MOCK MODE] Using MockShopRemoteDataSource
```

---

**That's it!** Start developing your UI without waiting for the backend 🎉
