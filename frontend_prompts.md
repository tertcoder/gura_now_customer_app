# 📱 Guide de Génération Frontend - Projet Gura_now (Flutter)

**Version Optimisée pour Scalabilité & Production**

Ce document contient une série de **prompts séquentiels et cohérents** pour construire l'application Flutter "Gura_now" de manière modulaire, testable et scalable.

---

## 🎯 **STRATÉGIE GLOBALE**

### **Architecture & Principes**

- **Pattern :** Feature-First + Clean Architecture (Data/Domain/Presentation)
- **State Management :** Riverpod (FutureProvider, StateNotifier)
- **HTTP Client :** Dio avec interceptors (auth, error handling)
- **Navigation :** GoRouter avec redirection conditionnelle
- **Storage :** Flutter Secure Storage (tokens, cache)
- **Testing :** Partie intégrée à chaque module (unit + widget tests)

### **Design System (Noir & Blanc + Actions)**

```
Colors:
├─ Primary (Neutre)    : #000000 (Noir)
├─ Background          : #FFFFFF (Blanc pur)
├─ Surface             : #F5F5F5 (Gris très clair)
├─ Border/Divider      : #E0E0E0 (Gris clair)
├─ Text Primary        : #212121 (Noir foncé)
├─ Text Secondary      : #757575 (Gris moyen)
│
└─ Action Colors (Context-based) :
   ├─ Success/Confirm  : #27AE60 (Vert - Confirmations, achats positifs)
   ├─ Warning          : #F39C12 (Orange - Actions importantes)
   ├─ Danger/Cancel    : #E74C3C (Rouge - Suppressions, annulations)
   └─ Info             : #3498DB (Bleu - Informations, statuts)

Typography:
├─ Font Family : Inter ou Roboto
├─ Headings    : Bold (24sp, 20sp, 18sp)
├─ Body        : Regular (14sp, 12sp)
├─ Buttons     : Medium (14sp)
└─ Captions    : Light (10sp)

Spacing: 8px, 16px, 24px, 32px (baseline 8px)
Border Radius: 4px (buttons), 8px (cards)
Shadow: Légère, consistency avec Material Design
```

### **Modules Prioritaires pour Tests**

1. **Module 1 (Auth)** - Fondation
2. **Module 2 (Home & Shops)** - Discovery
3. **Module 3 (Orders)** - Core Business
4. **Module 4 (Suivi)** - Feedback utilisateur
5. **Module 5 (Roles)** - Owner & Driver
6. **Module 6 (Extras)** - Optimisations

---

## 🏗️ **PHASE 0 : FONDATION CRITIQUE**

### 📝 **Prompt 1 : Initialisation & Configuration Globale**

```text
CONTEXTE :
Tu es un expert Flutter/Riverpod. Nous construisons "Gura_now", une marketplace Burundaise avec Flutter.
L'API backend (FastAPI) est disponible sur http://10.0.2.2:8000 (émulateur) ou 127.0.0.1 (iOS).
Design : Noir & Blanc minimaliste avec couleurs d'action (vert/rouge/orange/bleu).

TÂCHE 1 - Structure du Projet :
Crée la structure Feature-First dans lib/src/ :

```

