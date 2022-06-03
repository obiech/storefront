import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/order/index.dart';

class PaymentInformationsSectionFinder {
  static Finder get finderIllustrationSVG =>
      find.byKey(const ValueKey(PaymentInformationSectionKeys.illustrationSVG));

  static Finder get finderFinishPaymentBeforeText => find.byKey(
        const ValueKey(PaymentInformationSectionKeys.finishPaymentBefore),
      );

  static Finder get finderExpiryTimeText =>
      find.byKey(const ValueKey(PaymentInformationSectionKeys.expiryTime));

  static Finder get finderCountdown =>
      find.byKey(const ValueKey(PaymentInformationSectionKeys.countdown));

  static Finder get finderProcessOrderAfterVerifyText => find.byKey(
        const ValueKey(PaymentInformationSectionKeys.processOrderAfterVerify),
      );

  static Finder get finderPaymentMethodTile => find
      .byKey(const ValueKey(PaymentInformationSectionKeys.paymentMethodTile));

  static Finder get finderVirtualAccountTile => find.byKey(
        const ValueKey(PaymentInformationSectionKeys.virtualAccountTile),
      );

  static Finder get finderTotalBillTile =>
      find.byKey(const ValueKey(PaymentInformationSectionKeys.totalBillTile));
}
