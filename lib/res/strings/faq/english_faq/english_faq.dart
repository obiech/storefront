import 'package:storefront_app/res/strings/faq/faq.dart';

part 'parts/about_dropezy_english.dart';
part 'parts/expenditure_english.dart';
part 'parts/payment_refund_english.dart';
part 'parts/promo_english.dart';

class FAQEnglish implements FAQ {
  @override
  AboutDropezy get aboutDropezy => _AboutDropezyEnglish();

  @override
  Expenditure get expenditure => _ExpenditureEnglish();

  @override
  PaymentRefund get paymentRefund => _PaymentRefundEnglish();

  @override
  Promo get promo => _PromoEnglish();
}
