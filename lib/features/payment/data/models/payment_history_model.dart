/// Payment history model for Gura Now application.
library;

import 'package:equatable/equatable.dart';

/// Payment history item model matching backend PaymentHistoryItem.
class PaymentHistoryItemModel extends Equatable {
  const PaymentHistoryItemModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.orderId,
    this.orderNumber,
    this.currency = 'BIF',
    this.paymentMethod,
    this.description,
  });

  factory PaymentHistoryItemModel.fromJson(Map<String, dynamic> json) =>
      PaymentHistoryItemModel(
        id: json['id'] as String,
        orderId: json['order_id'] as String?,
        orderNumber: json['order_number'] as String?,
        type: json['type'] as String,
        amount: _parseDouble(json['amount']) ?? 0.0,
        currency: json['currency'] as String? ?? 'BIF',
        paymentMethod: json['payment_method'] as String?,
        status: json['status'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        description: json['description'] as String?,
      );
  final String id;
  final String? orderId;
  final String? orderNumber;
  final String type;
  final double amount;
  final String currency;
  final String? paymentMethod;
  final String status;
  final DateTime createdAt;
  final String? description;

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_id': orderId,
        'order_number': orderNumber,
        'type': type,
        'amount': amount,
        'currency': currency,
        'payment_method': paymentMethod,
        'status': status,
        'created_at': createdAt.toIso8601String(),
        'description': description,
      };

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// Check if this is a payment transaction.
  bool get isPayment => type == 'order_payment' || type == 'payment';

  /// Check if this is a refund transaction.
  bool get isRefund => type == 'refund';

  /// Check if this is a commission transaction.
  bool get isCommission => type == 'commission';

  /// Check if the transaction was completed.
  bool get isCompleted => status == 'completed';

  /// Get formatted amount string.
  String get formattedAmount {
    final formatter = amount.toStringAsFixed(0);
    return '$formatter $currency';
  }

  @override
  List<Object?> get props => [id, type, amount, status, createdAt];
}

/// Paginated payment history response.
class PaymentHistory {
  const PaymentHistory({
    required this.items,
    required this.total,
    required this.page,
    required this.perPage,
    required this.pages,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) => PaymentHistory(
        items: (json['items'] as List<dynamic>)
            .map((e) =>
                PaymentHistoryItemModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        total: json['total'] as int,
        page: json['page'] as int,
        perPage: json['per_page'] as int,
        pages: json['pages'] as int,
      );
  final List<PaymentHistoryItemModel> items;
  final int total;
  final int page;
  final int perPage;
  final int pages;
}
