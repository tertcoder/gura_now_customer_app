# 🧠 Domain Layer Guide

> The Domain Layer is the **heart of your application** - pure business logic with no external dependencies.

---

## 🎯 Purpose

The Domain Layer contains:
- **Entities** - Core business objects
- **Repository Interfaces** - What data operations are available
- **Use Cases** - Individual business actions

---

## ⚠️ Critical Rules

1. **NO Flutter imports** - Pure Dart only
2. **NO external dependencies** (except `dartz`, `equatable`)
3. **NO implementation details** - Only abstractions
4. **NO JSON serialization** - That's the Data layer's job

---

## 📁 Structure

```
features/[feature]/domain/
├── entities/
│   └── product.dart           # Business object
├── repositories/
│   └── product_repository.dart # Abstract interface
└── usecases/
    ├── get_products_usecase.dart
    ├── create_product_usecase.dart
    └── delete_product_usecase.dart
```

---

## 📦 Entities

### What is an Entity?

An Entity represents a **core business object** in your application. It:
- Contains only data (fields)
- Has no behavior/methods (except maybe computed properties)
- Uses Equatable for value equality
- Is immutable (all fields are `final`)

### Entity Template

```dart
import 'package:equatable/equatable.dart';

/// Product entity - represents a product in the business domain
class Product extends Equatable {
  final String id;
  final String name;
  final double price;
  final String category;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    this.imageUrl,
    required this.createdAt,
    this.updatedAt,
  });

  /// Computed property (allowed in entities)
  bool get isExpensive => price > 1000;

  /// Copy with method for immutability
  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? category,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id, name, price, category, imageUrl, createdAt, updatedAt,
  ];
}
```

### Entity with Enums

```dart
import 'package:equatable/equatable.dart';

/// Order status enum
enum OrderStatus {
  pending,
  confirmed,
  shipped,
  delivered,
  cancelled,
}

/// Order entity with status enum
class Order extends Equatable {
  final String id;
  final String customerId;
  final List<OrderItem> items;
  final double totalAmount;
  final OrderStatus status;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.customerId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  /// Check if order can be cancelled
  bool get canBeCancelled => 
      status == OrderStatus.pending || status == OrderStatus.confirmed;

  @override
  List<Object?> get props => [
    id, customerId, items, totalAmount, status, createdAt,
  ];
}

/// Order item (nested entity)
class OrderItem extends Equatable {
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  double get subtotal => quantity * unitPrice;

  @override
  List<Object?> get props => [productId, productName, quantity, unitPrice];
}
```

---

## 🔌 Repository Interfaces

### What is a Repository Interface?

A Repository Interface defines:
- What data operations are available
- Input and output types
- Uses `Either<Failure, T>` for error handling

### Repository Interface Template

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';

/// Abstract repository interface
/// Defines what operations are available for Products
/// Implementation is in the Data layer
abstract class ProductRepository {
  /// Get all products, optionally filtered by category
  Future<Either<Failure, List<Product>>> getProducts({String? category});
  
  /// Get a single product by ID
  Future<Either<Failure, Product>> getProductById(String id);
  
  /// Create a new product
  Future<Either<Failure, Product>> createProduct({
    required String name,
    required double price,
    required String category,
    String? imageUrl,
  });
  
  /// Update an existing product
  Future<Either<Failure, Product>> updateProduct({
    required String id,
    required String name,
    required double price,
    required String category,
    String? imageUrl,
  });
  
  /// Delete a product
  Future<Either<Failure, void>> deleteProduct(String id);
  
  /// Search products
  Future<Either<Failure, List<Product>>> searchProducts(String query);
}
```

---

## ⚡ Use Cases

### What is a Use Case?

A Use Case represents a **single action** that a user can perform. It:
- Has one public method: `call()`
- Takes a Params object as input
- Returns `Either<Failure, T>`
- Depends only on repository interfaces

### Base UseCase Interface

```dart
// core/usecases/usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../errors/failures.dart';

/// Base interface for all use cases
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use when no parameters are needed
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
```

### UseCase WITHOUT Parameters

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Get all products use case
class GetProductsUsecase implements UseCase<List<Product>, NoParams> {
  final ProductRepository repository;

  GetProductsUsecase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) async {
    return await repository.getProducts();
  }
}
```

### UseCase WITH Parameters

```dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Create product use case
class CreateProductUsecase implements UseCase<Product, CreateProductParams> {
  final ProductRepository repository;

  CreateProductUsecase(this.repository);

  @override
  Future<Either<Failure, Product>> call(CreateProductParams params) async {
    return await repository.createProduct(
      name: params.name,
      price: params.price,
      category: params.category,
      imageUrl: params.imageUrl,
    );
  }
}

/// Parameters for CreateProductUsecase
class CreateProductParams extends Equatable {
  final String name;
  final double price;
  final String category;
  final String? imageUrl;

  const CreateProductParams({
    required this.name,
    required this.price,
    required this.category,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [name, price, category, imageUrl];
}
```