lib/
├── main.dart # Point d'entrée
├── src/
│ ├── core/
│ │ ├── constants/
│ │ │ ├── api_endpoints.dart # Base URL, routes
│ │ │ ├── app_constants.dart # Constantes globales
│ │ │ └── currencies.dart # Format devise (BIF)
│ │ ├── theme/
│ │ │ ├── app_colors.dart # Palette de couleurs
│ │ │ ├── app_text_styles.dart # Styles typographie
│ │ │ └── app_theme.dart # ThemeData global
│ │ ├── network/
│ │ │ ├── dio_client.dart # Client HTTP avec interceptors
│ │ │ ├── api_response.dart # Wrapper réponse API
│ │ │ └── network_exceptions.dart # Exception handling
│ │ ├── storage/
│ │ │ └── secure_storage.dart # FlutterSecureStorage wrapper
│ │ └── utils/
│ │ ├── logger.dart # Logging simple
│ │ ├── validators.dart # Validations (téléphone, email)
│ │ └── extensions.dart # String, int extensions
│ ├── features/
│ │ ├── auth/
│ │ │ ├── data/
│ │ │ │ ├── models/
│ │ │ │ ├── data_sources/
│ │ │ │ └── repositories/
│ │ │ ├── domain/
│ │ │ │ ├── entities/
│ │ │ │ └── repositories/
│ │ │ └── presentation/
│ │ │ ├── pages/
│ │ │ ├── widgets/
│ │ │ └── providers/
│ │ ├── home/
│ │ ├── shop/
│ │ ├── product/
│ │ ├── cart/
│ │ ├── orders/
│ │ ├── profile/
│ │ ├── driver/ # (Nouveau) Pour rôle driver
│ │ └── admin/ # (Nouveau) Pour dashboard admin
│ └── shared/
│ ├── widgets/
│ │ ├── custom_button.dart
│ │ ├── custom_text_field.dart
│ │ ├── loading_widget.dart
│ │ ├── error_widget.dart
│ │ └── empty_state.dart
│ ├── layouts/
│ │ └── main_scaffold.dart # BottomNav + Drawer
│ └── dialogs/
│ ├── confirm_dialog.dart
│ └── success_dialog.dart

```

TÂCHE 2 - main.dart avec ProviderScope & GoRouter :
1. Initialise `ProviderScope` (Riverpod).
2. Configure `GoRouter` avec routes de base :
   - `/splash` (SplashScreen)
   - `/login` (LoginScreen)
   - `/register` (RegisterScreen)
   - `/home` (HomeScreen)
   - `/` redirection conditionnelle (check token)
3. Ajoute une logique `redirect` pour gérer l'authentification.

TÂCHE 3 - pubspec.yaml :
Ajoute les dépendances essentielles :
```

dependencies:
flutter:
sdk: flutter
riverpod: ^2.4.0
flutter_riverpod: ^2.4.0
go_router: ^12.0.0
dio: ^5.3.0
flutter_secure_storage: ^9.0.0
image_picker: ^1.0.0
intl: ^0.19.0
google_fonts: ^6.0.0

dev_dependencies:
flutter_test:
sdk: flutter
flutter_lints: ^3.0.0
riverpod_generator: ^2.3.0
build_runner: ^2.4.0

```

TÂCHE 4 - Fichiers Core :
Génère les fichiers essentiels :
- app_theme.dart (ThemeData, Colors, TextStyles)
- app_colors.dart (Palette centralisée)
- app_text_styles.dart (Style typographie)
- api_endpoints.dart (URLs, routes)
- app_constants.dart (Valeurs globales)

Génère le code COMPLET pour ces fichiers sans explications.
```

### 📝 **Prompt 2 : Client HTTP & Storage**

```text
CONTEXTE : Gura_now Flutter App - Module Network & Storage.

TÂCHE 1 - FlutterSecureStorage Wrapper :
Crée `lib/src/core/storage/secure_storage.dart` :
1. Wrapper singleton autour de FlutterSecureStorage.
2. Méthodes :
   - saveToken(String token)
   - getToken() -> String?
   - deleteToken()
   - saveUser(User) / getUser() -> User?
   - clear()

TÂCHE 2 - DioClient :
Crée `lib/src/core/network/dio_client.dart` :
1. Classe DioClient singleton.
2. BaseUrl = http://10.0.2.2:8000 (configurable par environment).
3. InterceptorsWrapper :
   - Request : Ajoute "Authorization: Bearer <token>" s'il existe.
   - Response : Log simple en debug.
   - Error : Gère 401 -> trigger logout, 5xx -> erreur générique.
4. Timeouts : 30s.
5. Crée un Riverpod Provider : dioClientProvider.

TÂCHE 3 - Api Response Wrapper :
Crée `lib/src/core/network/api_response.dart` :
1. Classe générique ApiResponse<T> :
   - success: bool
   - data: T?
   - message: String?
   - statusCode: int?
2. Factory : fromJson() pour parser les réponses API.

TÂCHE 4 - Network Exceptions :
Crée `lib/src/core/network/network_exceptions.dart` :
1. Exception abstraite : NetworkException
2. Sous-classes : UnauthorizedException, ServerException, TimeoutException, etc.

Génère le code COMPLET.
```

