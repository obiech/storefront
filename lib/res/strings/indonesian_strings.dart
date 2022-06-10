import 'base_strings.dart';
import 'faq/faq.dart';
import 'faq/indonesian_faq/indonesian_faq.dart';

class IndonesianStrings implements BaseStrings {
  @override
  String shoppingForDailyNecessities() => 'Belanja kebutuhan harian';

  @override
  String enter() => 'Masuk';

  @override
  String skip() => 'Lewati';

  @override
  String account() => 'Akun';

  @override
  String letsRegisterUsingYourCellphoneNumber() =>
      'Yuk daftar pakai nomor HP kamu';

  @override
  String iHaveReferralCode() => 'Saya Punya Kode Referral';

  @override
  String optional() => 'Optional';

  @override
  String continueStr() => 'Lanjutkan';

  @override
  String youAgreeTermsAndPolicy(final String terms, final String policy) {
    return "Dengan daftar, maka kamu setuju dengan <a href='$terms'>Ketentuan Layanan</a> dan <a href='$policy'>Kebijakan Privasi</a> Dropezy.";
  }

  @override
  String referralCode() => 'Kode referral';

  @override
  String withTheReferralCodeYouWillGet() =>
      'Dengan kode referral, kamu akan mendapatkan';

  @override
  String points(int points) => '$points Points !';

  @override
  String looksLikeYoureAlreadyRegistered() => 'Sepertinya kamu sudah terdaftar';

  @override
  String mobileNumberHasBeenRegisteredWithDropezy(String number) =>
      'Nomor HP <b>$number</b> sudah terdaftar di Dropezy. Yuk, masuk aja!';

  @override
  String otpCode() => 'Kode OTP';

  @override
  String verifyYourPhone() => 'Verifikasi Ponsel Kamu';

  @override
  String otpCodeHasBeenSentTo(String number) =>
      'Kode OTP telah dikirimkan melalui ke nomor <b>$number</b>';

  @override
  String resending() => 'Kirim ulang';

  @override
  String theOTPCodeYouEnteredIsWrong() => 'Kode OTP yang kamu masukkan salah';

  @override
  String resendOTP() => 'Kirim Ulang OTP';

  @override
  String pin() => 'PIN';

  @override
  String createANewPINCodeToSecureYourAccount() =>
      'Buat kode PIN baru untuk mengamankan akunmu';

  @override
  String minutes(int minutes) => '$minutes Menit';

  @override
  String hiWhatAreYouShoppingForToday(String name) =>
      'Hai${name.isNotEmpty ? ' $name' : ''}, mau belanja apa hari ini?';

  /// Home page
  @override
  String get findYourNeeds => 'Cari kebutuhanmu';

  @override
  String get promptLoginOrRegister => 'Masuk atau daftar, yuk!';

  @override
  String dropezyPoint(int points) => 'Dropezy Point';

  @override
  String vouchersAvailable() => 'Voucher Tersedia';

  @override
  String viewAll() => 'Lihat Semua';

  @override
  String vegetables() => 'Sayuran';

  @override
  String fruit() => 'Buah';

  @override
  String breadEggsMilk() => 'Roti, telur, susu';

  @override
  String meatSeafoodFrozen() => 'Daging, Seafood, Frozen';

  @override
  String snack() => 'Makanan ringan';

  @override
  String kitchen() => 'Dapur & masak';

  @override
  String drink() => 'Minuman';

  @override
  String babiesEndMoms() => 'Bayi & Moms';

  @override
  String personalEquipment() => 'Perlengkapan Diri';

  @override
  String houseCleaning() => 'Kebersihan Rumah';

  @override
  String otherNeeds() => 'Kebutuhan Lainnya';

  @override
  String get home => 'Home';

  @override
  String get search => 'Cari';

  @override
  String get promo => 'Promo';

  @override
  String get profile => 'Profil';

  @override
  String safeYouGetPointsFromTheReferralCodeYouEnter(int points) =>
      '<b>Selamat! kamu dapat $points dari kode referral yang kamu masukkan</b>';

