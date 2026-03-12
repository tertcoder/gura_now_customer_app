# 📱 Gura Now – Flutter Frontend

**E-soko – Marketplace mobile pour le Burundi avec livraison intégrée.**

Application Flutter en **Clean Architecture** : BLoC, Dio, GetIt, GoRouter.

---

## 🏗 Architecture

- **Clean Architecture** : Domain → Data → Presentation par feature
- **State management** : **BLoC** (flutter_bloc)
- **Dependency injection** : **GetIt**
- **HTTP** : **Dio** (via `DioClient` + `ApiClient` dans `lib/core/network/`)
- **Navigation** : **GoRouter**
- **Routing** : BLoC-based (auth state → splash / login / home)

Référence détaillée : **[docs/ARCHITECTURE_GUIDE.md](docs/ARCHITECTURE_GUIDE.md)**

---

## 📁 Structure du projet

```
lib/
├── core/                     # Config, réseau, thème, widgets partagés
│   ├── config/               # API (ApiConfig, endpoints)
│   ├── constants/            # Constantes app, devises, rôles
│   ├── di/                   # injection_container.dart (GetIt)
│   ├── errors/               # exceptions.dart, failures.dart
│   ├── network/              # dio_client.dart, api_client.dart
│   ├── router/               # app_router_bloc.dart
│   ├── storage/              # secure_storage.dart
│   ├── theme/                # app_colors, app_text_styles, app_theme
│   ├── usecases/             # usecase.dart (base)
│   ├── utils/                # validators, extensions, logger
│   └── widgets/              # boutons, champs, empty state, etc.
├── features/                 # Une feature = data + domain + presentation
│   ├── auth/                 # Login, register, splash
│   ├── home/                 # Écran d’accueil
│   ├── shop/                 # Liste / détail boutiques
│   ├── product/              # Détail produit
│   ├── cart/                 # Panier
│   ├── orders/               # Commandes, checkout
│   ├── profile/              # Profil, adresses, paramètres
│   ├── driver/                # Livraisons (livreur)
│   ├── admin/                # Dashboard admin, users, shops, orders
│   ├── notifications/        # Notifications
│   └── payment/              # Paiements, preuves, historique
├── app.dart
└── main.dart
```

Chaque feature suit :

- `data/` : datasources, models, repository_impl
- `domain/` : entities, repository (interface), usecases
- `presentation/` : bloc (events/states), pages, widgets

---

## 🚀 Démarrage rapide

### Prérequis

- Flutter SDK **3.0+** / Dart **3.0+**
- Android Studio et/ou Xcode (pour mobile)

### Installation

```bash
cd gura_now_frontend
flutter pub get
```

### Lancer l’app

```bash
# Device par défaut
flutter run

# iOS
flutter run -d <device_id>

# Web
flutter run -d chrome
```

### Assets (optionnel)

Si vous activez les assets dans `pubspec.yaml`, créez les dossiers :

- `assets/images/`
- `assets/icons/`
- `assets/logos/`

---

## 📦 Stack technique

| Rôle              | Techno              |
|-------------------|---------------------|
| HTTP              | **Dio** (DioClient + ApiClient) |
| State             | **flutter_bloc**    |
| DI                | **get_it**          |
| Navigation        | **go_router**       |
| Logique fonctionnelle | **dartz** (Either) |
| Modèles           | **equatable**       |
| Storage sécurisé   | **flutter_secure_storage** |
| Cache local       | **shared_preferences** (ex. panier) |

---

## 🔐 Sécurité & API

- Tokens en **SecureStorage** (KeyStore / Keychain)
- **ApiClient** : Bearer automatique, timeouts, mapping d’erreurs (ServerException, UnauthorizedException, etc.)
- Endpoints centralisés dans `lib/core/config/` et `lib/core/constants/`

---

## 📖 Documentation

- **[docs/ARCHITECTURE_GUIDE.md](docs/ARCHITECTURE_GUIDE.md)** – Guide d’architecture (Dio, BLoC, couches)
- **[docs/QUICK_REFERENCE.md](docs/QUICK_REFERENCE.md)** – Référence rapide
- **docs/layers/** – Data, Domain, Presentation

---

## 🎨 Design

- **AppColors** : palette (primary, accent, success, danger, etc.)
- **AppTextStyles** : heading1–3, body, caption, button
- **AppTheme** : Material 3

---

## 👥 Rôles

- `customer` – Client  
- `shop_owner` – Propriétaire de boutique  
- `driver` – Livreur  
- `gura_now_admin` – Admin plateforme  
- `support_agent` – Support  
- (+ employés boutique / Gura Now selon backend)

---

## 📄 Licence

Proprietary – Gura Now Burundi.
# gura_now_customer_app