---

## 🔐 **MODULE 1 : AUTHENTIFICATION (Priority 1)**

### 📝 **Prompt 3 : Models & Repository Auth**

```text
CONTEXTE : Module Auth - Data Layer.
Endpoints API :
- POST /auth/register (body: {full_name, phone_number, email?, password, role})
- POST /auth/login (body: {phone_number, password})
- POST /auth/logout
- GET /auth/me (protected)

TÂCHE 1 - Model User :
Crée `lib/src/features/auth/data/models/user_model.dart` :
1. Classe UserModel (id, fullName, phoneNumber, email, role, createdAt).
2. Méthodes : toJson(), fromJson(), copyWith().
3. toEntity() -> User (entity pour domain layer).

TÂCHE 2 - Model AuthResponse :
Crée `lib/src/features/auth/data/models/auth_response_model.dart` :
1. AuthResponseModel (user: UserModel, accessToken: String, tokenType: String).
2. fromJson().

TÂCHE 3 - Remote Data Source :
Crée `lib/src/features/auth/data/data_sources/auth_remote_datasource.dart` :
1. Interface AuthRemoteDataSource.
2. Implémentation avec DioClient :
   - login(phone, password) -> Future<AuthResponseModel>
   - register(fullName, phone, email, password, role) -> Future<AuthResponseModel>
   - logout() -> Future<void>
   - getMe() -> Future<UserModel>
3. Gère les exceptions réseau et les convertit en NetworkException.

TÂCHE 4 - Repository :
Crée `lib/src/features/auth/data/repositories/auth_repository_impl.dart` :
1. Implémente interface AuthRepository (domain).
2. Utilise AuthRemoteDataSource.
3. Gère cache local (SecureStorage).
4. Retourne des Future<Result<T>> ou Future<T> avec throws.

Génère le code COMPLET.
```

### 📝 **Prompt 4 : Domain & State Management Auth**

```text
CONTEXTE : Module Auth - Domain Layer & State Notifier.

TÂCHE 1 - Domain Entities :
Crée `lib/src/features/auth/domain/entities/user.dart` :
1. Classe User (id, fullName, phoneNumber, email, role, createdAt).
2. Immutable (const, final).

TÂCHE 2 - Domain Repositories :
Crée `lib/src/features/auth/domain/repositories/auth_repository.dart` :
1. Interface abstraite :
   - login(phone: String, password: String) -> Future<AuthResponse>
   - register(fullName, phone, email, password, role) -> Future<User>
   - logout() -> Future<void>
   - getMe() -> Future<User>

TÂCHE 3 - Use Cases (Optional mais Recommandé) :
Crée `lib/src/features/auth/domain/usecases/` :
- LoginUseCase (login(phone, password))
- RegisterUseCase (register(...))
- LogoutUseCase (logout())
- GetMeUseCase (getMe())

Chaque use case prend le repository en constructeur.

TÂCHE 4 - Auth State & Controller :
Crée `lib/src/features/auth/presentation/providers/auth_controller.dart` :
1. Enum AuthState : initial, loading, authenticated, unauthenticated, error
2. Classe AuthState (state, user, errorMessage).
3. StateNotifier<AuthState> AuthController :
   - login(phone, password) -> void (async)
   - register(...) -> void (async)
   - logout() -> void
   - checkAuth() -> void (vérifie token au startup)
   - setUnauthenticated() -> void
4. Riverpod Provider : authControllerProvider = StateNotifierProvider(...)
5. Riverpod Consumer Provider : currentUserProvider pour accéder à l'user actuel.

TÂCHE 5 - Providers Auxiliaires :
Crée `lib/src/features/auth/presentation/providers/` :
- isAuthenticatedProvider = authControllerProvider.select((state) => state.isAuthenticated)
- currentUserProvider = authControllerProvider.select((state) => state.user)
- authErrorProvider = authControllerProvider.select((state) => state.errorMessage)

Génère le code COMPLET.
```

