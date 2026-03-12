/// String and Int Extensions for Gura Now
library;

extension StringExtension on String {
  /// Check if string is empty or whitespace only
  bool get isBlank => trim().isEmpty;

  /// Check if string is not empty and not whitespace
  bool get isNotBlank => !isBlank;

  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize each word
  String get capitalizeEachWord =>
      split(' ').map((word) => word.capitalize).join(' ');

  /// Check if string is a valid URL
  bool get isValidUrl {
    try {
      Uri.parse(this);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Remove all whitespace
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Truncate string with ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Extract numbers only
  String get onlyNumbers => replaceAll(RegExp(r'[^0-9]'), '');

  /// Extract letters only
  String get onlyLetters => replaceAll(RegExp(r'[^a-zA-Z]'), '');

  /// Check if string contains only letters
  bool get isAlpha => RegExp(r'^[a-zA-Z]+$').hasMatch(this);

  /// Check if string contains only numbers
  bool get isNumeric => RegExp(r'^[0-9]+$').hasMatch(this);

  /// Check if string contains only alphanumeric
  bool get isAlphaNumeric => RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);

  /// Reverse string
  String get reverse => split('').reversed.join('');

  /// Check if string is a palindrome
  bool get isPalindrome => toLowerCase() == toLowerCase().reverse;

  /// Format as currency (BIF)
  String get asBIF {
    try {
      final value = double.parse(this);
      return 'FBu ${value.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'\B(?=(\d{3})+(?!\d))'),
            (m) => '.',
          )}';
    } catch (e) {
      return this;
    }
  }

  /// Check if string contains only Burundi phone valid characters
  bool get isValidBurundiPhone {
    final normalized = removeWhitespace;
    return RegExp(r'^\+?257[67]\d{7}$').hasMatch(normalized);
  }

  /// Extract Burundi phone number from text
  String? extractBurundiPhone() {
    final regex = RegExp(r'\+?257[67]\d{7}');
    final match = regex.firstMatch(this);
    return match?.group(0);
  }
}

extension IntExtension on int {
  /// Convert to formatted currency string (BIF)
  String get asBIF {
    final formatted = toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (m) => '.',
    );
    return '$formatted FBu';
  }

  /// Convert to formatted currency string with symbol first
  String get asBIFSymbolFirst {
    final formatted = toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (m) => '.',
    );
    return 'FBu $formatted';
  }

  /// Check if number is even
  bool get isEven => this % 2 == 0;

  /// Check if number is odd
  bool get isOdd => this % 2 != 0;

  /// Check if number is positive
  bool get isPositive => this > 0;

  /// Check if number is negative
  bool get isNegative => this < 0;

  /// Check if number is zero
  bool get isZero => this == 0;

  /// Get absolute value
  int get abs => this.abs();

  /// Format percentage
  String get asPercent => '$this%';

  /// Get ordinal number (1st, 2nd, 3rd, etc.)
  String get asOrdinal {
    if (this == 1) return '1er';
    if (this == 2) return '2e';
    if (this == 3) return '3e';
    return '${this}e';
  }

  /// Convert seconds to readable duration
  String get asDuration {
    if (this < 60) return '$this sec';
    if (this < 3600) {
      final minutes = this ~/ 60;
      final seconds = this % 60;
      return '$minutes min ${seconds}s';
    }
    final hours = this ~/ 3600;
    final minutes = (this % 3600) ~/ 60;
    return '$hours h $minutes min';
  }
}

extension DoubleExtension on double {
  /// Convert to formatted currency string (BIF)
  String get asBIF {
    final formatted = toStringAsFixed(0).replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (m) => '.',
    );
    return '$formatted FBu';
  }

  /// Convert to formatted currency string with symbol first
  String get asBIFSymbolFirst {
    final formatted = toStringAsFixed(0).replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (m) => '.',
    );
    return 'FBu $formatted';
  }

  /// Round to 2 decimal places
  double get rounded2 => (this * 100).round() / 100;

  /// Round to n decimal places
  double roundTo(int decimals) {
    final mod = pow(10, decimals).toDouble();
    return (this * mod).round().toDouble() / mod;
  }

  /// Check if number is even (for integers)
  bool get isEven => toInt() % 2 == 0;

  /// Check if number is odd (for integers)
  bool get isOdd => toInt() % 2 != 0;

  /// Check if number is positive
  bool get isPositive => this > 0;

  /// Check if number is negative
  bool get isNegative => this < 0;

  /// Check if number is zero
  bool get isZero => this == 0;

  /// Format percentage with decimals
  String asPercent({int decimals = 1}) => '${toStringAsFixed(decimals)}%';

  /// Format percentage (integer)
  String get asPercentInt => '${toInt()}%';
}

/// pow function for double extension
double pow(double base, int exponent) {
  double result = 1;
  for (var i = 0; i < exponent; i++) {
    result *= base;
  }
  return result;
}
