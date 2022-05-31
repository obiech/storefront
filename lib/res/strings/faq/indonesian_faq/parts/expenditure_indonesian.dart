part of '../indonesian_faq.dart';

class _ExpenditureIndonesian implements Expenditure {
  @override
  String get section => 'Pembelanjaan';

  @override
  QuestionAndAnswer get isThereAMinimumOrder => QuestionAndAnswer(
        'Apakah ada minimum order?',
        'Belanja di Dropezy tanpa minimum order.',
      );

  @override
  QuestionAndAnswer get whenCanWeReceiveTheItems => QuestionAndAnswer(
        'Kapan barang yang dipesan dapat kami terima?',
        'Durasi pengiriman kami setelah melakukan pembayaran, pesanan'
            ' akan diterima dalam waktu 15 menit.  ',
      );

  @override
  QuestionAndAnswer get howMuchIsTheShippingCost => QuestionAndAnswer(
        'Berapa ongkos kirim Dropezy',
        'Dropezy menyediakan gratis ongkir untuk'
            ' setiap pengiriman diseluruh store Dropezy.',
      );

  @override
  QuestionAndAnswer get whatAreTheMethodsOfPaymentOfDropezy =>
      QuestionAndAnswer(
        'Apa saja metode pembayaran Dropezy?',
        'Dropezy menyediakan berbagai macam bentuk pembayaran, kamu '
            'bisa melakukan pembayaran untuk pesananmu'
            ' dengan menggunakan Virtual Account dan Gopay',
      );

  @override
  QuestionAndAnswer get doDropezyAcceptCashOnDeliveryPayments =>
      QuestionAndAnswer(
        'Apakah Dropezy menerima pembayaran Cash on Delivery? ',
        'Saat ini, kami belum menerima pembayaran '
            'dengan metode Cash on Delivery (COD)',
      );

  @override
  QuestionAndAnswer get canTheOrderBeChangedAfterPayments => QuestionAndAnswer(
        'Apakah pesanan bisa diubah/dibatalkan setelah pembayaran? ',
        '''
Sementara pesanan yang sudah dibayar tidak bisa diubah atau dibatalkan.      
                                                                                       
Untuk bantuan layanan silakan hubungi Customer Service 081717173327''',
      );

  @override
  QuestionAndAnswer get canYouChangeTheAddressIfTheOrderIsRuning =>
      QuestionAndAnswer(
        'Bisakah mengubah alamat jika pesanan sudah berjalan?',
        '''
Jika pesanan sudah berjalan kamu tidak bisa mengubah alamat yang telah kamu
cantumkan. Oleh karena itu, pastikan  alamat  yang dicantumkan sudah sesuai.  

Untuk bantuan layanan silakan hubungi Customer Service 081717173327''',
      );
}
