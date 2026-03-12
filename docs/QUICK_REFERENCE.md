# 📋 Flutter Clean Architecture - Quick Reference

> **Copy-paste templates for rapid development**

---

## 🚀 New Feature Scaffold Script

Run this in your terminal from the `lib/` directory:

```bash
# Create feature structure
FEATURE="feature_name"  # Change this!

mkdir -p features/$FEATURE/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}

# Create empty files
touch features/$FEATURE/data/datasources/${FEATURE}_remote_datasource.dart
touch features/$FEATURE/data/datasources/${FEATURE}_local_datasource.dart
touch features/$FEATURE/data/models/${FEATURE}_model.dart
touch features/$FEATURE/data/repositories/${FEATURE}_repository_impl.dart
touch features/$FEATURE/domain/entities/${FEATURE}.dart
touch features/$FEATURE/domain/repositories/${FEATURE}_repository.dart
touch features/$FEATURE/domain/usecases/get_${FEATURE}_usecase.dart
touch features/$FEATURE/presentation/bloc/${FEATURE}_bloc.dart
touch features/$FEATURE/presentation/bloc/${FEATURE}_event.dart
touch features/$FEATURE/presentation/bloc/${FEATURE}_state.dart
touch features/$FEATURE/presentation/pages/${FEATURE}_screen.dart
touch features/$FEATURE/${FEATURE}.dart
```

---

## 📦 Domain Layer Templates

### Entity

```dart
import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;

  const Item({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, description, createdAt];
}
```

### Repository Interface

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/item.dart';

abstract class ItemRepository {
  Future<Either<Failure, List<Item>>> getItems();
  Future<Either<Failure, Item>> getItemById(String id);
  Future<Either<Failure, Item>> createItem(String name, String description);
  Future<Either<Failure, Item>> updateItem(String id, String name, String description);
  Future<Either<Failure, void>> deleteItem(String id);
}
```

### UseCase (with params)

```dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/item.dart';
import '../repositories/item_repository.dart';

class CreateItemUsecase implements UseCase<Item, CreateItemParams> {
  final ItemRepository repository;

  CreateItemUsecase(this.repository);

  @override
  Future<Either<Failure, Item>> call(CreateItemParams params) async {
    return await repository.createItem(params.name, params.description);
  }
}

class CreateItemParams extends Equatable {
  final String name;
  final String description;

  const CreateItemParams({
    required this.name,
    required this.description,
  });

  @override
  List<Object> get props => [name, description];
}
```

### UseCase (without params)

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/item.dart';
import '../repositories/item_repository.dart';

class GetItemsUsecase implements UseCase<List<Item>, NoParams> {
  final ItemRepository repository;

  GetItemsUsecase(this.repository);

  @override
  Future<Either<Failure, List<Item>>> call(NoParams params) async {
    return await repository.getItems();
  }
}
```

---

## 📦 Data Layer Templates

### Model

```dart
import '../../domain/entities/item.dart';

class ItemModel extends Item {
  const ItemModel({
    required super.id,
    required super.name,
    required super.description,
    required super.createdAt,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ItemModel.fromEntity(Item item) {
    return ItemModel(
      id: item.id,
      name: item.name,
      description: item.description,
      createdAt: item.createdAt,
    );
  }
}
```

### Remote DataSource

