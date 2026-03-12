import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    this.fullName,
    required this.phoneNumber,
    this.email,
    required this.role,
    this.bio,
    this.profileImageUrl,
    this.isVerified = false,
    this.isActive = true,
    required this.createdAt,
  });
  final String id;
  final String? fullName;
  final String phoneNumber;
  final String? email;
  final String role;
  final String? bio;
  final String? profileImageUrl;
  final bool isVerified;
  final bool isActive;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        id,
        fullName,
        phoneNumber,
        email,
        role,
        bio,
        profileImageUrl,
        isVerified,
        isActive,
        createdAt,
      ];
}