### UseCase WITH Single Parameter

```dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Get product by ID use case
class GetProductByIdUsecase implements UseCase<Product, GetProductByIdParams> {
  final ProductRepository repository;

  GetProductByIdUsecase(this.repository);

  @override
  Future<Either<Failure, Product>> call(GetProductByIdParams params) async {
    return await repository.getProductById(params.id);
  }
}

/// Parameters for GetProductByIdUsecase
class GetProductByIdParams extends Equatable {
  final String id;

  const GetProductByIdParams(this.id);

  @override
  List<Object> get props => [id];
}
```

### UseCase WITH void Return

```dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/product_repository.dart';

/// Delete product use case
class DeleteProductUsecase implements UseCase<void, DeleteProductParams> {
  final ProductRepository repository;

  DeleteProductUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteProductParams params) async {
    return await repository.deleteProduct(params.id);
  }
}

/// Parameters for DeleteProductUsecase
class DeleteProductParams extends Equatable {
  final String id;

  const DeleteProductParams(this.id);

  @override
  List<Object> get props => [id];
}
```

### UseCase WITH Business Logic

Sometimes a use case needs to coordinate multiple repository calls:

```dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';
import '../repositories/inventory_repository.dart';

/// Place order use case with business logic
class PlaceOrderUsecase implements UseCase<Order, PlaceOrderParams> {
  final OrderRepository orderRepository;
  final InventoryRepository inventoryRepository;

  PlaceOrderUsecase(this.orderRepository, this.inventoryRepository);

  @override
  Future<Either<Failure, Order>> call(PlaceOrderParams params) async {
    // Business logic: Check inventory first
    for (final item in params.items) {
      final stockResult = await inventoryRepository.checkStock(item.productId);
      
      final hasStock = stockResult.fold(
        (failure) => false,
        (stock) => stock >= item.quantity,
      );
      
      if (!hasStock) {
        return Left(BusinessFailure(
          'Insufficient stock for ${item.productName}',
        ));
      }
    }

    // Create the order
    final orderResult = await orderRepository.createOrder(
      customerId: params.customerId,
      items: params.items,
    );

    // Reserve inventory
    return orderResult.fold(
      (failure) => Left(failure),
      (order) async {
        for (final item in params.items) {
          await inventoryRepository.reserveStock(
            item.productId,
            item.quantity,
          );
        }
        return Right(order);
      },
    );
  }
}

class PlaceOrderParams extends Equatable {
  final String customerId;
  final List<OrderItem> items;

  const PlaceOrderParams({
    required this.customerId,
    required this.items,
  });

  @override
  List<Object> get props => [customerId, items];
}
```

---

## 🏆 Best Practices

### 1. One Use Case = One Action
```dart
// ✅ Good - Single responsibility
class LoginUsecase { ... }
class RegisterUsecase { ... }
class ForgotPasswordUsecase { ... }

// ❌ Bad - Too many responsibilities
class AuthUsecase {
  login() { ... }
  register() { ... }
  forgotPassword() { ... }
}
```

### 2. Use Params for Multiple Arguments
```dart
// ✅ Good - Using Params class
class CreateProductUsecase implements UseCase<Product, CreateProductParams> { }

class CreateProductParams extends Equatable {
  final String name;
  final double price;
  // ...
}

// ❌ Bad - Multiple loose parameters
class CreateProductUsecase {
  call(String name, double price, String category, String? image) { }
}
```

### 3. Entities are Immutable
```dart
// ✅ Good - Immutable with copyWith
final updatedProduct = product.copyWith(price: 99.99);

// ❌ Bad - Mutable
product.price = 99.99;
```

### 4. Keep Domain Pure
```dart
// ✅ Good - Pure Dart imports only
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

// ❌ Bad - Flutter/external imports
import 'package:flutter/material.dart';
import 'dart:convert';
```

---

## 📋 Checklist for Domain Layer

- [ ] Create Entity with Equatable
- [ ] Entity has no Flutter imports
- [ ] Entity has all required fields as `final`
- [ ] Entity has `props` getter for Equatable
- [ ] Create Repository interface (abstract class)
- [ ] Repository methods return `Either<Failure, T>`
- [ ] Create UseCase for each action
- [ ] UseCase implements `UseCase<Type, Params>`
- [ ] Create Params class extending Equatable
- [ ] UseCase depends only on repository interface

