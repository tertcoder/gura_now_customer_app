/// Currency Formatting for Burundian Franc (BIF).
library;

class CurrencyFormatter {
  CurrencyFormatter._();

  /// Currency symbol
  static const String currencySymbol = 'FBu';

  /// ISO 4217 currency code
  static const String currencyCode = 'BIF';

  /// Decimal places (BIF has no decimal places)
  static const int currencyDecimalPlaces = 0;

  /// Locale for formatting
  static const String currencyLocale = 'fr_BI';

  /// Format amount as Burundian Franc.
  ///
  /// Example: `10000` => `'FBu 10.000'` or `'10.000 FBu'`
  static String formatBIF(double amount, {bool symbolFirst = false}) {
    final formattedAmount = amount.toStringAsFixed(0);
    final parts = formattedAmount.split('.');
    final wholePart = parts[0];

    final formatted = wholePart.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (m) => '.',
    );

    return symbolFirst
        ? '$currencySymbol $formatted'
        : '$formatted $currencySymbol';
  }

  /// Parse string currency back to double.
  ///
  /// Example: `'FBu 10.000'` => `10000.0`
  static double parseBIF(String currencyString) {
    final cleaned = currencyString
        .replaceAll(currencySymbol, '')
        .replaceAll(' ', '')
        .trim()
        .replaceAll('.', '');

    try {
      return double.parse(cleaned);
    } catch (_) {
      return 0;
    }
  }

  /// Format with default symbol position (after amount).
  ///
  /// Example: `10000` => `'10.000 FBu'`
  static String format(double amount) => formatBIF(amount);

  /// Calculate commission (5%).
  static double calculateCommission(double amount) => amount * 0.05;

  /// Calculate total with commission.
  static double calculateTotal(double subtotal) =>
      subtotal + calculateCommission(subtotal);

  /// Format subtotal with commission breakdown.
  ///
  /// Returns: `{'subtotal': '...', 'commission': '...', 'total': '...'}`
  static Map<String, String> formatWithBreakdown(double subtotal) {
    final commission = calculateCommission(subtotal);
    final total = calculateTotal(subtotal);

    return {
      'subtotal': formatBIF(subtotal),
      'commission': formatBIF(commission),
      'total': formatBIF(total),
      'commissionPercent': '5%',
    };
  }
}
