import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../res/strings/faq/faq.dart';

part 'parts/customer_service_tile.dart';
part 'parts/whatsapp_button.dart';
part 'parts/faq_wrapper.dart';
part 'parts/section.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    final faq = context.res.strings.faqs;
    return DropezyScaffold.textTitle(
      bodyAlignment: Alignment.topCenter,
      title: context.res.strings.help,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _CustomerServiceTile(),
            const ThickDivider(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: res.dimens.pagePadding,
                vertical: res.dimens.pagePadding,
              ),
              child: Text(
                res.strings.faq,
                style: res.styles.subtitle,
              ),
            ),
            _Section(text: context.res.strings.faqs.aboutDropezy.section),
            _FAQWrapper(faq.aboutDropezy.howDoIContactDropezy),
            _FAQWrapper(faq.aboutDropezy.whenAreDropezyOpeningHours),
            _Section(text: context.res.strings.faqs.expenditure.section),
            _FAQWrapper(faq.expenditure.isThereAMinimumOrder),
            _FAQWrapper(faq.expenditure.whenCanWeReceiveTheItems),
            _FAQWrapper(faq.expenditure.howMuchIsTheShippingCost),
            _FAQWrapper(faq.expenditure.whatAreTheMethodsOfPaymentOfDropezy),
            _FAQWrapper(faq.expenditure.doDropezyAcceptCashOnDeliveryPayments),
            _FAQWrapper(faq.expenditure.canTheOrderBeChangedAfterPayments),
            _Section(text: res.strings.faqs.paymentRefund.section),
            _FAQWrapper(faq.paymentRefund.refundPeriod),
            _FAQWrapper(
              faq.paymentRefund.whatAreTheCriteriaThatMustBeMetToCancelOrder,
            ),
            _FAQWrapper(
              faq.paymentRefund.howTheMethodOfRefundingProcess,
            ),
            _FAQWrapper(faq.paymentRefund.whatIsTheProcessOfRefundWalletEzy),
            _FAQWrapper(faq.paymentRefund.whatIsTheBankTransferProcess),
            _FAQWrapper(faq.paymentRefund.whatIsTheRefundProcessOfGopay),
            _Section(text: faq.promo.section),
            _FAQWrapper(faq.promo.whereCanISeeThePromotionsOfDropezy),
            _FAQWrapper(faq.promo.whyIsTheRefundPriceNotAppropriate)
          ],
        ),
      ),
    );
  }
}
