import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// Screen for editing user profile in dark mode.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _bioController;
  XFile? _selectedImage;
  bool _isSaving = false;
  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _bioController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_controllersInitialized) {
      _controllersInitialized = true;
      final user = context.read<AuthBloc>().state.user;
      _nameController.text = user?.fullName ?? '';
      _emailController.text = user?.email ?? '';
      _bioController.text = user?.bio ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 500,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      // TODO: Implement actual profile update API call
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil mis à jour'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state.user;
        return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Modifier le profil'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveProfile,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.accent,
                    ),
                  )
                : const Text(
                    'Enregistrer',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Image
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.accent,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.3),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 56,
                        backgroundColor: AppColors.surfaceContainer,
                        backgroundImage: _selectedImage != null
                            ? FileImage(File(_selectedImage!.path))
                            : (user?.profileImageUrl != null
                                    ? NetworkImage(user!.profileImageUrl!)
                                    : null)
                                as ImageProvider?,
                        child: _selectedImage == null &&
                                user?.profileImageUrl == null
                            ? Icon(
                                Icons.person,
                                size: 56,
                                color: AppColors.textSecondary.withValues(alpha: 0.5),
                              )
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: AppColors.gradientAccent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accent.withValues(alpha: 0.4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: AppColors.textOnAccent,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Name Field
              AppTextField(
                controller: _nameController,
                label: 'Nom complet',
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le nom est requis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Email Field
              AppTextField(
                controller: _emailController,
                label: 'Email (optionnel)',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final emailRegex = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );
                    if (!emailRegex.hasMatch(value)) {
                      return 'Email invalide';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Bio Field
              AppTextField(
                controller: _bioController,
                label: 'Bio (optionnel)',
                hint: 'Parlez-nous de vous...',
                prefixIcon: Icons.info_outline,
                maxLines: 4,
                maxLength: 200,
              ),
              const SizedBox(height: 24),

              // Phone Number (Read-only)
              AppCard(
                backgroundColor: AppColors.surfaceContainer,
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.phone,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Numéro de téléphone',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.phoneNumber ?? '',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.lock,
                      color: AppColors.textSecondary,
                      size: 18,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Le numéro de téléphone ne peut pas être modifié',
                style: TextStyle(
                  color: AppColors.textDisabled,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 32),

              // Change Password
              AppButton(
                label: 'Changer le mot de passe',
                onPressed: () => context.push('/change-password'),
                icon: Icons.lock_outline,
                isOutlined: true,
              ),
            ],
          ),
        ),
      ),
    );
      },
    );
  }
}
