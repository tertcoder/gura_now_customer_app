import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// International phone number input field with country selector.
///
/// This widget provides a phone input with:
/// - Country selector with flags
/// - Automatic E.164 formatting
/// - Dynamic validation based on selected country
/// - Burundi as default country
class InternationalPhoneField extends StatelessWidget {
  const InternationalPhoneField({
    required this.controller,
    super.key,
    this.validator,
    this.onChanged,
    this.initialCountryCode = 'BI',
    this.label = 'Téléphone',
    this.hint,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final String initialCountryCode;
  final String label;
  final String? hint;

  @override
  Widget build(BuildContext context) => IntlPhoneField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.label,
          hintText: hint,
          filled: true,
          fillColor: AppColors.lightGray,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: AppColors.borderGray),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: AppColors.borderGray),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: AppColors.black, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: AppColors.danger),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: AppColors.danger, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        initialCountryCode: initialCountryCode,
        languageCode: 'fr',
        onChanged: (phone) {
          if (onChanged != null) {
            onChanged!(phone.completeNumber);
          }
        },
        validator: (phone) {
          if (phone == null || phone.completeNumber.isEmpty) {
            return 'Le numéro de téléphone est requis';
          }

          if (validator != null) {
            return validator!(phone.completeNumber);
          }

          return null;
        },
        dropdownTextStyle: AppTextStyles.bodyMedium,
        style: AppTextStyles.bodyMedium,
        flagsButtonPadding: const EdgeInsets.only(left: 12),
        dropdownIconPosition: IconPosition.trailing,
        showCountryFlag: true,
        showDropdownIcon: true,
      );
}
