/// Text Styles for Gura Now
/// Dark mode optimized with Plus Jakarta Sans font
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ============================================================================
  // HEADINGS (for dark mode)
  // ============================================================================

  /// Extra large title (28sp) - Hero sections
  static TextStyle get heading1 => GoogleFonts.plusJakartaSans(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.25,
        letterSpacing: -0.5,
      );

  /// Large title (24sp) - Page titles
  static TextStyle get heading2 => GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.3,
        letterSpacing: -0.3,
      );

  /// Medium title (20sp) - Section headers
  static TextStyle get heading3 => GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.35,
        letterSpacing: -0.2,
      );

  /// Small title (18sp) - Subsection headers
  static TextStyle get heading4 => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
        letterSpacing: -0.1,
      );

  /// Card title (16sp) - Cards, list items
  static TextStyle get heading5 => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.45,
        letterSpacing: 0,
      );

  // ============================================================================
  // BODY TEXT
  // ============================================================================

  /// Large body (16sp) - Primary content
  static TextStyle get bodyLarge => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.6,
        letterSpacing: 0.15,
      );

  /// Medium body (14sp) - Default content
  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.55,
        letterSpacing: 0.15,
      );

  /// Small body (12sp) - Secondary content
  static TextStyle get bodySmall => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
        letterSpacing: 0.2,
      );

  /// Extra small (11sp) - Captions, metadata
  static TextStyle get bodyXSmall => GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.textTertiary,
        height: 1.45,
        letterSpacing: 0.2,
      );

  // ============================================================================
  // BUTTONS
  // ============================================================================

  /// Large button text (16sp)
  static TextStyle get buttonLarge => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnPrimary,
        height: 1.4,
        letterSpacing: 0.2,
      );

  /// Medium button text (14sp)
  static TextStyle get button => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnPrimary,
        height: 1.4,
        letterSpacing: 0.2,
      );

  /// Small button text (12sp)
  static TextStyle get buttonSmall => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnPrimary,
        height: 1.35,
        letterSpacing: 0.3,
      );

  // ============================================================================
  // LABELS & CAPTIONS
  // ============================================================================

  /// Form label (14sp)
  static TextStyle get label => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.4,
        letterSpacing: 0.1,
      );

  /// Small label (12sp)
  static TextStyle get labelSmall => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: 1.4,
        letterSpacing: 0.2,
      );

  /// Caption (11sp)
  static TextStyle get caption => GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.textTertiary,
        height: 1.4,
        letterSpacing: 0.3,
      );

  /// Caption bold (11sp)
  static TextStyle get captionBold => GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        height: 1.4,
        letterSpacing: 0.3,
      );

  /// Overline (10sp) - All caps labels
  static TextStyle get overline => GoogleFonts.plusJakartaSans(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: AppColors.textTertiary,
        height: 1.4,
        letterSpacing: 1.2,
      );

  // ============================================================================
  // SPECIAL STYLES
  // ============================================================================

  /// Price (18sp) - Product prices
  static TextStyle get price => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.3,
        letterSpacing: -0.2,
      );

  /// Large price (24sp) - Order totals
  static TextStyle get priceLarge => GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.25,
        letterSpacing: -0.3,
      );

  /// Small price (14sp) - Inline prices
  static TextStyle get priceSmall => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.35,
        letterSpacing: 0,
      );

  /// Strikethrough price (14sp) - Original price
  static TextStyle get priceStrikethrough => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textTertiary,
        height: 1.35,
        letterSpacing: 0,
        decoration: TextDecoration.lineThrough,
      );

  /// Error text (12sp)
  static TextStyle get error => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.danger,
        height: 1.4,
        letterSpacing: 0.2,
      );

  /// Success text (12sp)
  static TextStyle get success => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.success,
        height: 1.4,
        letterSpacing: 0.2,
      );

  /// Warning text (12sp)
  static TextStyle get warning => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.warning,
        height: 1.4,
        letterSpacing: 0.2,
      );

  /// Link text (14sp)
  static TextStyle get link => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.primary,
        height: 1.5,
        letterSpacing: 0.15,
      );

  /// Link underlined (14sp)
  static TextStyle get linkUnderlined => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.primary,
        decoration: TextDecoration.underline,
        decorationColor: AppColors.primary,
        height: 1.5,
        letterSpacing: 0.15,
      );

  /// Disabled text (14sp)
  static TextStyle get disabled => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textDisabled,
        height: 1.5,
        letterSpacing: 0.15,
      );

  /// Badge text (10sp)
  static TextStyle get badge => GoogleFonts.plusJakartaSans(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: AppColors.textOnPrimary,
        height: 1.2,
        letterSpacing: 0.5,
      );

  /// Number/Stats (32sp) - Large numbers
  static TextStyle get statLarge => GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.2,
        letterSpacing: -0.5,
      );

  /// Medium stats (24sp)
  static TextStyle get statMedium => GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.25,
        letterSpacing: -0.3,
      );

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Get heading style by level (1-5)
  static TextStyle getHeading(int level) {
    switch (level) {
      case 1:
        return heading1;
      case 2:
        return heading2;
      case 3:
        return heading3;
      case 4:
        return heading4;
      case 5:
        return heading5;
      default:
        return heading3;
    }
  }

  /// Copy style with custom color
  static TextStyle withColor(TextStyle style, Color color) =>
      style.copyWith(color: color);

  /// Copy style with custom size
  static TextStyle withSize(TextStyle style, double size) =>
      style.copyWith(fontSize: size);

  /// Copy style with custom weight
  static TextStyle withWeight(TextStyle style, FontWeight weight) =>
      style.copyWith(fontWeight: weight);

  /// Make style semi-bold
  static TextStyle semiBold(TextStyle style) =>
      style.copyWith(fontWeight: FontWeight.w600);

  /// Make style bold
  static TextStyle bold(TextStyle style) =>
      style.copyWith(fontWeight: FontWeight.w700);

  /// Make style with primary color
  static TextStyle primary(TextStyle style) =>
      style.copyWith(color: AppColors.primary);

  /// Make style with secondary text color
  static TextStyle secondary(TextStyle style) =>
      style.copyWith(color: AppColors.textSecondary);
}
