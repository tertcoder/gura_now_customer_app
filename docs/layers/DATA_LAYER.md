# 📦 Data Layer Guide

> The Data Layer handles **all external data operations** - API calls, database operations, and caching.

---

## 🎯 Purpose

The Data Layer is responsible for:

- Fetching data from remote APIs
- Storing/retrieving data from local storage
- Converting between JSON and Dart objects
- Implementing repository interfaces from the Domain layer

---

## 📁 Structure

```
features/[feature]/data/
├── datasources/
│   ├── [feature]_remote_datasource.dart   # API calls
│   └── [feature]_local_datasource.dart    # Local storage
├── models/
│   └── [entity]_model.dart                # Data transfer objects
└── repositories/
    └── [feature]_repository_impl.dart     # Implements domain interface
```

---

## 📋 Models

### What is a Model?

A Model is a **Data Transfer Object (DTO)** that:

- Extends the Domain Entity
- Adds JSON serialization (`fromJson`, `toJson`)
- Handles data transformation

### Model Template

```dart
import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.price,
    required super.category,
    super.imageUrl,
    required super.createdAt,
  });

  // ═══════════════════════════════════════════════════════════════
  // JSON SERIALIZATION
  // ═══════════════════════════════════════════════════════════════

  /// JSON → Model
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? json['image_url'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  /// Model → JSON (for sending to API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Entity → Model (for caching domain entities)
  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      price: product.price,
      category: product.category,
      imageUrl: product.imageUrl,
      createdAt: product.createdAt,
    );
  }
}
```

### Handling Different API Formats

```dart
factory ProductModel.fromJson(Map<String, dynamic> json) {
  // Handle multiple possible key names
  final id = json['id'] ?? json['_id'] ?? json['productId'] ?? '';

  // Handle nested objects
  final categoryData = json['category'];
  String category;
  if (categoryData is String) {
    category = categoryData;
  } else if (categoryData is Map) {
    category = categoryData['name'] ?? '';
  } else {
    category = '';
  }

  // Handle different date formats
  DateTime createdAt;
  if (json['createdAt'] is String) {
    createdAt = DateTime.parse(json['createdAt']);
  } else if (json['createdAt'] is int) {
    createdAt = DateTime.fromMillisecondsSinceEpoch(json['createdAt']);
  } else {
    createdAt = DateTime.now();
  }

  return ProductModel(
    id: id,
    name: json['name'] ?? '',
    price: (json['price'] ?? 0).toDouble(),
    category: category,
    createdAt: createdAt,
  );
}
```

---

## 📡 Remote DataSource

### What is a Remote DataSource?

The Remote DataSource:

- Makes HTTP calls to your backend API
- Returns Models (not Entities)
- Throws Exceptions on errors

### Remote DataSource Template

