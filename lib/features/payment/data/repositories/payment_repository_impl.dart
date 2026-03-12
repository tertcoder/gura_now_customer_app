import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/payment_proof.dart';
import '../../domain/entities/shop_balance.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_datasource.dart';
import '../models/payment_proof_model.dart' as model;
import '../models/shop_balance_model.dart' as balance_model;

/// Implementation of PaymentRepository
class PaymentRepositoryImpl implements PaymentRepository {
  PaymentRepositoryImpl(this._remoteDataSource);

  final PaymentRemoteDataSource _remoteDataSource;

  PaymentProof _modelToEntity(model.PaymentProofModel model) {
    return PaymentProof(
      id: model.id,
      orderId: model.orderId,
      orderNumber: model.orderNumber,
      uploadedBy: model.uploadedBy,
      uploaderName: model.uploaderName,
      imageUrls: model.imageUrls,
      status: model.status,
      validatedBy: model.validatedBy,
      validatorName: model.validatorName,
      validatedAt: model.validatedAt,
      rejectionReason: model.rejectionReason,
      createdAt: model.createdAt,
    );
  }

  ShopBalance _balanceModelToEntity(balance_model.ShopBalanceModel model) {
    return ShopBalance(
      shopId: model.shopId,
      shopName: model.shopName,
      totalSales: model.totalSales,
      totalCommissions: model.totalCommissions,
      pendingOrdersValue: model.pendingOrdersValue,
      availableBalance: model.availableBalance,
      totalWithdrawn: model.totalWithdrawn,
    );
  }

  @override
  Future<Either<Failure, PaymentProof>> submitPaymentProof({
    required String orderId,
    required String paymentMethod,
    required List<String> imageUrls,
    String? referenceNumber,
    String? notes,
  }) async {
    try {
      // Convert image URLs to File objects for the data source
      final imageFiles = imageUrls
          .map((url) => File(url))
          .where((file) => file.existsSync())
          .toList();

      if (imageFiles.isEmpty) {
        return const Left(ValidationFailure('No valid image files provided'));
      }

      final model = await _remoteDataSource.submitPaymentProof(
        orderId: orderId,
        paymentMethod: paymentMethod,
        images: imageFiles,
        referenceNumber: referenceNumber,
        notes: notes,
      );
      return Right(_modelToEntity(model));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getPaymentProofs({
    int page = 1,
    int perPage = 20,
    String? shopId,
    String? status,
  }) async {
    try {
      final result = await _remoteDataSource.getPaymentProofs(
        page: page,
        perPage: perPage,
        shopId: shopId,
        status: status,
      );
      return Right({
        'items': (result.items as List)
            .map((m) => _modelToEntity(m))
            .toList(),
        'total': result.total,
        'page': result.page,
        'per_page': result.perPage,
        'pages': result.pages,
      });
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaymentProof>> getPaymentProof(String proofId) async {
    try {
      final model = await _remoteDataSource.getPaymentProof(proofId);
      return Right(_modelToEntity(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaymentProof>> validatePaymentProof(
    String proofId,
    String status,
    String? rejectionReason,
  ) async {
    try {
      final request = model.PaymentProofValidateRequest(
        status: status,
        rejectionReason: rejectionReason,
      );
      final model_result = await _remoteDataSource.validatePaymentProof(
        proofId,
        request,
      );
      return Right(_modelToEntity(model_result));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getPaymentHistory({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final result = await _remoteDataSource.getPaymentHistory(
        page: page,
        perPage: perPage,
      );
      // Convert PaymentHistory to Map
      return Right({
        'items': result.items.map((e) => e.toJson()).toList(),
        'total': result.total,
        'page': result.page,
        'per_page': result.perPage,
        'pages': result.pages,
      });
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ShopBalance>> getShopBalance(String shopId) async {
    try {
      final model = await _remoteDataSource.getShopBalance(shopId);
      return Right(_balanceModelToEntity(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
