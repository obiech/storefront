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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO (Jonathan) : Replace with payment information section
            Container(height: 500),
            const ThickDivider(),
            // TODO (Jonathan) : Replace container with help section
            Container(height: 300),
          ],
        ),
      ),
    );
  }
}
