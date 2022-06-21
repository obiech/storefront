import 'package:dropezy_proto/v1/order/order.pb.dart' as pb;
import 'package:equatable/equatable.dart';

class PaymentInformationModel extends Equatable {
  final String? deeplink;
  final String? vaNumber;
  final String? bankName;

  const PaymentInformationModel({this.deeplink, this.vaNumber, this.bankName});

  factory PaymentInformationModel.fromGoPay(pb.GopayPaymentInfo paymentInfo) {
    return PaymentInformationModel(deeplink: paymentInfo.deeplink);
  }

  factory PaymentInformationModel.fromVa(pb.VAPaymentInfo paymentInfo) {
    return PaymentInformationModel(
      bankName: paymentInfo.bankName,
      vaNumber: paymentInfo.vaNumber,
    );
  }

  factory PaymentInformationModel.fromPaymentInfo(
    pb.PaymentInformation paymentInfo,
  ) {
    switch (paymentInfo.paymentMethod) {
      case pb.PaymentMethod.PAYMENT_METHOD_GOPAY:
        return PaymentInformationModel.fromGoPay(paymentInfo.gopayPaymentInfo);
      case pb.PaymentMethod.PAYMENT_METHOD_VA_BCA:
        return PaymentInformationModel.fromVa(paymentInfo.vaPaymentInfo);
      default:
        throw Exception('[UNSPECIFIED PAYMENT METHOD]');
    }
  }

  @override
  List<Object?> get props => [deeplink, bankName, vaNumber];
}
