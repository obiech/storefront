import 'package:dropezy_proto/v1/order/order.pb.dart';
import 'package:equatable/equatable.dart';

import '../../../order/index.dart';
import 'payment_information.dart';

class PaymentResultsModel extends Equatable {
  final OrderModel order;
  final PaymentInformationModel paymentInformation;
  final PaymentMethod paymentMethod;
  final DateTime expiryTime;

  const PaymentResultsModel({
    required this.order,
    required this.paymentInformation,
    required this.paymentMethod,
    required this.expiryTime,
  });

  factory PaymentResultsModel.fromCheckoutResponse(CheckoutResponse response) {
    final PaymentInformationModel paymentInformation;
    final PaymentMethod paymentMethod;

    switch (response.paymentInformation.whichFlow()) {
      case PaymentInformation_Flow.gopayPaymentInfo:
        paymentInformation = PaymentInformationModel.fromGoPay(
          response.paymentInformation.gopayPaymentInfo,
        );

        paymentMethod = PaymentMethod.PAYMENT_METHOD_GOPAY;
        break;
      case PaymentInformation_Flow.vaPaymentInfo:
        paymentInformation = PaymentInformationModel.fromVa(
          response.paymentInformation.vaPaymentInfo,
        );

        paymentMethod = PaymentMethod.PAYMENT_METHOD_VA_BCA;
        break;
      default:
        throw Exception('No payment info');
    }

    return PaymentResultsModel(
      order: OrderModel.fromPb(response.order),
      paymentInformation: paymentInformation,
      paymentMethod: paymentMethod,
      expiryTime: response.paymentInformation.paymentExpiryTime.toDateTime(),
    );
  }

  @override
  List<Object?> get props => [
        order,
        paymentInformation,
        paymentMethod,
        expiryTime,
      ];
}
