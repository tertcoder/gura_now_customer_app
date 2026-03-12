/// Validators for Gura Now
/// Phone, email, password, and business rules validation
library;

class Validators {
  // Burundi phone regex: +257 followed by 6 or 7 and 7 more digits
  static final RegExp burundPhoneRegex = RegExp(r'^\+257[67]\d{7}$');
  static final RegExp phoneOnlyRegex = RegExp(r'^[67]\d{7}$');
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  /// Validate Burundi phone number
  /// Accepts: +257XXXXXXXXX or 67XXXXXXXX or 257XXXXXXXX
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le numéro de téléphone est requis';
    }

    var phone = value.trim();

    // Remove spaces and dashes
    phone = phone.replaceAll(RegExp(r'[\s\-]'), '');

    // Try different formats
    var isValid = false;

    // Format: +257XXXXXXXXX (full with +)
    if (phone.startsWith('+')) {
      isValid = burundPhoneRegex.hasMatch(phone);
    }
    // Format: 67XXXXXXXX (without country code)
    else if (phoneOnlyRegex.hasMatch(phone)) {
      isValid = true;
    }
    // Format: 257XXXXXXXX (country code without +)
    else if (phone.startsWith('257') && phone.length == 12) {
      final withoutCountry = phone.substring(3);
      isValid = phoneOnlyRegex.hasMatch(withoutCountry);
    }

    if (!isValid) {
      return 'Entrez un numéro Burundi valide (+257 6/7 XXXXXXX)';
    }

    return null;
  }

  /// Normalize phone number to standard format (+257XXXXXXXXX)
  static String normalizePhoneNumber(String phone) {
    phone = phone.trim().replaceAll(RegExp(r'[\s\-]'), '');

    if (phone.startsWith('+')) {
      return phone;
    } else if (phone.startsWith('257')) {
      return '+$phone';
    } else if (phoneOnlyRegex.hasMatch(phone)) {
      return '+257$phone';
    }

    return '+257$phone';
  }

  /// Validate email address
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'email est requis';
    }

    if (!emailRegex.hasMatch(value)) {
      return 'Entrez une adresse email valide';
    }

    return null;
  }

  /// Validate password strength
  /// Requirements: Minimum 8 characters, uppercase, lowercase, digit, special char
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }

    if (value.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Le mot de passe doit contenir au moins une majuscule';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Le mot de passe doit contenir au moins une minuscule';
    }

    if (!value.contains(RegExp(r'\d'))) {
      return 'Le mot de passe doit contenir au moins un chiffre';
    }

    if (!value.contains(RegExp(r'[@$!%*?&]'))) {
      return r'Le mot de passe doit contenir au moins un caractère spécial (@$!%*?&)';
    }

    return null;
  }

  /// Validate password confirmation matches
  static String? validatePasswordConfirmation(
      String? password, String? confirmation) {
    if (password == null || confirmation == null) {
      return 'La confirmation du mot de passe est requise';
    }

    if (password != confirmation) {
      return 'Les mots de passe ne correspondent pas';
    }

    return null;
  }

  /// Validate name (not empty, reasonable length)
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le nom est requis';
    }

    if (value.length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }

    if (value.length > 100) {
      return 'Le nom ne peut pas dépasser 100 caractères';
    }

    return null;
  }

  /// Validate non-empty string
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName est requis';
    }
    return null;
  }

  /// Validate positive number
  static String? validatePositiveNumber(String? value,
      {String fieldName = 'Number'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName est requis';
    }

    try {
      final num = double.parse(value);
      if (num <= 0) {
        return '$fieldName doit être positif';
      }
    } catch (e) {
      return '$fieldName doit être un nombre valide';
    }

    return null;
  }

  /// Validate URL
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'URL est requise';
    }

    try {
      Uri.parse(value);
      return null;
    } catch (e) {
      return 'L\'URL n\'est pas valide';
    }
  }

  /// Check if string is numeric only
  static bool isNumeric(String str) => RegExp(r'^-?[0-9]+$').hasMatch(str);

  /// Check password strength (returns percentage 0-100)
  static int getPasswordStrength(String password) {
    var strength = 0;

    if (password.isEmpty) return 0;

    // Length check
    if (password.length >= 8) strength += 20;
    if (password.length >= 12) strength += 10;
    if (password.length >= 16) strength += 10;

    // Character variety
    if (password.contains(RegExp(r'[a-z]'))) strength += 15;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 15;
    if (password.contains(RegExp(r'\d'))) strength += 15;
    if (password.contains(RegExp(r'[@$!%*?&]'))) strength += 15;

    return strength.clamp(0, 100);
  }

  /// Get password strength label
  static String getPasswordStrengthLabel(String password) {
    final strength = getPasswordStrength(password);

    if (strength < 20) return 'Très faible';
    if (strength < 40) return 'Faible';
    if (strength < 60) return 'Acceptable';
    if (strength < 80) return 'Fort';
    return 'Très fort';
  }
}
