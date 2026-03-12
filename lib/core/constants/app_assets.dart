/// Asset paths for Gura Now
/// Centralized asset references for easy maintenance
library;

class AppAssets {
  AppAssets._();

  // ============================================================================
  // BASE PATHS
  // ============================================================================

  static const String _logosPath = 'assets/logos';
  static const String _pngLogosPath = '$_logosPath/pngs';
  static const String _svgLogosPath = '$_logosPath/svgs';
  static const String _imagesPath = 'assets/images';
  static const String _iconsPath = 'assets/icons';

  // ============================================================================
  // LOGO ASSETS (SVG) - Preferred for scalability
  // ============================================================================

  /// Full logo with colors (SVG)
  static const String logoFullColorSvg =
      '$_svgLogosPath/gura_now_whole_in_colors.svg';

  /// Full logo white (SVG) - For dark backgrounds
  static const String logoFullWhiteSvg =
      '$_svgLogosPath/gura_now_whole_white.svg';

  /// Full logo black (SVG) - For light backgrounds
  static const String logoFullBlackSvg =
      '$_svgLogosPath/gura_now_whole_black.svg';

  /// Icon only with colors (SVG)
  static const String logoIconColorSvg =
      '$_svgLogosPath/gura_icon_in_colors.svg';

  /// Icon only white (SVG)
  static const String logoIconWhiteSvg =
      '$_svgLogosPath/gura_now_icon_white.svg';

  /// Icon only black (SVG)
  static const String logoIconBlackSvg = '$_svgLogosPath/gura_icon_black.svg';

  /// Typography only with colors (SVG)
  static const String logoTypoColorSvg =
      '$_svgLogosPath/gura_now_typo_in_colors.svg';

  /// Typography only white (SVG)
  static const String logoTypoWhiteSvg =
      '$_svgLogosPath/gura_now_typo_white.svg';

  /// Typography only black (SVG)
  static const String logoTypoBlackSvg = '$_svgLogosPath/gura_typo_black.svg';

  /// Variant 1 (SVG)
  static const String logoVariant1Svg = '$_svgLogosPath/gura_now_variant_1.svg';

  /// Variant 2 (SVG)
  static const String logoVariant2Svg = '$_svgLogosPath/gura_now_variant_2.svg';

  // ============================================================================
  // LOGO ASSETS (PNG) - Fallback/Raster
  // ============================================================================

  /// Full logo with colors - Primary logo for splash screens
  static const String logoFullColor =
      '$_pngLogosPath/gura_now_whole_in_colors.png';

  /// Full logo white version - For dark backgrounds
  static const String logoFullWhite = '$_pngLogosPath/gura_now_whole_white.png';

  /// Full logo black version - For light backgrounds
  static const String logoFullBlack = '$_pngLogosPath/gura_now_whole_black.png';

  /// Icon only with colors - App icon, avatars
  static const String logoIconColor = '$_pngLogosPath/gura_icon_in_colors.png';

  /// Icon only white - For dark backgrounds
  static const String logoIconWhite = '$_pngLogosPath/gura_icon_white.png';

  /// Icon only black - For light backgrounds
  static const String logoIconBlack = '$_pngLogosPath/gura_icon_black.png';

  /// Typography only with colors
  static const String logoTypoColor = '$_pngLogosPath/gura_typo_in_colors.png';

  /// Typography only white
  static const String logoTypoWhite = '$_pngLogosPath/gura_typo_white.png';

  /// Typography only black
  static const String logoTypoBlack = '$_pngLogosPath/gura_typo_black.png';

  /// Variant 1 - Alternative logo design
  static const String logoVariant1 = '$_pngLogosPath/gura_variant_1.png';

  /// Variant 2 - Alternative logo design
  static const String logoVariant2 = '$_pngLogosPath/gura_variant_2.png';

  // ============================================================================
  // COMMONLY USED ALIASES (SVG preferred)
  // ============================================================================

  /// Default logo for dark theme (white/colored version)
  static const String logoDark = logoFullWhiteSvg;

  /// Default logo for light theme (black version)
  static const String logoLight = logoFullBlackSvg;

  /// App icon for navigation/headers (colored)
  static const String appIcon = logoIconColorSvg;

  /// Splash screen logo (white for dark background)
  static const String splashLogo = logoFullWhiteSvg;

  /// Onboarding logo (colored variant)
  static const String onboardingLogo = logoVariant1Svg;

  // ============================================================================
  // IMAGE ASSETS
  // ============================================================================

  static const String imagesPath = _imagesPath;

  // Placeholder images (add actual paths when available)
  static const String placeholderProduct =
      '$_imagesPath/placeholder_product.png';
  static const String placeholderShop = '$_imagesPath/placeholder_shop.png';
  static const String placeholderUser = '$_imagesPath/placeholder_user.png';
  static const String emptyCart = '$_imagesPath/empty_cart.png';
  static const String emptyOrders = '$_imagesPath/empty_orders.png';
  static const String noResults = '$_imagesPath/no_results.png';

  // ============================================================================
  // ICON ASSETS
  // ============================================================================

  static const String iconsPath = _iconsPath;

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Get the appropriate logo based on theme brightness
  static String getLogoForBrightness(bool isDark) =>
      isDark ? logoDark : logoLight;

  /// Get icon logo based on theme brightness
  static String getIconForBrightness(bool isDark) =>
      isDark ? logoIconColor : logoIconBlack;
}
