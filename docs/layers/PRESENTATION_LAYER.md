# 🎨 Presentation Layer Guide

> The Presentation Layer handles **UI and user interactions** using BLoC for state management.

---

## 🎯 Purpose

The Presentation Layer contains:

- **BLoC** - Business Logic Component (state management)
- **Events** - User actions/triggers
- **States** - UI states
- **Pages** - Full screens
- **Widgets** - Reusable UI components

---

## 📁 Structure

```
features/[feature]/presentation/
├── bloc/
│   ├── product_bloc.dart      # BLoC logic
│   ├── product_event.dart     # User events
│   └── product_state.dart     # UI states
├── pages/
│   ├── product_list_screen.dart
│   ├── product_detail_screen.dart
│   └── create_product_screen.dart
└── widgets/
    ├── product_card.dart
    └── product_form.dart
```

---

## 🟦 BLoC (Business Logic Component)

### BLoC Flow

```
User Action → Event → BLoC → UseCase → State → UI Update
```

### BLoC Template

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/create_product_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUsecase getProductsUsecase;
  final CreateProductUsecase createProductUsecase;
  final UpdateProductUsecase updateProductUsecase;
  final DeleteProductUsecase deleteProductUsecase;

  ProductBloc({
    required this.getProductsUsecase,
    required this.createProductUsecase,
    required this.updateProductUsecase,
    required this.deleteProductUsecase,
  }) : super(ProductInitial()) {
    // Register event handlers
    on<GetProductsRequested>(_onGetProductsRequested);
    on<CreateProductRequested>(_onCreateProductRequested);
    on<UpdateProductRequested>(_onUpdateProductRequested);
    on<DeleteProductRequested>(_onDeleteProductRequested);
  }

  // ═══════════════════════════════════════════════════════════════
  // GET PRODUCTS
  // ═══════════════════════════════════════════════════════════════
  Future<void> _onGetProductsRequested(
    GetProductsRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    final result = await getProductsUsecase(NoParams());

    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(products)),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // CREATE PRODUCT
  // ═══════════════════════════════════════════════════════════════
  Future<void> _onCreateProductRequested(
    CreateProductRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    final result = await createProductUsecase(CreateProductParams(
      name: event.name,
      price: event.price,
      category: event.category,
      imageUrl: event.imageUrl,
    ));

    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (product) {
        emit(ProductOperationSuccess('Product created successfully'));
        // Reload the list
        add(GetProductsRequested());
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // UPDATE PRODUCT
  // ═══════════════════════════════════════════════════════════════
  Future<void> _onUpdateProductRequested(
    UpdateProductRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    final result = await updateProductUsecase(UpdateProductParams(
      id: event.id,
      name: event.name,
      price: event.price,
      category: event.category,
      imageUrl: event.imageUrl,
    ));

    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (product) {
        emit(ProductOperationSuccess('Product updated successfully'));
        add(GetProductsRequested());
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // DELETE PRODUCT
  // ═══════════════════════════════════════════════════════════════
  Future<void> _onDeleteProductRequested(
    DeleteProductRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    final result = await deleteProductUsecase(DeleteProductParams(event.id));

    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (_) {
        emit(ProductOperationSuccess('Product deleted successfully'));
        add(GetProductsRequested());
      },
    );
  }
}
```

---

## 📨 Events

### Event Rules

- Extend `Equatable` for comparison
- One event per user action
- Include all necessary data
- Use `const` constructors

### Events Template

```dart
part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

// ═══════════════════════════════════════════════════════════════
// GET PRODUCTS
// ═══════════════════════════════════════════════════════════════
class GetProductsRequested extends ProductEvent {
  final String? category;

  const GetProductsRequested({this.category});

  @override
  List<Object?> get props => [category];
}

// ═══════════════════════════════════════════════════════════════
// GET SINGLE PRODUCT
// ═══════════════════════════════════════════════════════════════
class GetProductByIdRequested extends ProductEvent {
  final String id;

  const GetProductByIdRequested(this.id);

  @override
  List<Object> get props => [id];
}

// ═══════════════════════════════════════════════════════════════
// CREATE PRODUCT
// ═══════════════════════════════════════════════════════════════
class CreateProductRequested extends ProductEvent {
  final String name;
  final double price;
  final String category;
  final String? imageUrl;

  const CreateProductRequested({
    required this.name,
    required this.price,
    required this.category,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [name, price, category, imageUrl];
}

// ═══════════════════════════════════════════════════════════════
// UPDATE PRODUCT
// ═══════════════════════════════════════════════════════════════
class UpdateProductRequested extends ProductEvent {
  final String id;
  final String name;
  final double price;
  final String category;
  final String? imageUrl;

  const UpdateProductRequested({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, price, category, imageUrl];
}

// ═══════════════════════════════════════════════════════════════
// DELETE PRODUCT
// ═══════════════════════════════════════════════════════════════
class DeleteProductRequested extends ProductEvent {
  final String id;

  const DeleteProductRequested(this.id);

  @override
  List<Object> get props => [id];
}

// ═══════════════════════════════════════════════════════════════
// SEARCH
// ═══════════════════════════════════════════════════════════════
class SearchProductsRequested extends ProductEvent {
  final String query;

  const SearchProductsRequested(this.query);

  @override
  List<Object> get props => [query];
}
```

---

## 📊 States

### State Rules

- Extend `Equatable` for comparison
- One state per UI condition
- Include necessary data for UI
- Use `const` constructors

### States Template

```dart
part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

// ═══════════════════════════════════════════════════════════════
// INITIAL STATE
// ═══════════════════════════════════════════════════════════════
class ProductInitial extends ProductState {}

// ═══════════════════════════════════════════════════════════════
// LOADING STATE
// ═══════════════════════════════════════════════════════════════
class ProductLoading extends ProductState {}

// ═══════════════════════════════════════════════════════════════
// LIST LOADED STATE
// ═══════════════════════════════════════════════════════════════
class ProductLoaded extends ProductState {
  final List<Product> products;

  const ProductLoaded(this.products);

  @override
  List<Object> get props => [products];

  /// Helper getter for empty check
  bool get isEmpty => products.isEmpty;

  /// Get products by category
  List<Product> byCategory(String category) {
    return products.where((p) => p.category == category).toList();
  }
}

// ═══════════════════════════════════════════════════════════════
// SINGLE ITEM LOADED STATE
// ═══════════════════════════════════════════════════════════════
class ProductDetailLoaded extends ProductState {
  final Product product;

  const ProductDetailLoaded(this.product);

  @override
  List<Object> get props => [product];
}

// ═══════════════════════════════════════════════════════════════
// ERROR STATE
// ═══════════════════════════════════════════════════════════════
class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}

// ═══════════════════════════════════════════════════════════════
// OPERATION SUCCESS STATE
// ═══════════════════════════════════════════════════════════════
class ProductOperationSuccess extends ProductState {
  final String message;

  const ProductOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}
```

---

## 📱 Pages/Screens

### List Screen Template

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_widget.dart' as custom;
import '../bloc/product_bloc.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    // Load data on init
    context.read<ProductBloc>().add(GetProductsRequested());
  }

  Future<void> _onRefresh() async {
    context.read<ProductBloc>().add(GetProductsRequested());
    // Wait for state to change
    await context.read<ProductBloc>().stream.firstWhere(
      (state) => state is! ProductLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to search
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/products/create'),
          ),
        ],
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        // ─────────────────────────────────────────────────────────
        // LISTENER: Handle side effects (snackbars, navigation)
        // ─────────────────────────────────────────────────────────
        listener: (context, state) {
          if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }

          if (state is ProductOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        // ─────────────────────────────────────────────────────────
        // BUILDER: Build UI based on state
        // ─────────────────────────────────────────────────────────
        builder: (context, state) {
          // Loading
          if (state is ProductLoading) {
            return const LoadingIndicator();
          }

          // Error
          if (state is ProductError) {
            return custom.ErrorWidget(
              message: state.message,
              onRetry: () => context.read<ProductBloc>().add(
                GetProductsRequested(),
              ),
            );
          }

          // Loaded
          if (state is ProductLoaded) {
            if (state.isEmpty) {
              return EmptyState(
                icon: Icons.inventory_2_outlined,
                title: 'No products yet',
                subtitle: 'Create your first product to get started',
                actionLabel: 'Add Product',
                onAction: () => context.push('/products/create'),
              );
            }

            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return ProductCard(
                    product: product,
                    onTap: () => context.push('/products/${product.id}'),
                    onDelete: () => _confirmDelete(product.id),
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

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ProductBloc>().add(DeleteProductRequested(id));
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
```

### Form/Create Screen Template

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/product_bloc.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<ProductBloc>().add(
        CreateProductRequested(
          name: _nameController.text.trim(),
          price: double.parse(_priceController.text.trim()),
          category: _categoryController.text.trim(),
          imageUrl: _imageUrlController.text.trim().isEmpty
              ? null
              : _imageUrlController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Product'),
      ),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }

          if (state is ProductOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
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
                // Name
                CustomTextField(
                  label: 'Product Name',
                  hint: 'Enter product name',
                  controller: _nameController,
                  prefixIcon: const Icon(Icons.inventory_2_outlined),
                  validator: Validators.required,
                ),
                const SizedBox(height: 16),

                // Price
                CustomTextField(
                  label: 'Price',
                  hint: 'Enter price',
                  controller: _priceController,
                  prefixIcon: const Icon(Icons.attach_money),
                  keyboardType: TextInputType.number,
                  validator: (value) => Validators.validateAmount(value, min: 0),
                ),
                const SizedBox(height: 16),

                // Category
                CustomTextField(
                  label: 'Category',
                  hint: 'Enter category',
                  controller: _categoryController,
                  prefixIcon: const Icon(Icons.category_outlined),
                  validator: Validators.required,
                ),
                const SizedBox(height: 16),

                // Image URL (Optional)
                CustomTextField(
                  label: 'Image URL (Optional)',
                  hint: 'Enter image URL',
                  controller: _imageUrlController,
                  prefixIcon: const Icon(Icons.image_outlined),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 32),

                // Submit Button
                BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    return CustomButton(
                      label: 'Create Product',
                      onPressed: _handleSubmit,
                      isLoading: state is ProductLoading,
                      icon: Icons.add,
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

### Detail Screen Template

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../bloc/product_bloc.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(GetProductByIdRequested(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push(
              '/products/${widget.productId}/edit',
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const LoadingIndicator();
          }

          if (state is ProductDetailLoaded) {
            final product = state.product;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  if (product.imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        product.imageUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 24),

                  // Name
                  Text(
                    product.name,
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),

                  // Category
                  Chip(
                    label: Text(product.category),
                    backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                  ),
                  const SizedBox(height: 16),

                  // Price
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is ProductError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
```

---

## 🧩 Widgets

### Feature Widget Template

```dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 80,
                  height: 80,
                  color: AppColors.surfaceVariant,
                  child: product.imageUrl != null
                      ? Image.network(
                          product.imageUrl!,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.inventory_2_outlined),
                ),
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.category,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Actions
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: AppColors.error,
                  onPressed: onDelete,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 🔗 Connecting BLoC to UI

### In `app.dart`

```dart
return MultiBlocProvider(
  providers: [
    BlocProvider<AuthBloc>(
      create: (context) => di.sl<AuthBloc>(),
    ),
    BlocProvider<ProductBloc>(
      create: (context) => di.sl<ProductBloc>(),
    ),
  ],
  child: MaterialApp.router(...),
);
```

---

## 📋 Checklist for Presentation Layer

- [ ] Create BLoC with all event handlers
- [ ] Create Events for each user action
- [ ] Create States for each UI condition
- [ ] Register BLoC in dependency injection
- [ ] Add BlocProvider in `app.dart`
- [ ] Create List screen with BlocConsumer
- [ ] Create Detail screen
- [ ] Create Form/Create screen
- [ ] Create feature-specific widgets
- [ ] Handle loading, error, and success states
- [ ] Add navigation/routing
