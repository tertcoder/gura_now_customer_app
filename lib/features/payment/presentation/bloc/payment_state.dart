part of 'payment_bloc.dart';

enum PaymentListStatus { initial, loading, success, failure }
enum PaymentActionStatus { initial, loading, success, failure }

class PaymentState extends Equatable {
  const PaymentState({
    this.proofsStatus = PaymentListStatus.initial,
    this.proofs = const [],
    this.proofsError,
    this.proofStatus = PaymentListStatus.initial,
    this.proof,
    this.proofError,
    this.historyStatus = PaymentListStatus.initial,
    this.history = const [],
    this.historyError,
    this.balanceStatus = PaymentListStatus.initial,
    this.balance,
    this.balanceError,
    this.actionStatus = PaymentActionStatus.initial,
    this.actionError,
  });

  final PaymentListStatus proofsStatus;
  final List<PaymentProof> proofs;
  final String? proofsError;
  final PaymentListStatus proofStatus;
  final PaymentProof? proof;
  final String? proofError;
  final PaymentListStatus historyStatus;
  final List<dynamic> history; // PaymentHistoryItemModel or domain entity
  final String? historyError;
  final PaymentListStatus balanceStatus;
  final ShopBalance? balance;
  final String? balanceError;
  final PaymentActionStatus actionStatus;
  final String? actionError;

  @override
  List<Object?> get props => [
        proofsStatus,
        proofs,
        proofsError,
        proofStatus,
        proof,
        proofError,
        historyStatus,
        history,
        historyError,
        balanceStatus,
        balance,
        balanceError,
        actionStatus,
        actionError,
      ];

  PaymentState copyWith({
    PaymentListStatus? proofsStatus,
    List<PaymentProof>? proofs,
    String? proofsError,
    PaymentListStatus? proofStatus,
    PaymentProof? proof,
    String? proofError,
    PaymentListStatus? historyStatus,
    List<dynamic>? history,
    String? historyError,
    PaymentListStatus? balanceStatus,
    ShopBalance? balance,
    String? balanceError,
    PaymentActionStatus? actionStatus,
    String? actionError,
  }) {
    return PaymentState(
      proofsStatus: proofsStatus ?? this.proofsStatus,
      proofs: proofs ?? this.proofs,
      proofsError: proofsError,
      proofStatus: proofStatus ?? this.proofStatus,
      proof: proof ?? this.proof,
      proofError: proofError,
      historyStatus: historyStatus ?? this.historyStatus,
      history: history ?? this.history,
      historyError: historyError,
      balanceStatus: balanceStatus ?? this.balanceStatus,
      balance: balance ?? this.balance,
      balanceError: balanceError,
      actionStatus: actionStatus ?? this.actionStatus,
      actionError: actionError,
    );
  }
}
