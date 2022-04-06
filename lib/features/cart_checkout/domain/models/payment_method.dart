import 'package:dropezy_proto/v1/order/order.pbenum.dart';
import 'package:equatable/equatable.dart';

/// Payment method
///
/// Models a single payment method for the checkout procedure
class PaymentMethodDetails extends Equatable {
  /// The title of the payment method
  /// to be displayed to the user
  final String title;

  /// The payment provider logo
  final String image;

  /// The payment method identifier from gRPC
  final PaymentMethod method;

  const PaymentMethodDetails({
    required this.title,
    required this.image,
    required this.method,
  });

  @override
  List<Object?> get props => [title, image];
}