### 📝 **Prompt 5 : Auth UI (Login & Register)**

```text
CONTEXTE : Module Auth - Presentation (UI).
Design : Noir & Blanc, champs avec bordures fines noires, boutons noirs avec texte blanc.

TÂCHE 1 - Login Screen :
Crée `lib/src/features/auth/presentation/pages/login_screen.dart` :
1. TextField (Téléphone +257..., password).
2. Validation en temps réel.
3. Bouton "Se Connecter" noir (enabled/disabled selon validation).
4. Loading state (spinner).
5. Error snackbar.
6. Lien "S'inscrire ?" (navigation vers register).
7. Connecté au authControllerProvider.

TÂCHE 2 - Register Screen :
Crée `lib/src/features/auth/presentation/pages/register_screen.dart` :
1. TextFields : Full Name, Téléphone, Email (optionnel), Mot de passe, Confirm Password.
2. Dropdown/Radio : Rôle (Customer, Shop Owner, Driver) - default Customer.
3. Validation (réelle-time) : Téléphone Burundi, Password force.
4. Bouton "Créer Compte" vert (#27AE60).
5. Lien "Déjà Inscrit ?" -> Login.

TÂCHE 3 - Splash Screen :
Crée `lib/src/features/auth/presentation/pages/splash_screen.dart` :
1. Logo Gura_now + Spinner.
2. Appelle authControllerProvider.checkAuth() au build.
3. Redirection auto à /login ou /home selon state.

TÂCHE 4 - Custom Widgets :
Crée `lib/src/shared/widgets/custom_text_field.dart` :
1. Widget réutilisable avec label, hint, validation, obscureText.

Crée `lib/src/shared/widgets/custom_button.dart` :
1. Widget réutilisable avec couleur, loading state, onPressed.

Génère le code COMPLET.
```

---

## 🛍️ **MODULE 2 : DÉCOUVERTE & BOUTIQUES (Priority 2)**

### 📝 **Prompt 6 : Models & Repository Shop**

```text
CONTEXTE : Module Shop - Data Layer.
Endpoint API :
- GET /shops (list avec filters optionnels)
- GET /shops/{id} (détail)

TÂCHE 1 - Models :
Crée `lib/src/features/shop/data/models/shop_model.dart` :
1. ShopModel (id, name, description, logo_url, delivery_scope, type, rating, totalReviews).
2. fromJson(), toJson(), toEntity().

TÂCHE 2 - Remote DataSource :
Crée `lib/src/features/shop/data/data_sources/shop_remote_datasource.dart` :
1. Interface ShopRemoteDataSource.
2. Implémentation :
   - getShops({category?, limit?, offset?}) -> Future<List<ShopModel>>
   - getShopDetail(id) -> Future<ShopModel>

TÂCHE 3 - Repository :
Crée `lib/src/features/shop/data/repositories/shop_repository_impl.dart` :
1. Implémente ShopRepository (domain).
2. Utilise RemoteDataSource + cache simple (Hive ou SharedPreferences si besoin).

Génère le code COMPLET.
```

### 📝 **Prompt 7 : Domain & Providers Shop**

