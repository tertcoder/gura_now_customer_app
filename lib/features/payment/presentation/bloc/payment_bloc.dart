import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/payment_proof.dart';
import '../../domain/entities/shop_balance.dart';
import '../../domain/repositories/payment_repository.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc(this._repository) : super(const PaymentState()) {
    on<PaymentProofsLoadRequested>(_onProofsLoadRequested);
    on<PaymentProofLoadRequested>(_onProofLoadRequested);
    on<PaymentHistoryLoadRequested>(_onHistoryLoadRequested);
    on<ShopBalanceLoadRequested>(_onBalanceLoadRequested);
    on<PaymentProofSubmitRequested>(_onProofSubmitRequested);
    on<PaymentProofValidateRequested>(_onProofValidateRequested);
  }

  final PaymentRepository _repository;

  Future<void> _onProofsLoadRequested(
    PaymentProofsLoadRequested event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(proofsStatus: PaymentListStatus.loading, proofsError: null));
    final result = await _repository.getPaymentProofs(
      page: event.page,
      perPage: event.perPage,
      shopId: event.shopId,
      status: event.status,
    );
    result.fold(
      (f) => emit(state.copyWith(proofsStatus: PaymentListStatus.failure, proofsError: f.message)),
      (data) {
        final proofs = (data['items'] as List).cast<PaymentProof>();
        emit(state.copyWith(proofsStatus: PaymentListStatus.success, proofs: proofs));
      },
    );
  }

  Future<void> _onProofLoadRequested(
    PaymentProofLoadRequested event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(proofStatus: PaymentListStatus.loading, proofError: null));
    final result = await _repository.getPaymentProof(event.proofId);
    result.fold(
      (f) => emit(state.copyWith(proofStatus: PaymentListStatus.failure, proofError: f.message)),
      (proof) => emit(state.copyWith(proofStatus: PaymentListStatus.success, proof: proof)),
    );
  }

  Future<void> _onHistoryLoadRequested(
    PaymentHistoryLoadRequested event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(historyStatus: PaymentListStatus.loading, historyError: null));
    final result = await _repository.getPaymentHistory(page: event.page, perPage: event.perPage);
    result.fold(
      (f) => emit(state.copyWith(historyStatus: PaymentListStatus.failure, historyError: f.message)),
      (data) {
        // data['items'] is List<Map<String, dynamic>> from toJson()
        final items = (data['items'] as List<dynamic>)
            .map((e) => e as Map<String, dynamic>)
            .toList();
        emit(state.copyWith(historyStatus: PaymentListStatus.success, history: items));
      },
    );
  }

  Future<void> _onBalanceLoadRequested(
    ShopBalanceLoadRequested event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(balanceStatus: PaymentListStatus.loading, balanceError: null));
    final result = await _repository.getShopBalance(event.shopId);
    result.fold(
      (f) => emit(state.copyWith(balanceStatus: PaymentListStatus.failure, balanceError: f.message)),
      (balance) => emit(state.copyWith(balanceStatus: PaymentListStatus.success, balance: balance)),
    );
  }

  Future<void> _onProofSubmitRequested(
    PaymentProofSubmitRequested event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(actionStatus: PaymentActionStatus.loading, actionError: null));
    final result = await _repository.submitPaymentProof(
      orderId: event.orderId,
      paymentMethod: event.paymentMethod,
      imageUrls: event.imageUrls,
      referenceNumber: event.referenceNumber,
      notes: event.notes,
    );
    result.fold(
      (f) => emit(state.copyWith(actionStatus: PaymentActionStatus.failure, actionError: f.message)),
      (_) {
        emit(state.copyWith(actionStatus: PaymentActionStatus.success));
        add(const PaymentProofsLoadRequested());
      },
    );
  }

  Future<void> _onProofValidateRequested(
    PaymentProofValidateRequested event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(actionStatus: PaymentActionStatus.loading, actionError: null));
    final result = await _repository.validatePaymentProof(
      event.proofId,
      event.status,
      event.rejectionReason,
    );
    result.fold(
      (f) => emit(state.copyWith(actionStatus: PaymentActionStatus.failure, actionError: f.message)),
      (_) {
        emit(state.copyWith(actionStatus: PaymentActionStatus.success));
        add(const PaymentProofsLoadRequested());
      },
    );
  }
}
