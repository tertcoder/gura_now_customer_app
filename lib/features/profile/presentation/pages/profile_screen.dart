import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state.user;
        return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Mon Profil'),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.black),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('Non connecté'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.lightGray,
                      border: Border.all(color: AppColors.black, width: 2),
                    ),
                    child: const Icon(Icons.person,
                        size: 50, color: AppColors.mediumGray),
                  ),
                  const SizedBox(height: 16),

                  // Name & Role
                  Text(
                    user.fullName ?? 'Utilisateur',
                    style: AppTextStyles.heading2,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      user.role.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Info Cards
                  _ProfileInfoTile(
                      icon: Icons.phone,
                      label: 'Téléphone',
                      value: user.phoneNumber),
                  const SizedBox(height: 16),
                  if (user.email != null) ...[
                    _ProfileInfoTile(
                        icon: Icons.email, label: 'Email', value: user.email!),
                    const SizedBox(height: 16),
                  ],

                  const SizedBox(height: 32),

                  // Actions
                  CustomButton(
                    text: 'MODIFIER PROFIL',
                    backgroundColor: AppColors.black,
                    onPressed: () {
                      // Navigate to edit profile (not implemented yet)
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'MES ADRESSES',
                    backgroundColor: AppColors.darkGray,
                    onPressed: () {
                      // Navigate to addresses
                    },
                  ),
                  const SizedBox(height: 48),

                  // Logout
                  TextButton.icon(
                    onPressed: () {
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
                    icon: const Icon(Icons.logout, color: AppColors.danger),
                    label: Text(
                      'Se déconnecter',
                      style: AppTextStyles.button
                          .copyWith(color: AppColors.danger),
                    ),
                  ),
                ],
              ),
            ),
        );
      },
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  const _ProfileInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.lightGray),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.darkGray),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.darkGray)),
                Text(value,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      );
}
