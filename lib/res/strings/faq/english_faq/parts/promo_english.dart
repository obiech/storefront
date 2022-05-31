part of '../english_faq.dart';

class _PromoEnglish implements Promo {
  @override
  String get section => 'Promo/Voucher';

  @override
  QuestionAndAnswer get whereCanISeeThePromotionsOfDropezy => QuestionAndAnswer(
        'Where can I see the promotions of Dropezy?',
        'You can do a regular check through banners in our Dropezy application'
            ' or our Instagram account to find promos that are ongoing'
            ' in Dropezy. ',
      );

  @override
  QuestionAndAnswer get whyIsTheRefundPriceNotAppropriate => QuestionAndAnswer(
        'Way is the refund price not appropriate (partial)?',
        'The refund amount is not 100% because of the usage of voucher/coupon',
      );
}