```text
CONTEXTE : Module Shop - Domain Layer & Riverpod Providers.

TÂCHE 1 - Domain Entities :
Crée `lib/src/features/shop/domain/entities/shop.dart` :
1. Classe Shop (id, name, description, logoUrl, deliveryScope, type, rating, totalReviews).

TÂCHE 2 - Domain Repository :
Crée `lib/src/features/shop/domain/repositories/shop_repository.dart` :
1. Interface abstraite avec getShops(), getShopDetail().

TÂCHE 3 - Providers Riverpod :
Crée `lib/src/features/shop/presentation/providers/shop_providers.dart` :
1. shopRepositoryProvider (obtient DioClient).
2. shopListProvider = FutureProvider<List<Shop>>((ref) async { ... })
3. shopDetailProvider(id) = FutureProvider.family<Shop, String>((ref, id) async { ... })
4. selectedShopProvider = StateProvider<Shop?> pour stocker la boutique sélectionnée.

Génère le code COMPLET.
```

### 📝 **Prompt 8 : Home & Shop List UI**

```text
CONTEXTE : Module Home & Shop - Presentation (UI).

TÂCHE 1 - Home Screen :
Crée `lib/src/features/home/presentation/pages/home_screen.dart` :
1. Header : "Gura Now" titre gros noir.
2. Search bar (noir/blanc) pour filter shops.
3. FutureProvider shopListProvider -> GridView 2x (ou ListView).
4. ShopCard widget.
5. Tap -> Navigate vers ShopDetailScreen.

TÂCHE 2 - Shop Card Widget :
Crée `lib/src/shared/widgets/shop_card.dart` :
1. Image (placeholder gris si null).
2. Shop name (bold, noir).
3. Badge type (Shop Type : "Restaurant", "Supermarché", etc.) en petits caractères.
4. Rating (⭐ + nombre).
5. Ombre légère, border radius 8px.

TÂCHE 3 - Shop Detail Screen :
Crée `lib/src/features/shop/presentation/pages/shop_detail_screen.dart` :
1. Header : Logo + info boutique.
2. Liste des produits (tab ou scroll).
3. ProductCard pour chaque produit.
4. Tap produit -> ProductDetailScreen.

Génère le code COMPLET.
```

---

## 📦 **MODULE 3 : PANIER & COMMANDES (Priority 3)**

### 📝 **Prompt 9 : Cart Models & State**

```text
CONTEXTE : Module Cart - Local State Management (pas d'API pour le panier local).

TÂCHE 1 - Cart Models :
Crée `lib/src/features/cart/data/models/cart_item.dart` :
1. CartItem (product: Product, quantity: int, variant: ProductVariant?).
2. Getters : totalPrice, subtotal.

Crée `lib/src/features/cart/data/models/cart_state.dart` :
1. CartState (items: List<CartItem>, totalPrice, itemCount).

TÂCHE 2 - Cart Provider & Controller :
Crée `lib/src/features/cart/presentation/providers/cart_provider.dart` :
1. StateNotifier<CartState> CartController :
   - addItem(product, quantity, variant?) -> void
   - removeItem(productId) -> void
   - updateQuantity(productId, quantity) -> void
   - clear() -> void
   - getItemCount() -> int
   - getTotalPrice() -> double
   - getItems() -> List<CartItem>
2. Riverpod Provider : cartControllerProvider = StateNotifierProvider(...)
3. Providers dérivés :
   - cartItemCountProvider
   - cartTotalPriceProvider
   - cartItemsProvider

TÂCHE 3 - Persistence (Optional) :
Ajoute persistence du panier en SharedPreferences (sauvegarde/restauration au launch).

Génère le code COMPLET.
```

### 📝 **Prompt 10 : Cart UI**

```text
CONTEXTE : Module Cart - Presentation (UI).

TÂCHE 1 - Cart Screen :
Crée `lib/src/features/cart/presentation/pages/cart_screen.dart` :
1. AppBar : "Panier".
2. Si vide -> EmptyState (icône panier vide, texte).
3. Si plein -> ListView des CartItemWidget.
4. Bottom Summary : Sous-total + Commission 5% + Total.
5. Bouton fixe en bas : "Passer la Commande" VERT (#27AE60), large.

TÂCHE 2 - Cart Item Widget :
Crée `lib/src/shared/widgets/cart_item_widget.dart` :
1. Image produit.
2. Nom produit, variante.
3. Prix unitaire.
4. Controls quantité : "-", nombre, "+".
5. Prix total ligne.
6. Bouton delete (icon X rouge).

TÂCHE 3 - Empty State Cart :
Crée un widget EmptyState réutilisable.

Génère le code COMPLET.
```

