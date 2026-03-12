# Gura Now - Current Development Scope

> **Last Updated:** February 2026

## Overview

Gura Now is a marketplace mobile app for Burundi with integrated delivery. The project will eventually have **3 separate apps**:

1. **Customer App** (this codebase) - For buyers to browse, order, and track deliveries
2. **Driver App** (separate codebase - future) - For delivery personnel
3. **Admin App** (separate codebase - future) - For platform administrators

---

## Current Focus: Customer App

We are currently developing the **Customer/Client** facing features only.

### Active Features (In Development)

| Feature | Directory | Status |
|---------|-----------|--------|
| Authentication | `lib/features/auth/` | 🟡 In Progress |
| Home/Discovery | `lib/features/home/` | 🟡 In Progress |
| Shop Browsing | `lib/features/shop/` | 🟡 In Progress |
| Product Catalog | `lib/features/product/` | 🟡 In Progress |
| Shopping Cart | `lib/features/cart/` | 🟡 In Progress |
| Orders & Checkout | `lib/features/orders/` | 🟡 In Progress |
| Order Tracking | `lib/features/orders/` | 🔴 Not Started |
| Profile | `lib/features/profile/` | 🟡 In Progress |
| Notifications | `lib/features/notifications/` | 🟡 In Progress |
| Reviews | `lib/features/review/` | 🔴 Not Started |
| Payment | `lib/features/payment/` | 🟡 In Progress |

### Dormant Features (Not in Scope for Customer App)

These features exist in the codebase but are **NOT being actively developed**. They will be moved to separate apps later.

| Feature | Directory | Target App |
|---------|-----------|------------|
| Admin Dashboard | `lib/features/admin/` | Admin App |
| Driver Deliveries | `lib/features/driver/` | Driver App |
| User Management | `lib/features/admin/` | Admin App |
| Shop Management | `lib/features/admin/` | Admin App |

---

## Core Modules (Shared)

These are actively maintained and used by the Customer App:

```
lib/core/
├── config/          # App & API configuration
├── constants/       # App constants, assets, endpoints
├── di/              # Dependency injection
├── errors/          # Error handling
├── network/         # API client, network utilities
├── router/          # Navigation (GoRouter)
├── services/        # Shared services (toast, etc.)
├── storage/         # Secure storage
├── theme/           # Colors, typography, theme (Dark Mode)
├── utils/           # Extensions, validators, logger
└── widgets/         # Reusable UI components
```

---

## Design System

### Theme
- **Mode:** Dark theme only
- **Font:** Plus Jakarta Sans (via Google Fonts)

### Brand Colors (from logo)
| Color | Hex | Usage |
|-------|-----|-------|
| Gura Red | `#E43225` | Primary accent, buttons, CTAs |
| Gura Orange | `#F7971D` | Secondary accent, warnings |
| Gura Blue | `#0064D3` | Info states, links |
| White | `#FFFFFF` | Text on colored backgrounds |

### Key Files
- `lib/core/theme/app_colors.dart` - Color palette
- `lib/core/theme/app_theme.dart` - Material theme
- `lib/core/theme/app_text_styles.dart` - Typography
- `lib/core/constants/app_assets.dart` - Asset paths

---

## Customer App User Flows

### 1. Onboarding & Auth
```
Splash → Login/Register → Home
```

### 2. Shopping Flow
```
Home → Browse Shops → Shop Detail → Product Detail → Add to Cart → Cart → Checkout → Order Confirmation
```

### 3. Order Tracking
```
Orders List → Order Detail → Track Delivery
```

### 4. Profile & Settings
```
Profile → Edit Profile / Settings / Order History
```

---

## Notes for Contributors

1. **Focus on customer features** - Do not modify admin/driver features
2. **Dark theme only** - Use `AppColors` and `AppTextStyles` for consistency
3. **State management** - Using BLoC pattern
4. **Navigation** - Using GoRouter with BLoC integration
5. **Clean Architecture** - Follow the existing feature folder structure

### Feature Structure
```
lib/features/{feature_name}/
├── data/
│   ├── datasources/    # Remote/Local data sources
│   ├── models/         # Data models (JSON serialization)
│   └── repositories/   # Repository implementations
├── domain/
│   ├── entities/       # Business entities
│   ├── repositories/   # Repository interfaces
│   └── usecases/       # Business logic
└── presentation/
    ├── bloc/           # State management
    ├── pages/          # Screens
    └── widgets/        # Feature-specific widgets
```

---

## Backend

The backend is in `../gura_now_backend/` (FastAPI + Python).

API Base URL is configured in `lib/core/config/api_config.dart`.