```dart
import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/item_model.dart';

abstract class ItemRemoteDataSource {
  Future<List<ItemModel>> getItems();
  Future<ItemModel> getItemById(String id);
  Future<ItemModel> createItem(String name, String description);
  Future<ItemModel> updateItem(String id, String name, String description);
  Future<void> deleteItem(String id);
}

class ItemRemoteDataSourceImpl implements ItemRemoteDataSource {
  final ApiClient apiClient;

  ItemRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ItemModel>> getItems() async {
    try {
      final response = await apiClient.get(ApiConfig.items);

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> itemsJson = response['data']['items'];
        return itemsJson.map((json) => ItemModel.fromJson(json)).toList();
      } else {
        throw ServerException(response['message'] ?? 'Failed to get items');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to get items: ${e.toString()}');
    }
  }

  @override
  Future<ItemModel> getItemById(String id) async {
    try {
      final response = await apiClient.get(ApiConfig.itemById(id));

      if (response['success'] == true && response['data'] != null) {
        return ItemModel.fromJson(response['data']['item']);
      } else {
        throw ServerException(response['message'] ?? 'Failed to get item');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to get item: ${e.toString()}');
    }
  }

  @override
  Future<ItemModel> createItem(String name, String description) async {
    try {
      final response = await apiClient.post(
        ApiConfig.items,
        {'name': name, 'description': description},
      );

      if (response['success'] == true && response['data'] != null) {
        return ItemModel.fromJson(response['data']['item']);
      } else {
        throw ServerException(response['message'] ?? 'Failed to create item');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to create item: ${e.toString()}');
    }
  }

  @override
  Future<ItemModel> updateItem(String id, String name, String description) async {
    try {
      final response = await apiClient.put(
        ApiConfig.itemById(id),
        {'name': name, 'description': description},
      );

      if (response['success'] == true && response['data'] != null) {
        return ItemModel.fromJson(response['data']['item']);
      } else {
        throw ServerException(response['message'] ?? 'Failed to update item');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to update item: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteItem(String id) async {
    try {
      final response = await apiClient.delete(ApiConfig.itemById(id));

      if (response['success'] != true) {
        throw ServerException(response['message'] ?? 'Failed to delete item');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to delete item: ${e.toString()}');
    }
  }
}
```

### Local DataSource (with SharedPreferences)

```dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/item_model.dart';

abstract class ItemLocalDataSource {
  Future<List<ItemModel>> getCachedItems();
  Future<void> cacheItems(List<ItemModel> items);
  Future<void> clearCache();
}

class ItemLocalDataSourceImpl implements ItemLocalDataSource {
  final SharedPreferences prefs;
  static const String cacheKey = 'CACHED_ITEMS';

  ItemLocalDataSourceImpl({required this.prefs});

  @override
  Future<List<ItemModel>> getCachedItems() async {
    final jsonString = prefs.getString(cacheKey);
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((json) => ItemModel.fromJson(json)).toList();
      } catch (e) {
        throw CacheException('Failed to parse cached items');
      }
    }
    return [];
  }

  @override
  Future<void> cacheItems(List<ItemModel> items) async {
    final jsonList = items.map((item) => item.toJson()).toList();
    await prefs.setString(cacheKey, jsonEncode(jsonList));
  }

  @override
  Future<void> clearCache() async {
    await prefs.remove(cacheKey);
  }
}
```

### Repository Implementation

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/item.dart';
import '../../domain/repositories/item_repository.dart';
import '../datasources/item_remote_datasource.dart';
import '../datasources/item_local_datasource.dart';

class ItemRepositoryImpl implements ItemRepository {
  final ItemRemoteDataSource remoteDataSource;
  final ItemLocalDataSource localDataSource;

  ItemRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Item>>> getItems() async {
    try {
      final items = await remoteDataSource.getItems();
      await localDataSource.cacheItems(items);
      return Right(items);
    } on ServerException catch (e) {
      // Try cache on network error
      try {
        final cachedItems = await localDataSource.getCachedItems();
        if (cachedItems.isNotEmpty) {
          return Right(cachedItems);
        }
      } catch (_) {}
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Item>> getItemById(String id) async {
    try {
      final item = await remoteDataSource.getItemById(id);
      return Right(item);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Item>> createItem(String name, String description) async {
    try {
      final item = await remoteDataSource.createItem(name, description);
      return Right(item);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Item>> updateItem(String id, String name, String description) async {
    try {
      final item = await remoteDataSource.updateItem(id, name, description);
      return Right(item);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteItem(String id) async {
    try {
      await remoteDataSource.deleteItem(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
```

---

## 🎨 Presentation Layer Templates

### BLoC

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/item.dart';
import '../../domain/usecases/get_items_usecase.dart';
import '../../domain/usecases/create_item_usecase.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final GetItemsUsecase getItemsUsecase;
  final CreateItemUsecase createItemUsecase;

  ItemBloc({
    required this.getItemsUsecase,
    required this.createItemUsecase,
  }) : super(ItemInitial()) {
    on<GetItemsRequested>(_onGetItemsRequested);
    on<CreateItemRequested>(_onCreateItemRequested);
  }

  Future<void> _onGetItemsRequested(
    GetItemsRequested event,
    Emitter<ItemState> emit,
  ) async {
    emit(ItemLoading());

    final result = await getItemsUsecase(NoParams());

    result.fold(
      (failure) => emit(ItemError(failure.message)),
      (items) => emit(ItemLoaded(items)),
    );
  }

  Future<void> _onCreateItemRequested(
    CreateItemRequested event,
    Emitter<ItemState> emit,
  ) async {
    emit(ItemLoading());

    final result = await createItemUsecase(
      CreateItemParams(name: event.name, description: event.description),
    );

    result.fold(
      (failure) => emit(ItemError(failure.message)),
      (item) {
        // Optionally reload all items or add to current list
        add(GetItemsRequested());
      },
    );
  }
}
```

### Events

```dart
part of 'item_bloc.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();

  @override
  List<Object?> get props => [];
}

class GetItemsRequested extends ItemEvent {}

class CreateItemRequested extends ItemEvent {
  final String name;
  final String description;

  const CreateItemRequested({
    required this.name,
    required this.description,
  });

  @override
  List<Object> get props => [name, description];
}

class UpdateItemRequested extends ItemEvent {
  final String id;
  final String name;
  final String description;

  const UpdateItemRequested({
    required this.id,
    required this.name,
    required this.description,
  });

  @override
  List<Object> get props => [id, name, description];
}

class DeleteItemRequested extends ItemEvent {
  final String id;

  const DeleteItemRequested(this.id);

  @override
  List<Object> get props => [id];
}
```

### States

```dart
part of 'item_bloc.dart';

abstract class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object?> get props => [];
}

class ItemInitial extends ItemState {}

class ItemLoading extends ItemState {}

class ItemLoaded extends ItemState {
  final List<Item> items;

  const ItemLoaded(this.items);

  @override
  List<Object> get props => [items];
}

class ItemDetailLoaded extends ItemState {
  final Item item;

  const ItemDetailLoaded(this.item);

  @override
  List<Object> get props => [item];
}

class ItemError extends ItemState {
  final String message;

  const ItemError(this.message);

  @override
  List<Object> get props => [message];
}

class ItemOperationSuccess extends ItemState {
  final String message;

  const ItemOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}
```

### List Screen

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/empty_state.dart';
import '../bloc/item_bloc.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ItemBloc>().add(GetItemsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/items/create'),
          ),
        ],
      ),
      body: BlocConsumer<ItemBloc, ItemState>(
        listener: (context, state) {
          if (state is ItemError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ItemLoading) {
            return const LoadingIndicator();
          }

          if (state is ItemLoaded) {
            if (state.items.isEmpty) {
              return const EmptyState(
                icon: Icons.inbox,
                title: 'No items yet',
                subtitle: 'Create your first item',
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ItemBloc>().add(GetItemsRequested());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text(item.description),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/items/${item.id}'),
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
```

### Create/Form Screen

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/item_bloc.dart';

class CreateItemScreen extends StatefulWidget {
  const CreateItemScreen({super.key});

  @override
  State<CreateItemScreen> createState() => _CreateItemScreenState();
}

class _CreateItemScreenState extends State<CreateItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<ItemBloc>().add(
        CreateItemRequested(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Item'),
      ),
      body: BlocListener<ItemBloc, ItemState>(
        listener: (context, state) {
          if (state is ItemError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is ItemLoaded) {
            // Successfully created, go back
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Item created successfully'),
                backgroundColor: AppColors.success,
              ),
            );
            context.pop();
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  label: 'Name',
                  hint: 'Enter item name',
                  controller: _nameController,
                  validator: Validators.required,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Description',
                  hint: 'Enter description',
                  controller: _descriptionController,
                  maxLines: 4,
                  validator: Validators.required,
                ),
                const SizedBox(height: 32),
                BlocBuilder<ItemBloc, ItemState>(
                  builder: (context, state) {
                    return CustomButton(
                      label: 'Create Item',
                      onPressed: _handleSubmit,
                      isLoading: state is ItemLoading,
                      isFullWidth: true,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 🛠 Dependency Injection Template

```dart
void _initItem() {
  // BLoC
  sl.registerFactory(() => ItemBloc(
    getItemsUsecase: sl(),
    createItemUsecase: sl(),
  ));

  // Use Cases
  sl.registerLazySingleton(() => GetItemsUsecase(sl()));
  sl.registerLazySingleton(() => CreateItemUsecase(sl()));

  // Repository
  sl.registerLazySingleton<ItemRepository>(
    () => ItemRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<ItemRemoteDataSource>(
    () => ItemRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<ItemLocalDataSource>(
    () => ItemLocalDataSourceImpl(prefs: sl()),
  );
}
```

---

## 🧭 Router Template

```dart
// In AppRouter.routes[]
GoRoute(
  path: '/items',
  name: 'items',
  builder: (context, state) => const ItemListScreen(),
  routes: [
    GoRoute(
      path: 'create',
      name: 'createItem',
      builder: (context, state) => const CreateItemScreen(),
    ),
    GoRoute(
      path: ':id',
      name: 'itemDetail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ItemDetailScreen(itemId: id);
      },
    ),
  ],
),
```

---

## 📁 Barrel Export Template

```dart
// features/item/item.dart

// Domain - Entities
export 'domain/entities/item.dart';

// Domain - Repositories
export 'domain/repositories/item_repository.dart';

// Domain - Use Cases
export 'domain/usecases/get_items_usecase.dart';
export 'domain/usecases/create_item_usecase.dart';

// Data - Models
export 'data/models/item_model.dart';

// Data - Data Sources
export 'data/datasources/item_remote_datasource.dart';
export 'data/datasources/item_local_datasource.dart';

// Data - Repository
export 'data/repositories/item_repository_impl.dart';

// Presentation - BLoC
export 'presentation/bloc/item_bloc.dart';

// Presentation - Pages
export 'presentation/pages/item_list_screen.dart';
export 'presentation/pages/create_item_screen.dart';
```

---

## ⚡ Quick Commands

```bash
# Run app
flutter run

# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release

# Clean and get packages
flutter clean && flutter pub get

# Generate code (if using build_runner)
flutter pub run build_runner build --delete-conflicting-outputs

# Analyze code
flutter analyze

# Run tests
flutter test
```

---

## 📌 Common Patterns

### Loading + Error + Success Pattern

```dart
BlocConsumer<ItemBloc, ItemState>(
  listener: (context, state) {
    if (state is ItemError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
    if (state is ItemOperationSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
      context.pop();
    }
  },
  builder: (context, state) {
    if (state is ItemLoading) {
      return const LoadingIndicator();
    }
    if (state is ItemLoaded) {
      return ItemContent(items: state.items);
    }
    return const SizedBox.shrink();
  },
),
```

### Refresh Indicator with BLoC

```dart
RefreshIndicator(
  onRefresh: () async {
    context.read<ItemBloc>().add(GetItemsRequested());
    // Wait for state to change
    await context.read<ItemBloc>().stream.firstWhere(
      (state) => state is! ItemLoading,
    );
  },
  child: ListView(...),
),
```

### Form with Validation

```dart
Form(
  key: _formKey,
  child: Column(
    children: [
      CustomTextField(
        label: 'Email',
        controller: _emailController,
        validator: Validators.validateEmail,
      ),
      CustomButton(
        label: 'Submit',
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Submit
          }
        },
      ),
    ],
  ),
),
```

---

> 💡 **Tip**: Keep this file open while coding new features for quick copy-paste!
