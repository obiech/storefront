import 'package:flutter/material.dart';

import '../../../../../core/core.dart';
import 'keys.dart';

class PaymentHelpSection extends StatelessWidget {
  const PaymentHelpSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    final virtualAccount = res.strings.paymentInstructions.virtualAccount;

    return Padding(
      padding: EdgeInsets.all(res.dimens.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            res.strings.howToPay,
            style: res.styles.subtitle,
            key: PaymentHelpSectionKeys.howToPay,
          ),
          const SizedBox(height: 12),
          DropezyExpansionTile.numberedList(
            key: PaymentHelpSectionKeys.atm,
            title: virtualAccount.atm.title,
            contents: virtualAccount.atm.steps,
          ),
          DropezyExpansionTile.numberedList(
            key: PaymentHelpSectionKeys.klikBCA,
            title: virtualAccount.klikBCA.title,
            contents: virtualAccount.klikBCA.steps,
          ),
          DropezyExpansionTile.numberedList(
            key: PaymentHelpSectionKeys.mBCA,
            title: virtualAccount.mBCA.title,
            contents: virtualAccount.mBCA.steps,
          ),
        ],
      ),
    );
  }
}
