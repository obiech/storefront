import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/order/widgets/payment_instructions/payment_helps/keys.dart';

class PaymentHelpsSectionFinder {
  static Finder get finderHowToPayText =>
      find.byKey(PaymentHelpSectionKeys.howToPay);
  static Finder get finderATM => find.byKey(PaymentHelpSectionKeys.atm);
  static Finder get finderKlikBCA => find.byKey(PaymentHelpSectionKeys.klikBCA);
  static Finder get finderMBCA => find.byKey(PaymentHelpSectionKeys.mBCA);
}