  @override
  String letSStartShoppingAndCollectMorePoints() =>
      'Yuk mulai belanja dan kumpulkan lebih banyak point';

  @override
  String ok() => 'Okay';

  @override
  String kemangHouse() => 'Rumah Kemang';

  @override
  String wellYourLocationHasnTBeenReachedByDropezyYetStayTuneWeWillDefinitelyBeThereSoon() =>
      'Yaah lokasimu belum terjangkau Dropezy nih. Stay tune ya, kita pasti akan segera kesana.';

  @override
  String checkLocation() => 'Cek Lokasi';

  @override
  String ivoryCoconut() => 'Kelapa Gading';

  @override
  String kelapaGadingBarat() => 'Kelapa Gading Barat';

  @override
  String kelapaGadingTimur() => 'Kelapa Gading Timur';

  @override
  String pegangsaan() => 'Pegangsaan';

  @override
  String rayaBoulevard() => 'Boulevard Raya';

  @override
  String jatinegara() => 'Jatinegara';

  @override
  String kemayoran() => 'Kemayoran';

  @override
  String kemang() => 'Kemang';

  @override
  String kuningan() => 'Kuningan';

  @override
  String locationDoesnTExistYetLetSRegister() =>
      'Lokasimu belum ada? Yuk daftarin!';

  @override
  String name() => 'Nama';

  @override
  String enterYourName() => 'Masukkan nama kamu';

  @override
  String email() => 'Email';

  @override
  String enterYourEmail() => 'Masukkan email kamu';

  @override
  String noMobilePhone() => 'No. HP';

  @override
  String enterMobileNumber() => 'Masukkan nomor handphone';

  @override
  String registeredLocation() => 'Lokasi Yang Didaftarkan';

  @override
  String theLocationYouWantToRegister() => 'Lokasi yang mau kamu daftarin';

  @override
  String send() => 'Kirim';

  @override
  String enterYourRegisteredMobileNumber() =>
      'Masukkan nomor HP kamu yang sudah terdaftar';

  @override
  String ex() => 'Ex';

  @override
  String looksLikeYouReStillNew() => 'Sepertinya kamu masih baru';

  @override
  String signUpNow() => 'Daftar Sekarang';

  @override
  String welcomeBackEnterYourPinCode() =>
      'Selamat datang kembali, masukkan kode PIN kamu';

  @override
  String forgotPinCode() => 'Lupa Kode Pin';

  @override
  String oopsWrongPinCode() => 'Ups, kode PINnya salah';

  @override
  String get onThisOrderYouHaveSuccessfully =>
      'Pada order kali ini kamu berhasil:';

  @override
  String get orderSuccessful => 'Order Berhasil!';

  @override
  String get pointsEarned => 'Point yang didapat';

  @override
  String get savedMoney => 'Hemat';

  @override
  String get viewOrderDetails => 'Lihat Detail Order';

  @override
  String get yourOrderWillArriveIn => 'Pesanan kamu akan tiba dalam';

  /// Commonly used phrases
  @override
  String get support => 'Bantuan';

  @override
  String copiedSuccessfully(String subject) => '$subject berhasil tersalin';

  /// Auth
  @override
  String get letsLoginOrRegister =>
      'Yuk, masuk atau daftar dulu biar belanjanya lebih nyaman';

  /// SignOut
  @override
  String get doYouWantToSignOut => 'Apakah kamu ingin keluar dari akunmu?';

  /// Onboarding Page
  @override
  String get register => 'Daftar';

  @override
  String get login => 'Masuk';

  @override
  String get shoppingForDailyNeeds => 'Belanja kebutuhan harian';

  @override
  String get superEzyWith => 'Super Ezy dengan';

  /// Order History Page
  @override
  String get myOrders => 'Pesananku';

  @override
  String get estimatedArrivalTime => 'Estimasi pesanan sampai';

  @override
  String get orderArrivedAt => 'Pesanan sampai pada';

  @override
  String get completePaymentWithin => 'Bayar sebelum';

  /// Order Details Page
  @override
  String get orderDetails => 'Detail Pesanan';

  @override
  String get yourPurchases => 'Belanjaanmu';

