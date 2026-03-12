part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();
  @override
  List<Object?> get props => [];
}

class PaymentProofsLoadRequested extends PaymentEvent {
  const PaymentProofsLoadRequested({this.page = 1, this.perPage = 20, this.shopId, this.status});
  final int page;
  final int perPage;
  final String? shopId;
  final String? status;
  @override
  List<Object?> get props => [page, perPage, shopId, status];
}

class PaymentProofLoadRequested extends PaymentEvent {
  const PaymentProofLoadRequested(this.proofId);
  final String proofId;
  @override
  List<Object?> get props => [proofId];
}

class PaymentHistoryLoadRequested extends PaymentEvent {
  const PaymentHistoryLoadRequested({this.page = 1, this.perPage = 20});
  final int page;
  final int perPage;
  @override
  List<Object?> get props => [page, perPage];
}

class ShopBalanceLoadRequested extends PaymentEvent {
  const ShopBalanceLoadRequested(this.shopId);
  final String shopId;
  @override
  List<Object?> get props => [shopId];
}

class PaymentProofSubmitRequested extends PaymentEvent {
  const PaymentProofSubmitRequested({
    required this.orderId,
    required this.paymentMethod,
    required this.imageUrls,
    this.referenceNumber,
    this.notes,
  });
  final String orderId;
  final String paymentMethod;
  final List<String> imageUrls;
  final String? referenceNumber;
  final String? notes;
  @override
  List<Object?> get props => [orderId, paymentMethod, imageUrls, referenceNumber, notes];
}

class PaymentProofValidateRequested extends PaymentEvent {
  const PaymentProofValidateRequested({
    required this.proofId,
    required this.status,
    this.rejectionReason,
  });
  final String proofId;
  final String status; // 'approved' | 'rejected'
  final String? rejectionReason;
  @override
  List<Object?> get props => [proofId, status, rejectionReason];
}
