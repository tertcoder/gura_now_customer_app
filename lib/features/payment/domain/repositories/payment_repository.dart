import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/payment_proof.dart';
import '../entities/shop_balance.dart';

/// Abstract repository interface for payment operations
abstract class PaymentRepository {
  Future<Either<Failure, PaymentProof>> submitPaymentProof({
    required String orderId,
    required String paymentMethod,
    required List<String> imageUrls,
    String? referenceNumber,
    String? notes,
  });

  Future<Either<Failure, Map<String, dynamic>>> getPaymentProofs({
    int page = 1,
    int perPage = 20,
    String? shopId,
    String? status,
  });

  Future<Either<Failure, PaymentProof>> getPaymentProof(String proofId);

  Future<Either<Failure, PaymentProof>> validatePaymentProof(
    String proofId,
    String status,
    String? rejectionReason,
  );

  Future<Either<Failure, Map<String, dynamic>>> getPaymentHistory({
    int page = 1,
    int perPage = 20,
  });

  Future<Either<Failure, ShopBalance>> getShopBalance(String shopId);
}
