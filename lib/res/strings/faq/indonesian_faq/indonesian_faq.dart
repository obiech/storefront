import '../faq.dart';

part 'parts/about_dropezy_indonesian.dart';
part 'parts/expenditure_indonesian.dart';
part 'parts/payment_refund_indonesian.dart';
part 'parts/promo_indonesian.dart';

class FAQIndonesian implements FAQ {
  @override
  AboutDropezy get aboutDropezy => _AboutDropezyIndonesian();

  @override
  Expenditure get expenditure => _ExpenditureIndonesian();

  @override
  PaymentRefund get paymentRefund => _PaymentRefundIndonesian();

  @override
  Promo get promo => _PromoIndonesian();
}
