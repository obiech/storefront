part of '../indonesian_faq.dart';

class _PaymentRefundIndonesian implements PaymentRefund {
  @override
  String get section => 'Payment Refund';

  @override
  QuestionAndAnswer get refundPeriod => QuestionAndAnswer(
        'Refund Period',
        'Proses dari refund melalui Wallet (Wallet Ezy, dan Gopay) akan'
            ' mengambil waktu 2x 24 jam pada hari kerja (Tidak termasuk'
            ' Sabtu,Minggu dan hari libur Nasional). Sedangkan untuk'
            ' proses refund melalui per-Bank-an akan mengambil waktu'
            ' 3x24 Jam pada Hari kerja  (tidak termasuk Sabtu, Minggu'
            ' dan hari libur Nasional). ',
      );

  @override
  QuestionAndAnswer get whatAreTheCriteriaThatMustBeMetToCancelOrder =>
      QuestionAndAnswer(
        'Apa saja kriteria yang harus dipenuhi untuk melakukan pembatalan'
            ' (pengembalian dana) order?',
        '''
Berikut adalah kriteria pembatalan :                                                                     
1. Produk yang kamu pesan tidak tersedia   
2. Jumlah produk yang dikirim tidak sesuai pesanan   
3. Produk yang kamu terima rusak, cacat dan tidak layak dikonsumsi atau'''
            '''
 digunakan.        
4. Penempatan pin point tidak sesuai''',
      );

  @override
  QuestionAndAnswer get howTheMethodOfRefundingProcess => QuestionAndAnswer(
        'Bagaimana metode proses pengembalian dana ',
        '''
Cara pengembalian dana: 
Untuk mengajukan pengembalian dana, kamu dapat mengirimkan foto dan video ke'''
            '''
 WhatsApp kami: 081717173327 setelah pesanan kamu terima
Kemudian, untuk refund partial (refund beberapa produk) dan refund karena'''
            '''
 ter-indikasi penyalahgunaan voucher akan otomatis dikembalikan ke Wallet'''
            '''
 Ezy masing-masing customer.
Lalu, untuk refund karena kesalahan pribadi yaitu salah pin point (titik'''
            '''
 alamat tidak sesuai), kamu hanya bisa mengajukan refund di Wallet Ezy.

Dropezy akan melakukan refund atau cancel pesanan jika pihak Dropezy'''
            ''' mendeteksi adanya penyalahgunaan voucher/kupon.''',
      );

  @override
  QuestionAndAnswer get whatIsTheProcessOfRefundWalletEzy => QuestionAndAnswer(
        'Bagaimana proses refund Wallet Ezy?',
        'Proses refund melalui Wallet Ezy hanya akan diproses'
            ' kembali ke nomer Wallet'
            ' Ezy yang sudah terdaftar pada akun Dropezy, refund'
            ' melalui Wallet Ezy'
            ' dengan estimasi waktu 2 hari kerja (tidak terhitung'
            ' Sabtu, Minggu dan'
            ' hari libur Nasional).',
      );

  @override
  QuestionAndAnswer get whatIsTheBankTransferProcess => QuestionAndAnswer(
        'Bagaimana proses refund Transfer Bank ?',
        '''
"Proses refund melalui Bank, silakan menginformasikan beberapa data berikut : 
1. Nama pemilik rekening 
2. Nomor rekening 
3. Bank 

Sebagai informasi untuk refund ke rekening bank akan membutuhkan waktu'''
            '''
 3 hari kerja (tidak terhitung Sabtu, Minggu dan hari libur Nasional)."
''',
      );

  @override
  QuestionAndAnswer get whatIsTheRefundProcessOfGopay => QuestionAndAnswer(
        'Bagaimana proses refund Gopay?',
        'Proses refund Gopay otomatis akan kami refundkan dengan menyertakan'
            ' ID pembayaran customer pada aplikasi,'
            ' sehingga customer tidak perlu'
            ' menginfokan kembali nomor akun Gopay-nya tersebut. Refund melalui'
            ' Gopay dengan estimasi waktu 2 hari kerja (tidak terhitung Sabtu,'
            ' Minggu dan hari libur Nasional). ',
      );
}
