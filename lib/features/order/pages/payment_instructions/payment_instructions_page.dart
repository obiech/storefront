import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

import '../../index.dart';

class PaymentInstructionsPage extends StatelessWidget {
  const PaymentInstructionsPage({
    Key? key,
    required this.order,
  }) : super(key: key);

  final OrderModel order;

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
                  PaymentInformationSection(order: order),
                  const ThickDivider(),
                  const PaymentHelpSection(),
                ],
              ),
              OrderActions(
                order: order,
                showPayButton: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
