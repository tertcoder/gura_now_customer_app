import 'package:equatable/equatable.dart';

class CheckoutData extends Equatable {
  // Path to image or base64? For now string.

  const CheckoutData({
    required this.deliveryMode,
    required this.paymentMethod,
    required this.shippingAddress,
    this.paymentProof,
  });
  final String deliveryMode; // 'delivery' or 'pickup'
  final String paymentMethod; // 'cash' or 'mobile_money'
  final String shippingAddress;
  final String? paymentProof;

  Map<String, dynamic> toJson() => {
        'delivery_mode': deliveryMode,
        'payment_method': paymentMethod,
        'shipping_address': shippingAddress,
        if (paymentProof != null) 'payment_proof': paymentProof,
      };

  @override
  List<Object?> get props =>
      [deliveryMode, paymentMethod, shippingAddress, paymentProof];
}
