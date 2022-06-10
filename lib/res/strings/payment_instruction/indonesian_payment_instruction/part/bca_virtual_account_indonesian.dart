part of '../payment_instruction_indonesian.dart';

class BCAVirtualAccountIndonesian implements BCAVirtualAccount {
  @override
  PaymentSteps get atm => PaymentSteps(
        title: 'Melalui ATM',
        steps: [
          'Pilih Transaksi Lainnya pada menu utama.',
          'Pilih Transfer.',
          'Pilih BCA Virtual Account.',
          'Masukkan nomor BCA Virtual Account.',
          'Masukkan Jumlah Transfer sesuai dengan Total Tagihan.',
          'Konfirmasi pembayaran.',
          'Pembayaran selesai.'
        ],
      );

  @override
  PaymentSteps get klikBCA => PaymentSteps(
        title: 'Melalui BCA',
        steps: [
          'Pilih Transfer Dana.',
          'Pilih Transfer ke BCA Virtual Account.',
          'Masukkan nomor BCA Virtual Account.',
          'Masukkan Jumlah Transfer sesuai dengan Total Tagihan.',
          'Konfirmasi pembayaran.',
          'Pembayaran selesai.'
        ],
      );

  @override
  PaymentSteps get mBCA => PaymentSteps(
        title: 'Melalui m-BCA',
        steps: [
          'Pilih m-Transfer.',
          'Pilih BCA Virtual Account.',
          'Masukkan nomor BCA Virtual Account.',
          'Lihat detil tagihan dan masukkan pin m-BCA.',
          'Konfirmasi pembayaran.',
          'Pembayaran selesai.'
        ],
      );
}
