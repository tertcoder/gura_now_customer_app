import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../storage/secure_storage.dart' show SecureStorageService;
import '../mock/mock_auth_datasource.dart';
import '../mock/mock_order_datasource.dart';
import '../mock/mock_shop_datasource.dart';
import '../mock/mock_notification_datasource.dart';
import '../mock/mock_payment_datasource.dart';

// Import features
import '../../features/auth/auth.dart';
import '../../features/cart/cart.dart';
import '../../features/orders/orders.dart';
import '../../features/shop/shop.dart';
import '../../features/notifications/notifications.dart';
import '../../features/payment/payment.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ═══════════════════════════════════════════════════════════════
  // CORE DEPENDENCIES
  // ═══════════════════════════════════════════════════════════════
  await _initCore();

  // ═══════════════════════════════════════════════════════════════
  // FEATURES
  // ═══════════════════════════════════════════════════════════════
  _initAuth();
  _initCart();
  _initOrders();
  _initShop();
  _initNotifications();
  _initPayment();
}

Future<void> _initCore() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Storage
  sl.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );
}

void _initAuth() {
  // ─────────────────────────────────────────────────────────────────
  // Data Sources (Mock only - no API) — register first so repo can resolve
  // ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => MockAuthRemoteDataSource(),
  );

  // ─────────────────────────────────────────────────────────────────
  // Repository (Singleton, registered with interface type)
  // ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      sl<AuthRemoteDataSource>(),
      sl<SecureStorageService>(),
    ),
  );

  // ─────────────────────────────────────────────────────────────────
  // Use Cases (Singleton)
  // ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => RegisterUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetMeUseCase(sl<AuthRepository>()));

  // ─────────────────────────────────────────────────────────────────
  // BLoC (Factory - one per tree, created at app root)
  // ─────────────────────────────────────────────────────────────────
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      getMeUseCase: sl(),
      storage: sl<SecureStorageService>(),
    ),
  );
}

void _initCart() {
  // ─────────────────────────────────────────────────────────────────
  // BLoC (Factory)
  // ─────────────────────────────────────────────────────────────────
  sl.registerFactory<CartBloc>(
    () => CartBloc(sl<SharedPreferences>()),
  );
}

void _initOrders() {
  // ─────────────────────────────────────────────────────────────────
  // Use Cases (Singleton)
  // ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => CreateOrderUseCase(sl()));
  sl.registerLazySingleton(() => GetOrdersUseCase(sl()));
  sl.registerLazySingleton(() => GetOrderDetailUseCase(sl()));
  sl.registerLazySingleton(() => ConfirmOrderUseCase(sl()));
  sl.registerLazySingleton(() => ConfirmCustomerUseCase(sl()));

  // ─────────────────────────────────────────────────────────────────
  // Repository (Singleton, registered with interface type)
  // ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(sl()),
  );

  // ─────────────────────────────────────────────────────────────────
  // Data Sources (Mock only - no API)
  // ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<OrderRemoteDataSource>(
    () => MockOrderRemoteDataSource(),
  );

  // ─────────────────────────────────────────────────────────────────
  // BLoC (Factory)
  // ─────────────────────────────────────────────────────────────────
  sl.registerFactory<OrderBloc>(
    () => OrderBloc(
      getOrdersUseCase: sl(),
      getOrderDetailUseCase: sl(),
      createOrderUseCase: sl(),
      confirmOrderUseCase: sl(),
      confirmCustomerUseCase: sl(),
    ),
  );
}

void _initShop() {
  // ─────────────────────────────────────────────────────────────────
  // Use Cases (Singleton)
  // ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetShopsUseCase(sl()));
  sl.registerLazySingleton(() => GetShopDetailUseCase(sl()));

  // ─────────────────────────────────────────────────────────────────
  // Repository (Singleton, registered with interface type)
  // ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<ShopRepository>(
    () => ShopRepositoryImpl(sl()),
  );

  // ─────────────────────────────────────────────────────────────────
  // Data Sources (Mock only - no API)
  // ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<ShopRemoteDataSource>(
    () => MockShopRemoteDataSource(),
  );

  // ─────────────────────────────────────────────────────────────────
  // BLoC (Factory)
  // ─────────────────────────────────────────────────────────────────
  sl.registerFactory<ShopBloc>(
    () => ShopBloc(
      getShopsUseCase: sl(),
      getShopDetailUseCase: sl(),
    ),
  );
}

void _initNotifications() {
  // ─────────────────────────────────────────────────────────────────
  // Use Cases (Singleton)
  // ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => GetUnreadCountUseCase(sl()));
  sl.registerLazySingleton(() => MarkAsReadUseCase(sl()));

  // ─────────────────────────────────────────────────────────────────
  // Repository (Singleton, registered with interface type)
  // ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(sl()),
  );

  // ─────────────────────────────────────────────────────────────────
  // Data Sources (Mock only - no API)
  // ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => MockNotificationRemoteDataSource(),
  );

  // ─────────────────────────────────────────────────────────────────
  // BLoC (Factory)
  // ─────────────────────────────────────────────────────────────────
  sl.registerFactory<NotificationBloc>(
    () => NotificationBloc(sl()),
  );
}

void _initPayment() {
  // ─────────────────────────────────────────────────────────────────
  // Use Cases (Singleton)
  // ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetPaymentProofsUseCase(sl()));
  sl.registerLazySingleton(() => GetShopBalanceUseCase(sl()));

  // ─────────────────────────────────────────────────────────────────
  // Repository (Singleton, registered with interface type)
  // ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(sl()),
  );

  // ─────────────────────────────────────────────────────────────────
  // Data Sources (Mock only - no API)
  // ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => MockPaymentRemoteDataSource(),
  );

  // ─────────────────────────────────────────────────────────────────
  // BLoC (Factory)
  // ─────────────────────────────────────────────────────────────────
  sl.registerFactory<PaymentBloc>(
    () => PaymentBloc(sl()),
  );
}
