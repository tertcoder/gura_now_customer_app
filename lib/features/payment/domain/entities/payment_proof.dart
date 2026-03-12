import 'package:equatable/equatable.dart';

/// Domain entity for payment proof - pure business object
class PaymentProof extends Equatable {
  const PaymentProof({
    required this.id,
    required this.orderId,
    this.orderNumber,
    required this.uploadedBy,
    this.uploaderName,
    required this.imageUrls,
    required this.status,
    this.validatedBy,
    this.validatorName,
    this.validatedAt,
    this.rejectionReason,
    required this.createdAt,
  });

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

  @override
  List<Object?> get props => [
        id,
        orderId,
        orderNumber,
        uploadedBy,
        status,
        createdAt,
      ];
}
