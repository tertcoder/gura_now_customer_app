import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static String _initials(String? fullName, String phoneNumber) {
    if (fullName != null && fullName.trim().isNotEmpty) {
      final parts = fullName.trim().split(RegExp(r'\s+'));
      if (parts.length >= 2) {
        return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
      }
      return fullName.length >= 2 ? fullName.substring(0, 2).toUpperCase() : fullName.toUpperCase();
    }
    if (phoneNumber.length >= 2) {
      return phoneNumber.substring(phoneNumber.length - 2);
    }
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state.user;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text('Profil', style: AppTextStyles.heading2),
            centerTitle: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            foregroundColor: AppColors.textPrimary,
          ),
          body: user == null
              ? Center(
                  child: Text(
                    'Non connecté',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      // Avatar (80px), name, role badge, phone
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.surfaceLight,
                        child: user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty
                            ? ClipOval(
                                child: Image.network(
                                  user.profileImageUrl!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Text(
                                    _initials(user.fullName, user.phoneNumber),
                                    style: AppTextStyles.heading2.copyWith(color: AppColors.primary),
                                  ),
                                ),
                              )
                            : Text(
                                _initials(user.fullName, user.phoneNumber),
                                style: AppTextStyles.heading2.copyWith(color: AppColors.primary),
                              ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.fullName ?? 'Utilisateur',
                        style: AppTextStyles.heading3,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
                        ),
                        child: Text(
                          user.role.toUpperCase(),
                          style: AppTextStyles.badge.copyWith(
                            color: AppColors.primary,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user.phoneNumber,
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 32),

                      // List sections: icon + label + chevron, surfaceContainer, borderGray divider
                      _ProfileTile(
                        icon: Icons.person_outline_rounded,
                        label: 'Modifier le profil',
                        onTap: () => context.push('/edit-profile'),
                      ),
                      const _Divider(),
                      _ProfileTile(
                        icon: Icons.location_on_outlined,
                        label: 'Mes adresses',
                        onTap: () => context.push('/addresses'),
                      ),
                      const _Divider(),
                      _ProfileTile(
                        icon: Icons.notifications_outlined,
                        label: 'Notifications',
                        onTap: () => context.push('/notifications'),
                      ),
                      const _Divider(),
                      _ProfileTile(
                        icon: Icons.settings_outlined,
                        label: 'Paramètres',
                        onTap: () => context.push('/settings'),
                      ),
                      const _Divider(),
                      _ProfileTile(
                        icon: Icons.help_outline_rounded,
                        label: 'Aide & Support',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Aide & Support — bientôt disponible'),
                              backgroundColor: AppColors.surfaceLight,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Logout — danger red
                      _ProfileTile(
                        icon: Icons.logout_rounded,
                        label: 'Se déconnecter',
                        labelColor: AppColors.danger,
                        iconColor: AppColors.danger,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => ConfirmDialog(
                              title: 'Déconnexion',
                              content: 'Voulez-vous vraiment vous déconnecter ?',
                              confirmText: 'Se déconnecter',
                              isDestructive: true,
                              onConfirm: () {
                                context.read<AuthBloc>().add(const AuthLogoutRequested());
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.labelColor,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? labelColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final lColor = labelColor ?? AppColors.textPrimary;
    final iColor = iconColor ?? AppColors.textSecondary;
    return Material(
      color: AppColors.surfaceContainer,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: iColor, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.label.copyWith(color: lColor),
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) => const SizedBox(height: 8);
}
