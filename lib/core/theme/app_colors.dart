/// Color Palette for Gura Now
/// Dark Mode with brand colors from logo
///
/// COLOR HIERARCHY (Important!):
/// - PRIMARY (Red): Main CTAs, buttons, navigation, brand identity — DOMINANT
/// - SECONDARY (Orange): Warnings, promotions, highlights — SUPPORTING
/// - TERTIARY (Blue): Info, links, help elements — SEMANTIC ONLY
///
/// The app identity is RED. Use red consistently across all screens.
/// Orange and Blue are for specific semantic purposes, not as alternative primaries.
library;

import 'package:flutter/material.dart';

class AppColors {
  // ===============================================================
  // BRAND COLORS (from logo)
  // Hierarchy: Red (primary) > Orange (secondary) > Blue (tertiary)
  // ==============================================================

  /// Gura Red - PRIMARY brand color
  /// Use for: Main CTAs, buttons, FABs, selected states, progress indicators
  /// This is the app's identity color — use consistently across ALL screens
  static const Color guraRed = Color(0xFFE43225);

  /// Gura Orange - SECONDARY brand color
  /// Use for: Warnings, sale badges, promotions, pending states
  /// Supporting accent — do NOT use as primary button color
  static const Color guraOrange = Color(0xFFF7971D);

  /// Gura Blue - TERTIARY brand color
  /// Use for: Info elements, links, help, confirmed status
  /// Semantic accent — do NOT use as primary button color
  static const Color guraBlue = Color(0xFF0064D3);

  /// Brand White
  static const Color guraWhite = Color(0xFFFFFFFF);

  // ==============================================================
  // DARK MODE BACKGROUNDS
  // ==============================================================

  /// Deep black - Main background
  static const Color background = Color(0xFF0A0A0A);

  /// Surface - Cards, containers
  static const Color surface = Color(0xFF141414);

  /// Surface elevated - Elevated elements
  static const Color surfaceLight = Color(0xFF1E1E1E);

  /// Surface container - Input fields, modals
  static const Color surfaceContainer = Color(0xFF262626);

  /// Surface variant - Alternative surface
  static const Color surfaceVariant = Color(0xFF1A1A1A);

  // ==============================================================
  // NEUTRAL PALETTE
  // ==============================================================

  /// Pure black
  static const Color black = Color(0xFF000000);

  /// Pure white
  static const Color white = Color(0xFFFFFFFF);

  /// Light gray
  static const Color lightGray = Color(0xFFF5F5F5);

  /// Border gray - Subtle borders
  static const Color borderGray = Color(0xFF2E2E2E);

  /// Border light - Lighter borders
  static const Color borderLight = Color(0xFF3D3D3D);

  /// Medium gray
  static const Color mediumGray = Color(0xFF6B6B6B);

  /// Dark gray
  static const Color darkGray = Color(0xFF1F1F1F);

  /// Very dark gray
  static const Color veryDarkGray = Color(0xFF171717);

  // ==============================================================
  // PRIMARY ACCENT (Brand Red)
  // ==============================================================

  /// Primary accent - Gura Red
  static const Color primary = guraRed;

  /// Primary dark - Darker red for pressed states
  static const Color primaryDark = Color(0xFFC42A1F);

  /// Primary light - Lighter red for hover
  static const Color primaryLight = Color(0xFFFF4136);

  /// Primary container - Subtle red background
  static const Color primaryContainer = Color(0xFF2A1414);

  // ============================================================================
  // SECONDARY ACCENT (Brand Orange)
  // ============================================================================

  /// Secondary accent - Gura Orange
  static const Color secondary = guraOrange;

  /// Secondary dark
  static const Color secondaryDark = Color(0xFFD97F0D);

  /// Secondary light
  static const Color secondaryLight = Color(0xFFFFAB40);

  /// Secondary container
  static const Color secondaryContainer = Color(0xFF2A2014);

  // ============================================================================
  // TERTIARY ACCENT (Brand Blue)
  // ============================================================================

  /// Tertiary accent - Gura Blue
  static const Color tertiary = guraBlue;

  /// Tertiary dark
  static const Color tertiaryDark = Color(0xFF0052A3);

  /// Tertiary light
  static const Color tertiaryLight = Color(0xFF2979FF);

  /// Tertiary container
  static const Color tertiaryContainer = Color(0xFF14202A);

  // ============================================================================
  // LEGACY ACCENT COLORS (for compatibility)
  // ============================================================================

  /// Main accent (alias to primary)
  static const Color accent = primary;

  /// Accent dark
  static const Color accentDark = primaryDark;

  /// Accent light
  static const Color accentLight = primaryLight;

  /// Gold accent - Achievements, premium
  static const Color accentGold = Color(0xFFFFB800);

  /// Purple accent - Special features
  static const Color accentPurple = Color(0xFF8B5CF6);

  /// Pink accent - Notifications
  static const Color accentPink = Color(0xFFEC4899);

  // ============================================================================
  // TEXT COLORS
  // ============================================================================