  @override
  String get estimation => 'Estimasi';

  @override
  String get orderStatus => 'Status Pesanan';

  @override
  String get orderTime => 'Waktu Pemesanan';

  @override
  String get captionOrderInProcess =>
      'Tunggu ya, pesananmu sedang diproses untuk pengiriman.';

  @override
  String get captionOrderInDelivery =>
      'Woosh, kurir kami sedang OTW ke rumah kamu';

  @override
  String get captionOrderHasArrived => 'Yay! Pesanan sudah sampai';

  @override
  String get deliveredBy => 'Diantar oleh';

  @override
  String get receivedBy => 'Diterima oleh';

  @override
  String get contact => 'Hubungi';

  @override
  String get deliveryLocation => 'Lokasi Pengantaran';

  // button labels
  @override
  String get continuePayment => 'Lanjut Pembayaran';

  @override
  String get orderAgain => 'Order Lagi';

  @override
  String get otherProducts => 'produk lainnya';

  @override
  String get totalSpent => 'Total Belanja';

  @override
  String get payNow => 'Bayar Sekarang';

  @override
  String get yesSignOut => 'Ya, Keluar';

  @override
  String get cancel => 'Batal';

  /// Order Status
  @override
  String get awaitingPayment => 'Menunggu Pembayaran';

  @override
  String get inProcess => 'Diproses';

  @override
  String get inDelivery => 'Dikirim';

  @override
  String get arrived => 'Sampai';

  @override
  String get arrivedAtDestination => 'Sampai Tujuan';

  @override
  String get cancelled => 'Dibatalkan';

  @override
  String get unspecified => 'Tidak Diketahui';

  @override
  String get failed => 'Gagal';

  @override
  String get orderFailed => 'Pesanan Gagal!';

  @override
  String get orderFailedMessage =>
      'Pesanan Anda tidak berhasil\n Periksa saldo Anda dan coba lagi.';

  @override
  String get retry => 'Coba lagi';

  /// Order Payment Summary
  @override
  String get deliveryFee => 'Biaya antar';

  @override
  String get discount => 'Diskon';

  @override
  String get dropezyPoints => 'Dropezy Points';

  @override
  String get free => 'Gratis';

  @override
  String get paymentDetails => 'Detail Pembayaran';

  @override
  String get paymentMethod => 'Metode Pembayaran';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get totalPayment => 'Total Pembayaran';

  @override
  String get voucher => 'Voucher';

  @override
  String get wowYouManagedToSave => 'Wow! Kamu berhasil hemat';

  /// Order Waiting Payment
  @override
  String get payment => 'Pembayaran';

  @override
  String get finishPaymentBefore => 'Selesaikan pembayaran sebelum';

  @override
  String get processOrderAfterVerify =>
      'Pesananmu akan diproses setelah pembayaran berhasil diverifikasi';

  @override
  String get virtualAccountNumber => 'Nomor Virtual Account';

  @override
  String get copy => 'Salin';

  @override
  String get totalBill => 'Total tagihan';

  @override
  String get details => 'Lihat Detail';

  @override
  String get virtualAccount => 'Virtual Account';

  /// Cart Page
  @override
  String get shoppingConfirmation => 'Konfirmasi Belanja';

  @override
  String get addProduct => 'Tambah produk';

  @override
  String get chooseAll => 'Choose all';

  @override
  String get pilihVoucherPromo => 'Pilih Voucher Promo';

  @override
  String get deliveryDetails => 'Detail Pengiriman';

  @override
  String get cart => 'Keranjang';

  @override
  String get useDropezyPoints => 'Pakai Dropezy Points';

  @override
  String get pack => 'pack';

  @override
  String get remainder => 'Sisa';

  @override
  String get addNote => 'Tambah catatan';

  @override
  String get outOfStockItems => 'Stok Barang Habis';

  @override
  String get delete => 'Hapus';

  @override
  String get clearAll => 'Hapus Semua';

  @override
  String get youPreviouslySearchedFor => 'Kamu Pernah Cari';

  @override
  String get addToCart => 'Tambahkan';