### 📝 **Prompt 11 : Orders Models & Repository**

```text
CONTEXTE : Module Orders - Data Layer.
Endpoints API :
- POST /orders (create)
- GET /orders (list)
- GET /orders/{id} (detail)
- PATCH /orders/{id}/confirm-customer (customer confirms)
- PATCH /orders/{id}/confirm-shop (shop confirms)

TÂCHE 1 - Models :
Crée `lib/src/features/orders/data/models/order_model.dart` :
1. OrderModel (id, customerId, shopId, items[], status, total, createdAt, updatedAt, shippingAddress).
2. Status enum : pending, confirmed, shipped, delivered, cancelled.

Crée `lib/src/features/orders/data/models/order_item_model.dart` :
1. OrderItemModel (productId, quantity, price, variant?).

TÂCHE 2 - Remote DataSource :
Crée `lib/src/features/orders/data/data_sources/order_remote_datasource.dart` :
1. Interface OrderRemoteDataSource.
2. Implémentation :
   - createOrder(orderData) -> Future<OrderModel>
   - getOrders() -> Future<List<OrderModel>>
   - getOrderDetail(id) -> Future<OrderModel>
   - confirmOrder(orderId) -> Future<void>
   - confirmCustomer(orderId) -> Future<void>

TÂCHE 3 - Repository :
Crée `lib/src/features/orders/data/repositories/order_repository_impl.dart`.

Génère le code COMPLET.
```

### 📝 **Prompt 12 : Checkout & Order Creation**

```text
CONTEXTE : Module Orders - Checkout Flow & Order Creation UI.

TÂCHE 1 - Checkout Models & Form State :
Crée `lib/src/features/orders/data/models/checkout_data.dart` :
1. CheckoutData (deliveryMode, paymentMethod, shippingAddress, paymentProof?).

TÂCHE 2 - Checkout Screen :
Crée `lib/src/features/orders/presentation/pages/checkout_screen.dart` :
1. Section 1 : Résumé Panier (items, total).
2. Section 2 : Adresse Livraison (TextField ou sélection adresse enregistrée).
3. Section 3 : Mode Livraison (Dropdown : Livraison, Pickup).
4. Section 4 : Méthode Paiement (Dropdown : Cash, Mobile Money).
5. Si Mobile Money :
   - Champ pour upload image preuve (placeholder pour l'instant).
6. Bouton "Confirmer Commande" VERT, large, fixe en bas.
7. On submit -> appelle createOrder (backend).
8. Success -> OrderSuccessScreen avec numéro commande.
9. Error -> Snackbar avec message.

TÂCHE 3 - Order Success Screen :
Crée `lib/src/features/orders/presentation/pages/order_success_screen.dart` :
1. Affiche numéro commande généré.
2. Message "Commande créée avec succès".
3. Bouton "Retour Accueil" (noir).
4. Bouton "Voir Commande" (vert) -> OrderDetailScreen.

Génère le code COMPLET.
```

---

## 🚚 **MODULE 4 : SUIVI & STATUTS (Priority 4)**

### 📝 **Prompt 13 : Orders List & Detail UI**

