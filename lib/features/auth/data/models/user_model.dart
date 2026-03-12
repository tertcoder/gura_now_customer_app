import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.phoneNumber,
    required super.role,
    required super.createdAt,
    super.fullName,
    super.email,
    super.bio,
    super.profileImageUrl,
    super.isVerified = false,
    super.isActive = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        fullName: json['full_name'] as String?,
        phoneNumber: json['phone_number'] as String,
        email: json['email'] as String?,
        role: json['role'] as String,
        bio: json['bio'] as String?,
        profileImageUrl: json['profile_image_url'] as String?,
        isVerified: json['is_verified'] as bool? ?? false,
        isActive: json['is_active'] as bool? ?? true,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'phone_number': phoneNumber,
        'email': email,
        'role': role,
        'bio': bio,
        'profile_image_url': profileImageUrl,
        'is_verified': isVerified,
        'is_active': isActive,
        'created_at': createdAt.toIso8601String(),
      };

  User toEntity() => User(
        id: id,
        fullName: fullName,
        phoneNumber: phoneNumber,
        email: email,
        role: role,
        bio: bio,
        profileImageUrl: profileImageUrl,
        isVerified: isVerified,
        isActive: isActive,
        createdAt: createdAt,
      );

  UserModel copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? email,
    String? role,
    String? bio,
    String? profileImageUrl,
    bool? isVerified,
    bool? isActive,
    DateTime? createdAt,
  }) =>
      UserModel(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        email: email ?? this.email,
        role: role ?? this.role,
        bio: bio ?? this.bio,
        profileImageUrl: profileImageUrl ?? this.profileImageUrl,
        isVerified: isVerified ?? this.isVerified,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
      );
}
