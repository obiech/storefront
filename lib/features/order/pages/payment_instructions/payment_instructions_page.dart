import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';

import '../../index.dart';

class PaymentInstructionsPage extends StatelessWidget {
  const PaymentInstructionsPage({
    Key? key,
    required this.paymentResults,
  }) : super(key: key);

  final PaymentResultsModel paymentResults;

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
                  PaymentInformationSection(order: paymentResults.order),
                  const ThickDivider(),
                  const PaymentHelpSection(),
                ],
              ),
              OrderActions(
                order: paymentResults.order,
                showPayButton: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