```dart
import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/product_model.dart';

/// Abstract interface - defines what operations are available
abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({String? category});
  Future<ProductModel> getProductById(String id);
  Future<ProductModel> createProduct(Map<String, dynamic> data);
  Future<ProductModel> updateProduct(String id, Map<String, dynamic> data);
  Future<void> deleteProduct(String id);
}

/// Implementation - actually makes the API calls
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSourceImpl({required this.apiClient});

  // ═══════════════════════════════════════════════════════════════
  // GET ALL
  // ═══════════════════════════════════════════════════════════════
  @override
  Future<List<ProductModel>> getProducts({String? category}) async {
    try {
      final queryParams = category != null ? {'category': category} : null;

      final response = await apiClient.get(
        ApiConfig.products,
        queryParams: queryParams,
      );

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> productsJson = response['data']['products'];
        return productsJson
            .map((json) => ProductModel.fromJson(json))
            .toList();
      } else {
        throw ServerException(response['message'] ?? 'Failed to get products');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to get products: ${e.toString()}');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // GET BY ID
  // ═══════════════════════════════════════════════════════════════
  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await apiClient.get(ApiConfig.productById(id));

      if (response['success'] == true && response['data'] != null) {
        return ProductModel.fromJson(response['data']['product']);
      } else {
        throw ServerException(response['message'] ?? 'Product not found');
      }
    } on NotFoundException {
      throw const NotFoundException('Product not found');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to get product: ${e.toString()}');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // CREATE
  // ═══════════════════════════════════════════════════════════════
  @override
  Future<ProductModel> createProduct(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.post(ApiConfig.products, data);

      if (response['success'] == true && response['data'] != null) {
        return ProductModel.fromJson(response['data']['product']);
      } else {
        throw ServerException(response['message'] ?? 'Failed to create product');
      }
    } on ValidationException catch (e) {
      throw ValidationException(e.message, e.errors);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to create product: ${e.toString()}');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // UPDATE
  // ═══════════════════════════════════════════════════════════════
  @override
  Future<ProductModel> updateProduct(String id, Map<String, dynamic> data) async {
    try {
      final response = await apiClient.put(ApiConfig.productById(id), data);

      if (response['success'] == true && response['data'] != null) {
        return ProductModel.fromJson(response['data']['product']);
      } else {
        throw ServerException(response['message'] ?? 'Failed to update product');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to update product: ${e.toString()}');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // DELETE
  // ═══════════════════════════════════════════════════════════════
  @override
  Future<void> deleteProduct(String id) async {
    try {
      final response = await apiClient.delete(ApiConfig.productById(id));

      if (response['success'] != true) {
        throw ServerException(response['message'] ?? 'Failed to delete product');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to delete product: ${e.toString()}');
    }
  }
}
```

---

## 💾 Local DataSource

### What is a Local DataSource?

The Local DataSource:

- Handles local storage (SharedPreferences, SQLite, Hive)
- Provides caching for offline support
- Stores user preferences and session data

### Local DataSource Template (SharedPreferences)

```dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getCachedProducts();
  Future<void> cacheProducts(List<ProductModel> products);
  Future<ProductModel?> getCachedProduct(String id);
  Future<void> cacheProduct(ProductModel product);
  Future<void> clearProductCache();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences prefs;

  static const String _productsKey = 'CACHED_PRODUCTS';
  static const String _productPrefix = 'CACHED_PRODUCT_';

  ProductLocalDataSourceImpl({required this.prefs});

  // ═══════════════════════════════════════════════════════════════
  // GET CACHED LIST
  // ═══════════════════════════════════════════════════════════════
  @override
  Future<List<ProductModel>> getCachedProducts() async {
    final jsonString = prefs.getString(_productsKey);

    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList
            .map((json) => ProductModel.fromJson(json))
            .toList();
      } catch (e) {
        throw CacheException('Failed to parse cached products');
      }
    }

    return [];
  }

  // ═══════════════════════════════════════════════════════════════
  // CACHE LIST
  // ═══════════════════════════════════════════════════════════════
  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final jsonList = products.map((p) => p.toJson()).toList();
    await prefs.setString(_productsKey, jsonEncode(jsonList));
  }

  // ═══════════════════════════════════════════════════════════════
  // GET SINGLE CACHED
  // ═══════════════════════════════════════════════════════════════
  @override
  Future<ProductModel?> getCachedProduct(String id) async {
    final jsonString = prefs.getString('$_productPrefix$id');

    if (jsonString != null) {
      try {
        return ProductModel.fromJson(jsonDecode(jsonString));
      } catch (e) {
        return null;
      }
    }

    return null;
  }

  // ═══════════════════════════════════════════════════════════════
  // CACHE SINGLE
  // ═══════════════════════════════════════════════════════════════
  @override
  Future<void> cacheProduct(ProductModel product) async {
    await prefs.setString(
      '$_productPrefix${product.id}',
      jsonEncode(product.toJson()),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // CLEAR CACHE
  // ═══════════════════════════════════════════════════════════════
  @override
  Future<void> clearProductCache() async {
    await prefs.remove(_productsKey);

    // Clear individual products
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_productPrefix)) {
        await prefs.remove(key);
      }
    }
  }
}
```