```text
CONTEXTE : Module Orders - Tracking (Suivi des commandes).

TÂCHE 1 - Orders List Screen :
Crée `lib/src/features/orders/presentation/pages/orders_list_screen.dart` :
1. Tabs : "En cours" | "Terminées".
2. Si en cours -> FutureProvider orders filter status < delivered.
3. Si terminées -> FutureProvider orders filter status == delivered ou cancelled.
4. Liste OrderCard pour chaque commande.
5. Tap card -> OrderDetailScreen.

TÂCHE 2 - Order Card Widget :
Crée `lib/src/shared/widgets/order_card.dart` :
1. Order ID (gros).
2. Date création.
3. Status badge (couleur selon status : pending=orange, confirmed=vert, shipped=bleu, delivered=vert foncé).
4. Total montant.
5. Flèche droite.

TÂCHE 3 - Order Detail Screen :
Crée `lib/src/features/orders/presentation/pages/order_detail_screen.dart` :
1. Header : Order ID, statut, date.
2. Section Items : Liste OrderItem avec image, nom, prix, quantité.
3. Section Adresse : Adresse livraison.
4. Section Total : Sous-total + Commission 5% + Total.
5. Section Suivi : Stepper de statut (Créé -> Confirmé Boutique -> Confirmé Client -> En Livraison -> Livré).
6. Si statut=shipped & user=customer -> Bouton VERT "Confirmer Réception".
7. Si statut=pending & user=shop_owner -> Bouton ORANGE "Confirmer Disponibilité".

Génère le code COMPLET.
```

---

## 👤 **MODULE 5 : RÔLES & DASHBOARDS (Priority 5)**

### 📝 **Prompt 14 : Owner Dashboard (Simplifié)**

```text
CONTEXTE : Module Owner Dashboard - Accessible si user.role == "shop_owner".

TÂCHE 1 - Owner Dashboard Screen :
Crée `lib/src/features/admin/presentation/pages/owner_dashboard_screen.dart` :
1. Header : "Tableau de Bord - [Shop Name]".
2. Stats Section (Cards) :
   - Total Commandes (nombre)
   - Commandes en attente (nombre + couleur orange)
   - Total Ventes (montant en BIF)
3. Section : "Commandes en attente" (Liste des commandes avec status=pending).
4. Pour chaque commande : OrderCard + Bouton "Voir Détails".

TÂCHE 2 - Main Scaffold avec Navigation :
Crée `lib/src/shared/layouts/main_scaffold.dart` :
1. BottomNavigationBar ou NavigationRail selon rôle :
   - Customer : Accueil, Panier, Commandes, Profil
   - Shop Owner : Dashboard, Commandes, Produits, Profil
   - Driver : Mes livraisons, Statistiques, Profil
2. À chaque tab -> Switch page correspondante.
3. TopAppBar standard : Logo, User info, Menu.

Génère le code COMPLET.
```

---

## 🔧 **MODULE 6 : INTÉGRATION & POLISSAGE (Priority 6)**

### 📝 **Prompt 15 : GoRouter Configuration Finale**

```text
CONTEXTE : Intégration finale de GoRouter avec Auth Guard.

TÂCHE 1 - GoRouter Setup Complet :
Crée `lib/src/core/router/app_router.dart` :
1. Définit toutes les routes :
   - /splash -> SplashScreen
   - /login -> LoginScreen
   - /register -> RegisterScreen
   - /home -> HomeScreen
   - /shop/:id -> ShopDetailScreen
   - /product/:id -> ProductDetailScreen
   - /cart -> CartScreen
   - /checkout -> CheckoutScreen
   - /orders -> OrdersListScreen
   - /order/:id -> OrderDetailScreen
   - /owner-dashboard -> OwnerDashboardScreen (si shop_owner)
   - /driver-deliveries -> DriverDeliveriesScreen (si driver)
   - /profile -> ProfileScreen
   - /settings -> SettingsScreen

2. Redirect logic :
   - Si aucun token -> /login
   - Si token mais user=null -> /splash (check token)
   - Si token + user -> check role -> /home (customer), /owner-dashboard (owner), /driver-deliveries (driver)

3. GoRouter navigator pour main.dart.

TÂCHE 2 - Error Handling & Logging :
Ajoute logging pour chaque navigation (debug uniquement).

Génère le code COMPLET.
```

### 📝 **Prompt 16 : Global Error & Loading Widgets**