  /// Primary text - Off-white for readability
  static const Color textPrimary = Color(0xFFF7F7F7);

  /// Secondary text - Muted gray
  static const Color textSecondary = Color(0xFF9E9E9E);

  /// Tertiary text - Even more muted
  static const Color textTertiary = Color(0xFF757575);

  /// Disabled text
  static const Color textDisabled = Color(0xFF525252);

  /// Text on primary color (red buttons)
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  /// Text on accent (legacy alias)
  static const Color textOnAccent = textOnPrimary;

  /// Text hint - Placeholder text
  static const Color textHint = Color(0xFF6B6B6B);

  // ============================================================================
  // SEMANTIC / ACTION COLORS
  // ============================================================================

  /// Success - Green
  static const Color success = Color(0xFF22C55E);

  /// Success dark
  static const Color successDark = Color(0xFF16A34A);

  /// Success light
  static const Color successLight = Color(0xFF4ADE80);

  /// Success container
  static const Color successContainer = Color(0xFF142A1A);

  /// Warning - Using brand orange
  static const Color warning = guraOrange;

  /// Warning dark
  static const Color warningDark = Color(0xFFD97F0D);

  /// Warning light
  static const Color warningLight = Color(0xFFFFAB40);

  /// Warning container
  static const Color warningContainer = Color(0xFF2A2014);

  /// Danger/Error - Distinct from brand red for clarity
  static const Color danger = Color(0xFFEF4444);

  /// Danger dark
  static const Color dangerDark = Color(0xFFDC2626);

  /// Danger light
  static const Color dangerLight = Color(0xFFF87171);

  /// Danger container
  static const Color dangerContainer = Color(0xFF2A1414);

  /// Info - Using brand blue
  static const Color info = guraBlue;

  /// Info dark
  static const Color infoDark = Color(0xFF0052A3);

  /// Info light
  static const Color infoLight = Color(0xFF2979FF);

  /// Info container
  static const Color infoContainer = Color(0xFF14202A);

  // ============================================================================
  // ORDER STATUS COLORS
  // ============================================================================

  /// Pending - Orange
  static const Color statusPending = warning;

  /// Confirmed - Blue
  static const Color statusConfirmed = info;

  /// In transit/Shipped - Primary red
  static const Color statusShipped = primary;

  /// Delivered - Green
  static const Color statusDelivered = success;

  /// Cancelled - Gray
  static const Color statusCancelled = Color(0xFF6B7280);

  // ============================================================================
  // SEMANTIC ALIASES
  // ============================================================================

  static const Color error = danger;
  static const Color highlightBackground = Color(0xFF1A1A1A);
  static const Color overlay = Color(0xE6000000);
  static const Color overlayLight = Color(0x80000000);
  static const Color transparent = Color(0x00000000);

  /// Shimmer base color for loading states
  static const Color shimmerBase = Color(0xFF1E1E1E);

  /// Shimmer highlight color
  static const Color shimmerHighlight = Color(0xFF2E2E2E);

  // ============================================================================
  // GRADIENTS
  // ============================================================================

  /// Primary gradient - Red to Orange (brand gradient)
  static const LinearGradient gradientPrimary = LinearGradient(
    colors: [guraRed, guraOrange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Accent gradient (alias)
  static const LinearGradient gradientAccent = gradientPrimary;

  /// Secondary gradient - Orange to Yellow
  static const LinearGradient gradientSecondary = LinearGradient(
    colors: [guraOrange, Color(0xFFFFB800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Tertiary gradient - Blue shades
  static const LinearGradient gradientTertiary = LinearGradient(
    colors: [guraBlue, Color(0xFF2979FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Premium gradient - Purple to Pink
  static const LinearGradient gradientPremium = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dark gradient - For backgrounds
  static const LinearGradient gradientDark = LinearGradient(
    colors: [Color(0xFF141414), Color(0xFF0A0A0A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Surface gradient
  static const LinearGradient gradientSurface = LinearGradient(
    colors: [Color(0xFF1E1E1E), Color(0xFF141414)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Subtle red gradient for cards/highlights
  static const LinearGradient gradientRedSubtle = LinearGradient(
    colors: [Color(0xFF1A1010), Color(0xFF141414)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'en_attente':
        return statusPending;
      case 'confirmed':
      case 'confirmée':
        return statusConfirmed;
      case 'shipped':
      case 'in_transit':
      case 'en_cours':
        return statusShipped;
      case 'delivered':
      case 'livrée':
        return statusDelivered;
      case 'cancelled':
      case 'annulée':
        return statusCancelled;
      default:
        return textSecondary;
    }
  }

  static Color getContrastTextColor(Color backgroundColor) {
    final luminance = (0.299 * backgroundColor.red +
            0.587 * backgroundColor.green +
            0.114 * backgroundColor.blue) /
        255;
    return luminance > 0.5 ? background : textPrimary;
  }

  static Color withAlpha(Color color, double opacity) =>
      color.withValues(alpha: opacity);
}