---

## 🏗 Repository Implementation

### What is a Repository Implementation?

The Repository Implementation:

- Implements the abstract interface from Domain layer
- Coordinates between remote and local data sources
- Converts Exceptions to Failures using `Either`
- Decides when to use cache vs network

### Repository Implementation Template

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../datasources/product_local_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  // ═══════════════════════════════════════════════════════════════
  // GET ALL (with cache fallback)
  // ═══════════════════════════════════════════════════════════════
  @override
  Future<Either<Failure, List<Product>>> getProducts({String? category}) async {
    try {
      // Try remote first
      final products = await remoteDataSource.getProducts(category: category);

      // Cache the results
      await localDataSource.cacheProducts(products);

      return Right(products);
    } on ServerException catch (e) {
      // On network error, try cache
      try {
        final cachedProducts = await localDataSource.getCachedProducts();
        if (cachedProducts.isNotEmpty) {
          return Right(cachedProducts);
        }
      } catch (_) {}

      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      // On network error, try cache
      try {
        final cachedProducts = await localDataSource.getCachedProducts();
        if (cachedProducts.isNotEmpty) {
          return Right(cachedProducts);
        }
      } catch (_) {}

      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // GET BY ID (with cache fallback)
  // ═══════════════════════════════════════════════════════════════
  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    try {
      final product = await remoteDataSource.getProductById(id);
      await localDataSource.cacheProduct(product);
      return Right(product);
    } on NotFoundException catch (e) {
      return Left(ServerFailure(e.message));
    } on ServerException catch (e) {
      // Try cache on error
      final cached = await localDataSource.getCachedProduct(id);
      if (cached != null) {
        return Right(cached);
      }
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // CREATE (no cache, always remote)
  // ═══════════════════════════════════════════════════════════════
  @override
  Future<Either<Failure, Product>> createProduct({
    required String name,
    required double price,
    required String category,
    String? imageUrl,
  }) async {
    try {
      final product = await remoteDataSource.createProduct({
        'name': name,
        'price': price,
        'category': category,
        if (imageUrl != null) 'imageUrl': imageUrl,
      });

      // Invalidate list cache
      await localDataSource.clearProductCache();

      return Right(product);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // UPDATE
  // ═══════════════════════════════════════════════════════════════
  @override
  Future<Either<Failure, Product>> updateProduct({
    required String id,
    required String name,
    required double price,
    required String category,
    String? imageUrl,
  }) async {
    try {
      final product = await remoteDataSource.updateProduct(id, {
        'name': name,
        'price': price,
        'category': category,
        if (imageUrl != null) 'imageUrl': imageUrl,
      });

      // Update cache
      await localDataSource.cacheProduct(product);

      return Right(product);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // DELETE
  // ═══════════════════════════════════════════════════════════════
  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await remoteDataSource.deleteProduct(id);

      // Clear cache
      await localDataSource.clearProductCache();

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
```

---

## 🔑 Key Rules

1. **Models extend Entities** - Never the other way around
2. **DataSources throw Exceptions** - Not Failures
3. **Repositories return Either** - Converting Exceptions to Failures
4. **Use interfaces** - Abstract classes for testability
5. **Cache strategically** - Not everything needs caching

---

## 📋 Checklist for Data Layer

- [ ] Create Model extending Entity
- [ ] Implement `fromJson` and `toJson`
- [ ] Create Remote DataSource interface
- [ ] Implement Remote DataSource
- [ ] Create Local DataSource interface (if caching needed)
- [ ] Implement Local DataSource
- [ ] Implement Repository from Domain interface
- [ ] Handle all exceptions properly
- [ ] Return Either<Failure, T> from repository