```text
CONTEXTE : Widgets globaux réutilisables.

TÂCHE 1 - Loading Widget :
Crée `lib/src/shared/widgets/loading_widget.dart` :
1. Spinner noir centré.
2. Optionnel : message "Chargement...".

TÂCHE 2 - Error Widget :
Crée `lib/src/shared/widgets/error_widget.dart` :
1. Icône erreur.
2. Message d'erreur.
3. Bouton "Réessayer" (noir).

TÂCHE 3 - Empty State Widget :
Crée `lib/src/shared/widgets/empty_state_widget.dart` :
1. Icône générique.
2. Message "Aucun résultat".

TÂCHE 4 - Dialogs :
Crée `lib/src/shared/dialogs/confirm_dialog.dart` : Dialogue confirmation simple.
Crée `lib/src/shared/dialogs/success_dialog.dart` : Dialogue succès simple.

Génère le code COMPLET.
```

### 📝 **Prompt 17 : Profile & Settings**

```text
CONTEXTE : Profil & Paramètres Utilisateur (Écrans secondaires).

TÂCHE 1 - Profile Screen :
Crée `lib/src/features/profile/presentation/pages/profile_screen.dart` :
1. Avatar utilisateur (placeholder si null).
2. Informations : Nom, Téléphone, Email, Rôle (non éditables pour l'instant).
3. Bouton "Modifier Profil" (noir).
4. Bouton "Adresses" (gris).
5. Bouton "Logout" (ROUGE).

TÂCHE 2 - Settings Screen :
Crée `lib/src/features/profile/presentation/pages/settings_screen.dart` :
1. Toggle : "Notifications" (noir).
2. Toggle : "Mode Sombre" (grisé pour l'instant, futur).
3. Sélecteur : "Langue" (FR, EN).
4. Bouton : "Aide & Support".
5. Bouton : "À propos".

Génère le code COMPLET.
```

---

## ✅ **CHECKLIST VALIDATION FINALE**

### **Par Module** :

- [ ] Module 1 (Auth) : Login, Register, Splash testés
- [ ] Module 2 (Shops) : Liste & Détail fonctionnels
- [ ] Module 3 (Cart & Orders) : Panier & Checkout fonctionnels
- [ ] Module 4 (Suivi) : Historique commandes visible
- [ ] Module 5 (Rôles) : Owner Dashboard fonctionnel
- [ ] Module 6 (Intégration) : Navigation fluide, Auth Guard actif

### **Quality Checks** :

- [ ] Design noir/blanc + couleurs d'action cohérentes
- [ ] Toutes les erreurs affichées proprement
- [ ] Loading states visibles
- [ ] Token persistence fonctionnelle
- [ ] Navigation sans crash
- [ ] Tous les boutons actifs/inactifs correctement

---

## 📋 **NOTES IMPORTANTES**

1. **Scalabilité** : La structure Feature-First permet d'ajouter facilement Product Detail, Driver Mode, Admin Panel, etc.
2. **Cohérence** : Chaque module suit le même pattern Data/Domain/Presentation.
3. **Design** : Noir & Blanc strict + couleurs d'action contextuelles.
4. **Testing** : À ajouter après chaque module (unit + widget tests).
5. **Modifications Futures** : Au fur et à mesure de l'usage, on peut :
   - Ajouter animations
   - Optimiser les images
   - Ajouter offline mode
   - Ajouter real-time notifications

---

## 🚀 **COMMENCER**

Exécutez les prompts **séquentiellement** :

1. Prompt 1 (Init & Config)
2. Prompt 2 (Network & Storage)
3. Prompt 3-5 (Auth complet)
4. Prompt 6-8 (Shops complet)
5. Prompt 9-12 (Cart & Orders complet)
6. Prompt 13-14 (Suivi & Rôles)
7. Prompt 15-17 (Intégration & Polissage)

Chaque prompt génère du code **production-ready** sans explication additionnelle.
