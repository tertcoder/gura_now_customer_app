/// Payment proof model for Gura Now application.
library;

import 'package:equatable/equatable.dart';

/// Payment proof model matching backend PaymentProofResponse.
class PaymentProofModel extends Equatable {
  const PaymentProofModel({
    required this.id,
    required this.orderId,
    required this.uploadedBy,
    required this.imageUrls,
    required this.status,
    required this.createdAt,
    this.orderNumber,
    this.uploaderName,
    this.validatedBy,
    this.validatorName,
    this.validatedAt,
    this.rejectionReason,
  });

  factory PaymentProofModel.fromJson(Map<String, dynamic> json) =>
      PaymentProofModel(
        id: json['id'] as String,
        orderId: json['order_id'] as String,
        orderNumber: json['order_number'] as String?,
        uploadedBy: json['uploaded_by'] as String,
        uploaderName: json['uploader_name'] as String?,
        imageUrls: (json['image_urls'] as List<dynamic>)
            .map((e) => e as Map<String, dynamic>)
            .toList(),
        status: json['status'] as String,
        validatedBy: json['validated_by'] as String?,
        validatorName: json['validator_name'] as String?,
        validatedAt: _parseDateTime(json['validated_at']),
        rejectionReason: json['rejection_reason'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
      );
  final String id;
  final String orderId;
  final String? orderNumber;
  final String uploadedBy;
  final String? uploaderName;
  final List<Map<String, dynamic>> imageUrls;
  final String status;
  final String? validatedBy;
  final String? validatorName;
  final DateTime? validatedAt;
  final String? rejectionReason;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_id': orderId,
        'order_number': orderNumber,
        'uploaded_by': uploadedBy,
        'uploader_name': uploaderName,
        'image_urls': imageUrls,
        'status': status,
        'validated_by': validatedBy,
        'validator_name': validatorName,
        'validated_at': validatedAt?.toIso8601String(),
        'rejection_reason': rejectionReason,
        'created_at': createdAt.toIso8601String(),
      };

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  /// Check if the proof is pending validation.
  bool get isPending => status == 'pending';

  /// Check if the proof was approved.
  bool get isApproved => status == 'approved';

  /// Check if the proof was rejected.
  bool get isRejected => status == 'rejected';

  /// Get the first image URL or null.
  String? get firstImageUrl {
    if (imageUrls.isEmpty) return null;
    return imageUrls.first['url'] as String?;
  }

  @override
  List<Object?> get props => [id, orderId, status, createdAt];
}

/// Paginated payment proofs response.
class PaginatedPaymentProofs {
  const PaginatedPaymentProofs({
    required this.items,
    required this.total,
    required this.page,
    required this.perPage,
    required this.pages,
  });

  factory PaginatedPaymentProofs.fromJson(Map<String, dynamic> json) =>
      PaginatedPaymentProofs(
        items: (json['items'] as List<dynamic>)
            .map((e) => PaymentProofModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        total: json['total'] as int,
        page: json['page'] as int,
        perPage: json['per_page'] as int,
        pages: json['pages'] as int,
      );
  final List<PaymentProofModel> items;
  final int total;
  final int page;
  final int perPage;
  final int pages;
}

/// Request model for validating a payment proof.
class PaymentProofValidateRequest {
  const PaymentProofValidateRequest({
    required this.status,
    this.rejectionReason,
  });
  final String status; // 'approved' or 'rejected'
  final String? rejectionReason;

  Map<String, dynamic> toJson() => {
        'status': status,
        if (rejectionReason != null) 'rejection_reason': rejectionReason,
      };
}
