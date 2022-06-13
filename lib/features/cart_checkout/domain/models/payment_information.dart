import 'package:dropezy_proto/v1/order/order.pb.dart';
import 'package:equatable/equatable.dart';

class PaymentInformationModel extends Equatable {
  final String? deeplink;
  final String? vaNumber;
  final String? bankName;

  const PaymentInformationModel({this.deeplink, this.vaNumber, this.bankName});

  factory PaymentInformationModel.fromGoPay(GopayPaymentInfo paymentInfo) {
    return PaymentInformationModel(deeplink: paymentInfo.deeplink);
  }

  factory PaymentInformationModel.fromVa(VAPaymentInfo paymentInfo) {
    return PaymentInformationModel(
      bankName: paymentInfo.bankName,
      vaNumber: paymentInfo.vaNumber,
    );
  }

  @override
  List<Object?> get props => [deeplink, bankName, vaNumber];
}
