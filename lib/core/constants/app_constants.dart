/// Global Application Constants.
library;

class AppConstants {
  AppConstants._();

  // ==========================================================================
  // App Information
  // ==========================================================================
  static const String appName = 'Gura Now';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Marketplace mobile pour le Burundi avec livraison intégrée';

  // ==========================================================================
  // Business Rules
  // ==========================================================================
  static const double platformCommissionPercent = 5;
  static const int maxEmployeesPerShop = 3;
  static const String burundiPhoneRegex = r'^\+257[67]\d{7}$';

  // ==========================================================================
  // Token & Auth
  // ==========================================================================
  static const String tokenKeyName = 'auth_token';
  static const String userKeyName = 'current_user';
  static const String tokenTypeBearer = 'Bearer';

  // ==========================================================================
  // Cache Duration (in seconds)
  // ==========================================================================
  static const int cacheDurationShops = 300;
  static const int cacheDurationProducts = 300;
  static const int cacheDurationOrders = 60;

  // ==========================================================================
  // User Roles
  // ==========================================================================
  static const String roleCustomer = 'customer';
  static const String roleShopOwner = 'shop_owner';
  static const String roleDriver = 'driver';
  static const String roleGura_nowAdmin = 'gura_now_admin';
  static const String roleSupportAgent = 'support_agent';
  static const String roleGura_nowEmployee = 'gura_now_employee';
  static const String roleShopEmployee = 'shop_employee';

  // ==========================================================================
  // Order Statuses
  // ==========================================================================
  static const String orderStatusPending = 'pending';
  static const String orderStatusConfirmed = 'confirmed';
  static const String orderStatusShipped = 'shipped';
  static const String orderStatusDelivered = 'delivered';
  static const String orderStatusCancelled = 'cancelled';

  // ==========================================================================
  // Delivery Modes
  // ==========================================================================
  static const String deliveryModeShop = 'shop_delivery';
  static const String deliveryModeIndependent = 'independent';
  static const String deliveryModePickup = 'pickup';

  // ==========================================================================
  // Payment Methods
  // ==========================================================================
  static const String paymentCash = 'cash';
  static const String paymentLumicash = 'lumicash';
  static const String paymentEcocash = 'ecocash';
  static const String paymentMobileMoney = 'mobile_money';

  // ==========================================================================
  // Driver Types
  // ==========================================================================
  static const String driverTypeGura_nowEmployee = 'gura_now_employee';
  static const String driverTypeShopEmployee = 'shop_employee';
  static const String driverTypeIndependent = 'independent';

  // ==========================================================================
  // Trusted Drivers Mode
  // ==========================================================================
  static const String trustedDriversExclusive = 'exclusive';
  static const String trustedDriversOptional = 'optional';
  static const String trustedDriversDisabled = 'disabled';

  // ==========================================================================
  // Vehicle Types
  // ==========================================================================
  static const String vehicleMotorcycle = 'motorcycle';
  static const String vehicleCar = 'car';
  static const String vehicleBicycle = 'bicycle';

  // ==========================================================================
  // Error Messages
  // ==========================================================================
  static const String errorUnauthorized = 'Authentification requise';
  static const String errorForbidden = 'Accès refusé';
  static const String errorNotFound = 'Ressource non trouvée';
  static const String errorServerError = 'Erreur serveur';
  static const String errorNetworkError = 'Erreur de connexion';
  static const String errorTimeout = "Délai d'attente dépassé";
  static const String errorValidation = 'Erreur de validation';
  static const String errorUnknown = "Une erreur inattendue s'est produite";

  // ==========================================================================
  // Success Messages
  // ==========================================================================
  static const String successLogin = 'Connexion réussie';
  static const String successRegister = 'Inscription réussie';
  static const String successLogout = 'Déconnexion réussie';
  static const String successOrderCreated = 'Commande créée avec succès';
  static const String successOrderConfirmed = 'Commande confirmée';
  static const String successProfileUpdated = 'Profil mis à jour';

  // ==========================================================================
  // Pagination
  // ==========================================================================
  static const int defaultPageSize = 20;
  static const int defaultPageNumber = 1;

  // ==========================================================================
  // Limits
  // ==========================================================================
  static const int maxImageUploadSizeMB = 10;
  static const int maxShopNameLength = 100;
  static const int maxProductNameLength = 150;
  static const int maxDescriptionLength = 1000;
}
