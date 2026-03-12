import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/auth_bloc.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    super.key,
    required this.verificationType,
    this.phoneNumber,
    this.registrationData,
  });

  /// 'register' or 'forgot_password'
  final String verificationType;
  final String? phoneNumber;
  final Map<String, dynamic>? registrationData;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with SingleTickerProviderStateMixin {
  final _otpController = TextEditingController();
  final _focusNode = FocusNode();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  Timer? _resendTimer;
  int _resendSeconds = 60;
  bool _canResend = false;

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
    _startResendTimer();

    // Auto focus on OTP field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _startResendTimer() {
    _canResend = false;
    _resendSeconds = 60;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _otpController.dispose();
    _focusNode.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _verifyOtp() {
    if (_otpController.text.length == 6) {
      if (widget.verificationType == 'register' &&
          widget.registrationData != null) {
        // Complete registration
        context.read<AuthBloc>().add(AuthRegisterRequested(
              fullName: widget.registrationData!['fullName'] as String,
              phoneNumber: widget.registrationData!['phoneNumber'] as String,
              email: widget.registrationData!['email'] as String?,
              password: widget.registrationData!['password'] as String,
              role: 'customer',
            ));
      } else if (widget.verificationType == 'forgot_password') {
        // Navigate to reset password
        context.push('/reset-password', extra: {
          'phoneNumber': widget.phoneNumber,
          'otp': _otpController.text,
        });
      }
    }
  }

  void _resendOtp() {
    if (_canResend) {
      // TODO: Implement resend OTP API call
      _startResendTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Code renvoyé avec succès'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  String get _displayPhone {
    final phone = widget.phoneNumber ??
        widget.registrationData?['phoneNumber'] as String? ??
        '';
    if (phone.length >= 8) {
      return '${phone.substring(0, 4)} *** ${phone.substring(phone.length - 3)}';
    }
    return phone;
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
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button
                      _BackButton(onPressed: () => context.pop()),
                      const SizedBox(height: 32),

                      // Progress indicator (for register flow)
                      if (widget.verificationType == 'register')
                        _ProgressIndicator(currentStep: 2, totalSteps: 2),
                      if (widget.verificationType == 'register')
                        const SizedBox(height: 32),

                      // Header
                      Center(
                        child: Column(
                          children: [
                            // OTP Icon
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [
                                    AppColors.primary.withValues(alpha: 0.2),
                                    Colors.transparent,
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: AppColors.gradientPrimary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.guraRed
                                          .withValues(alpha: 0.4),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.sms_outlined,
                                  color: AppColors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            Text(
                              'Vérification OTP',
                              style: AppTextStyles.heading2,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Entrez le code à 6 chiffres envoyé au',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _displayPhone,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),

                      // OTP Input
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        controller: _otpController,
                        focusNode: _focusNode,
                        animationType: AnimationType.fade,
                        keyboardType: TextInputType.number,
                        autoFocus: true,
                        cursorColor: AppColors.primary,
                        textStyle: AppTextStyles.heading3.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(14),
                          fieldHeight: 60,
                          fieldWidth: 50,
                          activeFillColor: AppColors.surfaceLight,
                          inactiveFillColor: AppColors.surfaceContainer,
                          selectedFillColor: AppColors.surfaceLight,
                          activeColor: AppColors.primary,
                          inactiveColor: AppColors.borderGray,
                          selectedColor: AppColors.primary,
                          errorBorderColor: AppColors.danger,
                        ),
                        enableActiveFill: true,
                        onCompleted: (value) {
                          _verifyOtp();
                        },
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 32),

                      // Verify button
                      _GradientButton(
                        text: 'Vérifier',
                        isLoading: isLoading,
                        onPressed: _verifyOtp,
                      ),
                      const SizedBox(height: 32),

                      // Resend code
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Vous n\'avez pas reçu le code?',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: _canResend ? _resendOtp : null,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.refresh_rounded,
                                    size: 18,
                                    color: _canResend
                                        ? AppColors.primary
                                        : AppColors.textDisabled,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _canResend
                                        ? 'Renvoyer le code'
                                        : 'Renvoyer dans ${_resendSeconds}s',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: _canResend
                                          ? AppColors.primary
                                          : AppColors.textDisabled,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Help text
                      Center(
                        child: Text(
                          'Le code expire dans 10 minutes',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textDisabled,
                          ),
                        ),
                      ),
                    ],
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
                  gradient: isActive ? AppColors.gradientPrimary : null,
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

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

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
              : Text(
                  text,
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.white,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}
