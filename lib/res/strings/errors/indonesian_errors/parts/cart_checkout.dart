part of '../indonesian_errors.dart';

class IndonesianCartCheckoutErrors implements CartCheckoutErrors {
  @override
  String get noDeliveryAddressSelected =>
      'Tidak ada alamat pengiriman yang dipilih';

  @override
  String get noStoreNearby => 'Tidak ada Toko di sekitar';

  @override
  String get noPaymentMethods => 'Tidak ada metode pembayaran';

  @override
  String paymentMethodNotSupported(String method) => '$method tidak didukung';

  @override
  String get errorCheckingOut => 'Kesalahan saat keluar';
}
