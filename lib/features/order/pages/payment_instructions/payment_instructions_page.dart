import 'package:dropezy_proto/v1/order/order.pbenum.dart';
import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';

import '../../index.dart';

class PaymentInstructionsPage extends StatelessWidget {
  const PaymentInstructionsPage({
    Key? key,
    required this.order,
    this.paymentInformation,
    this.paymentMethod = PaymentMethod.PAYMENT_METHOD_VA_BCA,
  }) : super(key: key);

  final OrderModel order;

  // TODO(obella): Retire when payment info is availed as part of order
  final PaymentInformationModel? paymentInformation;
  final PaymentMethod paymentMethod;

  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      title: context.res.strings.payment,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PaymentInformationSection(
                    order: order,
                    paymentMethod: paymentMethod,
                    paymentInformation: paymentInformation,
                  ),
                  const ThickDivider(),
                  const PaymentHelpSection(),
                ],
              ),
              OrderActions(
                order: order,
                paymentInformation: paymentInformation,
                paymentMethod: paymentMethod,
                showPayButton: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