  @override
  String stockLeft(int stock) => 'Sisa $stock';

  @override
  String get searchForWhatYouNeed => 'Cari yang kamu butuhkan';

  @override
  String get thatIsAllTheStockWeHave =>
      'Hanya ini stock produk yang tersedia pada saat ini';

  @override
  String get outOfStock => 'Stok kosong';

  @override
  String get cantFindYourProduct => 'Oops, produknya tidak ditemukan';

  @override
  String get checkConnectionSettings =>
      'Tolong coba cek pengaturan koneksi internet kamu';

  @override
  String get lostInternetConnection => 'Koneksi internet hilang?';

  @override
  String get searchForAnotherProduct => 'Mohon coba cari produk yang lainnya';

  /// Location Access page
  @override
  String get locationAccess => 'Akses Lokasi';

  @override
  String get locationAccessRationale =>
      'Yuk aktifkan akses lokasi agar kami bisa mengirimkan belanjaanmu dengan mudah';

  @override
  String get activateNow => 'Aktifkan Sekarang';

  @override
  String get later => 'Nanti Saja';

  /// Search Location page
  @override
  String get whereIsYourAddress => 'Dimana Alamat Kamu?';

  /// Profile Page
  @override
  String hiUser(String username) => 'Hai, $username';

  @override
  String get aboutUs => 'Tentang Kami';

  @override
  String get changeAddress => 'Ubah Alamat';

  @override
  String get changePin => 'Ubah PIN';

  @override
  String get general => 'Umum';

  @override
  String get help => 'Bantuan';

  @override
  String get howItWorks => 'Cara Kerja';

  @override
  String get myVoucher => 'Voucherku';

  @override
  String get privacyPolicy => 'Kebijakan & Privasi';

  @override
  String get selectLanguage => 'Pilih Bahasa';

  @override
  String get termsOfUse => 'Ketentuan Layanan';

  @override
  String get signOut => 'Keluar';

  /// Address Selection Bottom sheet
  @override
  String get addAddress => 'Tambah Alamat';

  @override
  String get chooseAddress => 'Pilih Alamat';

  /// Address List
  @override
  String get addressPrimary => 'Utama';

  @override
  String get update => 'Ubah';

  @override
  String get addressEmpty => 'Anda belum menambahkan alamat';

  @override
  String updatedAddressSnackBarContent(String newAddress) =>
      'Alamat berhasil diubah ke $newAddress';

  /// Address Detail
  @override
  String get addressName => 'Nama Alamat';

  @override
  String get addressDetail => 'Detail Alamat';

  @override
  String get recipientName => 'Nama Penerima';

  @override
  String get phoneNumber => 'Nomor Handphone';

  @override
  String get usePrimaryAddress => 'Gunakan sebagai alamat utama';

  @override
  String get saveAddress => 'Simpan Alamat';

  @override
  String get addressNameHint => 'Ex. Rumah Saya';

  @override
  String get addressDetailHint => 'Nomor rumah, gang, RT/RW';

  @override
  String get recipientNameHint => 'Masukkan nama penerima';

  @override
  String get phoneNumberHint => 'Masukkan nomor yang bisa dihubungi';

  @override
  String get savedAddressSnackBarContent => 'Alamat Berhasil Disimpan';

  /// Edit Profile Page
  @override
  String get editProfile => 'Ubah Profil';

  @override
  String get saveProfile => 'Simpan';

  @override
  String get savedProfileSnackBarContent => 'Nama berhasil diperbarui';

  /// Error message
  @override
  String cannotBeEmpty(String field) => '$field tidak boleh kosong';

  @override
  String get viewCart => 'Lihat Keranjang';

  /// Help Page
  @override
  String get contactUs => 'Hubungi Kami';

  @override
  String get customerService => 'Pelayanan Pelanggan';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get productDetails => 'Detail Produk';

  @override
  String get variants => 'Varian';

  @override
  String get pay => 'Bayar';

  @override
  String get faq => 'FAQ';

  @override
  FAQ get faqs => FAQIndonesian();

  @override
  String maximumQty(int qty) => 'Jumlah maksimal: $qty';
}
