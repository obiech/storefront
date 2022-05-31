part of '../indonesian_faq.dart';

class _PromoIndonesian implements Promo {
  @override
  String get section => 'Promo/Voucher';

  @override
  QuestionAndAnswer get whereCanISeeThePromotionsOfDropezy => QuestionAndAnswer(
        'Dimana saya bisa lihat promo dari Dropezy?',
        'Promo yang sedang berlangsung di Dropezy, dapat kakak lakukan'
            ' pengecekan secara berkala melalui banner di aplikasi Dropezy'
            ' maupun media sosial (Instagram) kami ya kak :)       ',
      );

  @override
  QuestionAndAnswer get whyIsTheRefundPriceNotAppropriate => QuestionAndAnswer(
        'Kenapa harga refund tidak sesuai (partial)? ',
        'Jumlah refund tidak 100% karena adanya penggunaan voucher/kupon',
      );
}
