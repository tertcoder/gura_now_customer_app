import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptTerms = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Veuillez accepter les conditions d\'utilisation'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final normalizedPhone =
          Validators.normalizePhoneNumber(_phoneController.text.trim());

      // Navigate to OTP verification with registration data
      context.push('/verify-otp', extra: {
        'type': 'register',
        'fullName': _fullNameController.text.trim(),
        'phoneNumber': normalizedPhone,
        'email': _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        'password': _passwordController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          context.go('/home');
        } else if (state.status == AuthStatus.error &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.danger,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0F0F0F),
                  Color(0xFF0A0A0A),
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Back button
                          _BackButton(onPressed: () => context.pop()),
                          const SizedBox(height: 24),

                          // Header
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Créer un compte',
                                      style: AppTextStyles.heading2,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Rejoignez la communauté Gura Now',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Image.asset(
                                AppAssets.logoIconColor,
                                width: 48,
                                height: 48,
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Progress indicator
                          _ProgressIndicator(currentStep: 1, totalSteps: 2),
                          const SizedBox(height: 32),

                          // Full name
                          _InputField(
                            controller: _fullNameController,
                            label: 'Nom complet',
                            hint: 'Ex: Jean Niyonzima',
                            prefixIcon: Icons.person_outline,
                            validator: Validators.validateName,
                          ),
                          const SizedBox(height: 20),

                          // Phone
                          _InputField(
                            controller: _phoneController,
                            label: 'Numéro de téléphone',
                            hint: '+257 79 XXX XXX',
                            prefixIcon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre numéro';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Email (optional)
                          _InputField(
                            controller: _emailController,
                            label: 'Email (optionnel)',
                            hint: 'exemple@email.com',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return null;
                              }
                              return Validators.validateEmail(value);
                            },
                          ),
                          const SizedBox(height: 20),

                          // Password with strength indicator
                          _InputField(
                            controller: _passwordController,
                            label: 'Mot de passe',
                            hint: 'Min 8 caractères',
                            prefixIcon: Icons.lock_outline,
                            obscureText: !_isPasswordVisible,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            validator: Validators.validatePassword,
                          ),
                          const SizedBox(height: 8),
                          _PasswordStrengthBar(
                            password: _passwordController.text,
                          ),
                          const SizedBox(height: 20),

                          // Confirm password
                          _InputField(
                            controller: _confirmPasswordController,
                            label: 'Confirmer mot de passe',
                            hint: 'Répétez le mot de passe',
                            prefixIcon: Icons.lock_outline,
                            obscureText: !_isConfirmPasswordVisible,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                            validator: (value) =>
                                Validators.validatePasswordConfirmation(
                              _passwordController.text,
                              value,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Terms checkbox
                          GestureDetector(
                            onTap: () {
                              setState(() => _acceptTerms = !_acceptTerms);
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: _acceptTerms
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: _acceptTerms
                                          ? AppColors.primary
                                          : AppColors.borderLight,
                                      width: 2,
                                    ),
                                  ),
                                  child: _acceptTerms
                                      ? const Icon(
                                          Icons.check,
                                          size: 16,
                                          color: AppColors.white,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      text: 'J\'accepte les ',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'Conditions d\'utilisation',
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const TextSpan(text: ' et la '),
                                        TextSpan(
                                          text: 'Politique de confidentialité',
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Continue button
                          _GradientButton(
                            text: 'Continuer',
                            isLoading: isLoading,
                            onPressed: _submit,
                            icon: Icons.arrow_forward_rounded,
                          ),
                          const SizedBox(height: 24),

                          // Login link
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Déjà inscrit? ',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => context.go('/login'),
                                  child: Text(
                                    'Se connecter',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.borderGray,
            width: 1,
          ),
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          color: AppColors.textPrimary,
          size: 22,
        ),
      ),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Étape $currentStep',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              ' / $totalSteps',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textDisabled,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(totalSteps, (index) {
            final isActive = index < currentStep;
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: index < totalSteps - 1 ? 8 : 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: isActive
                      ? AppColors.gradientPrimary
                      : null,
                  color: isActive ? null : AppColors.surfaceContainer,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textDisabled,
            ),
            prefixIcon: Icon(
              prefixIcon,
              color: AppColors.textSecondary,
              size: 20,
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.surfaceContainer,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.borderGray),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.borderGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.danger),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.danger, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

/// Password strength indicator: red -> orange -> green bar
class _PasswordStrengthBar extends StatelessWidget {
  const _PasswordStrengthBar({required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final strength = Validators.getPasswordStrength(password);
    Color barColor = AppColors.danger;
    if (strength >= 60) {
      barColor = AppColors.success;
    } else if (strength >= 30) {
      barColor = AppColors.guraOrange;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: strength / 100,
                  minHeight: 6,
                  backgroundColor: AppColors.surfaceContainer,
                  valueColor: AlwaysStoppedAnimation<Color>(barColor),
                ),
              ),
            ),
            if (password.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(
                Validators.getPasswordStrengthLabel(password),
                style: AppTextStyles.caption.copyWith(
                  color: barColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.gradientPrimary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.guraRed.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.white,
                        fontSize: 16,
                      ),
                    ),
                    if (icon != null) ...[
                      const SizedBox(width: 8),
                      Icon(icon, color: AppColors.white, size: 20),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
