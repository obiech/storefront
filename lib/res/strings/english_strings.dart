import 'base_strings.dart';
import 'faq/english_faq/english_faq.dart';
import 'faq/faq.dart';

class EnglishStrings implements BaseStrings {
  @override
  String shoppingForDailyNecessities() => 'Shopping for daily necessities';

  @override
  String enter() => 'Enter';

  @override
  String skip() => 'Skip';

  @override
  String account() => 'Account';

  @override
  String letsRegisterUsingYourCellphoneNumber() =>
      "Let's register using your cellphone number";

  @override
  String iHaveReferralCode() => 'I Have Referral Code';

  @override
  String optional() => 'Optional';

  @override
  String continueStr() => 'Continue';

  @override
  String youAgreeTermsAndPolicy(final String terms, final String policy) {
    return "By registering, you agree to <a href='$terms'>Dropezy's Terms of Service</a> and <a href='$policy'>Privacy Policy</a>.";
  }

  @override
  String referralCode() => 'Referral code';

  @override
  String withTheReferralCodeYouWillGet() =>
      'With the referral code, you will get';

  @override
  String points(int points) => '$points Points !';

  @override
  String looksLikeYoureAlreadyRegistered() =>
      "Looks like you're already registered";

  @override
  String mobileNumberHasBeenRegisteredWithDropezy(String number) =>
      'Mobile number <b>$number</b> has been registered with Dropezy. Come on, come on in!';

  @override
  String otpCode() => 'OTP Code';

  @override
  String verifyYourPhone() => 'Verify Your Phone';

  @override
  String otpCodeHasBeenSentTo(String number) =>
      'OTP code has been sent to <b>$number</b>';

  @override
  String resending() => 'resending';

  @override
  String theOTPCodeYouEnteredIsWrong() => 'The OTP code you entered is wrong';

  @override
  String resendOTP() => 'Resend OTP';

  @override
  String pin() => 'PIN';

  @override
  String createANewPINCodeToSecureYourAccount() =>
      'Create a new PIN code to secure your account';

  @override
  String minutes(int minutes) => '$minutes minutes';

  @override
  String hiWhatAreYouShoppingForToday(String name) =>
      'Hi${name.isNotEmpty ? ' $name' : ''}, what are you shopping for today?';

  /// Home Page
  @override
  String get findYourNeeds => "I'm looking for...";

  @override
  String get promptLoginOrRegister => 'Login or Register';

  @override
  String dropezyPoint(int points) => 'Dropezy Point';

  @override
  String vouchersAvailable() => 'Vouchers Available';

  @override
  String viewAll() => 'View All';

  @override
  String vegetables() => 'Vegetables';

  @override
  String fruit() => 'Fruit';

  @override
  String breadEggsMilk() => 'Bread, eggs, milk';

  @override
  String meatSeafoodFrozen() => 'Meat, Seafood, Frozen';

  @override
  String snack() => 'Snack';

  @override
  String kitchen() => 'Kitchen';

  @override
  String drink() => 'Drink';

  @override
  String babiesEndMoms() => 'Babies & Moms';

  @override
  String personalEquipment() => 'Personal Equipment';

  @override
  String houseCleaning() => 'House Cleaning';

  @override
  String otherNeeds() => 'Other Needs';

  @override
  String get home => 'Home';

  @override
  String get search => 'Search';

  @override
  String get promo => 'Promo';

  @override
  String get profile => 'Profile';

  @override
  String safeYouGetPointsFromTheReferralCodeYouEnter(int points) =>
      '<b>Safe! you get $points from the referral code you enter</b>';

  @override
  String letSStartShoppingAndCollectMorePoints() =>
      "Let's start shopping and collect more points";

  @override
  String ok() => 'ok';

  @override
  String kemangHouse() => 'Kemang house';

  @override
  String wellYourLocationHasnTBeenReachedByDropezyYetStayTuneWeWillDefinitelyBeThereSoon() =>
      "Well, your location hasn't been reached by Dropezy yet. Stay tune, we will definitely be there soon.";

  @override
  String checkLocation() => 'Check Location';

  @override
  String ivoryCoconut() => 'Ivory Coconut';

  @override
  String kelapaGadingBarat() => 'Kelapa Gading Barat';

  @override
  String kelapaGadingTimur() => 'Kelapa Gading Timur';

  @override
  String pegangsaan() => 'Pegangsaan';

  @override
  String rayaBoulevard() => 'Raya Boulevard';

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
      "Location doesn't exist yet? Let's register!";

  @override
  String name() => 'Name';

  @override
  String enterYourName() => 'Enter your name';

  @override
  String email() => 'E-mail';

  @override
  String enterYourEmail() => 'Enter your email';

  @override
  String noMobilePhone() => 'No. mobile phone';

  @override
  String enterMobileNumber() => 'Enter mobile number';

  @override
  String registeredLocation() => 'Registered Location';

  @override
  String theLocationYouWantToRegister() => 'The location you want to register';

  @override
  String send() => 'Send';

  @override
  String enterYourRegisteredMobileNumber() =>
      'Enter your registered mobile number';

  @override
  String ex() => 'Ex';

  @override
  String looksLikeYouReStillNew() => "Looks like you're still new";

  @override
  String signUpNow() => 'Sign up now';

  @override
  String welcomeBackEnterYourPinCode() => 'Welcome back, enter your PIN code';

  @override
  String forgotPinCode() => 'Forgot Pin Code';

  @override
  String oopsWrongPinCode() => 'Oops, wrong PIN code';

  @override
  String get onThisOrderYouHaveSuccessfully =>
      'In this order you have successfully:';

  @override
  String get orderSuccessful => 'Order Successful!';

  @override
  String get pointsEarned => 'Points earned';

  @override
  String get savedMoney => 'Saved';

  @override
  String get viewOrderDetails => 'View Order Details';

  @override
  String get yourOrderWillArriveIn => 'Your order will arrive in';

  /// Commonly used phrases
  @override
  String get support => 'Support';

  /// Auth
  @override
  String get letsLoginOrRegister =>
      "Let's login or register so your shopping is more convenient";

  /// Onboarding Page
  @override
  String get register => 'Register';

  @override
  String get login => 'Login';

  @override
  String get shoppingForDailyNeeds => 'Shopping for daily needs';

  @override
  String get superEzyWith => 'Super Ezy with';

  /// Order History Page
  @override
  String get myOrders => 'My Orders';

  @override
  String get estimatedArrivalTime => 'Estimated arrival time';

  @override
  String get orderArrivedAt => 'Order arrived at';

  @override
  String get completePaymentWithin => 'Pay within';

  @override
  String get continuePayment => 'Continue Payment';

  @override
  String get orderAgain => 'Order Again';

  @override
  String get otherProducts => 'other products';

  @override
  String get totalSpent => 'Total Spent';

  /// Order Details Page
  @override
  String get orderDetails => 'Order Details';

  @override
  String get yourPurchases => 'Your purchases';

  @override
  String get estimation => 'Estimation';

  @override
  String get orderStatus => 'Order Status';

  @override
  String get orderTime => 'Order Time';

  @override
  String get captionOrderInProcess =>
      'Please wait, your order is being prepared for delivery.';

  @override
  String get captionOrderInDelivery =>
      'Woosh, our driver is on the way to your home';

  @override
  String get captionOrderHasArrived => 'Yay! Your order has arrived';

  @override
  String get deliveredBy => 'Delivered by';

  @override
  String get receivedBy => 'Received by';

  @override
  String get contact => 'Contact';

  @override
  String get deliveryLocation => 'Delivery Location';

  /// Order Status
  @override
  String get arrived => 'Arrived';

  @override
  String get arrivedAtDestination => 'Arrived At Destination';

  @override
  String get awaitingPayment => 'Awaiting Payment';

  @override
  String get inProcess => 'In Process';

  @override
  String get inDelivery => 'In Delivery';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get unspecified => 'Unspecified';

  @override
  String get failed => 'Failed';

  @override
  String get orderFailed => 'Order Unsuccessful!';

  @override
  String get orderFailedMessage =>
      'Your order was not successful\n Check your balance and try again.';

  @override
  String get retry => 'Retry';

  /// Order Payment Summary
  @override
  String get deliveryFee => 'Delivery Fee';

  @override
  String get discount => 'Discount';

  @override
  String get dropezyPoints => 'Dropezy Points';

  @override
  String get free => 'Free';

  @override
  String get paymentDetails => 'Payment Details';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get totalPayment => 'Total Payment';

  @override
  String get voucher => 'Voucher';

  @override
  String get wowYouManagedToSave => 'Wow! You managed to save';

  /// Cart Page
  @override
  String get shoppingConfirmation => 'Shopping Confirmation';

  @override
  String get addProduct => 'Add product';

  @override
  String get chooseAll => 'Choose all';

  @override
  String get pilihVoucherPromo => 'Choose Promo Voucher';

  @override
  String get deliveryDetails => 'Delivery Details';

  @override
  String get cart => 'Cart';

  @override
  String get useDropezyPoints => 'Use Dropezy Points';

  @override
  String get pack => 'pack';

  @override
  String get remainder => 'Remainder';

  @override
  String get addNote => 'Add note';

  @override
  String get outOfStockItems => 'Out of Stock';

  @override
  String get delete => 'Delete';

  @override
  String get clearAll => 'Clear All';

  @override
  String get youPreviouslySearchedFor => 'Previous searches';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String stockLeft(int stock) => '$stock left';

  @override
  String get searchForWhatYouNeed => 'Search for your what you need';

  @override
  String get thatIsAllTheStockWeHave =>
      "That's all we have in stock at the moment";

  @override
  String get outOfStock => 'Out of Stock';

  @override
  String get cantFindYourProduct => 'Oops, we can’t find your product';

  @override
  String get checkConnectionSettings =>
      'Please check your internet connection settings';

  @override
  String get lostInternetConnection => 'Lost your internet connection?';

  @override
  String get searchForAnotherProduct =>
      'Kindly try searching for another product';

  /// Location Access page
  @override
  String get locationAccess => 'Location Access';

  @override
  String get locationAccessRationale =>
      "Let's activate location access so we can send your shopping easily";

  @override
  String get activateNow => 'Activate Now';

  @override
  String get later => 'Later';

  /// Search Location page
  @override
  String get whereIsYourAddress => 'Where is Your Address?';

  /// Profile Page
  @override
  String hiUser(String user) => 'Hi, $user';

  @override
  String get aboutUs => 'About Us';

  @override
  String get changeAddress => 'Change Address';

  @override
  String get changePin => 'Change PIN';

  @override
  String get general => 'General';

  @override
  String get help => 'Help';

  @override
  String get howItWorks => 'How It Works';

  @override
  String get myVoucher => 'My Voucher';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get signOut => 'Sign Out';

  /// Address Selection Bottom sheet
  @override
  String get addAddress => 'Add Address';

  @override
  String get chooseAddress => 'Choose Address';

  /// Address List
  @override
  String get addressPrimary => 'Primary';

  @override
  String get update => 'Update';

  @override
  String updatedAddressSnackBarContent(String newAddress) =>
      'Address successfully changed to $newAddress';

  /// Address Detail
  @override
  String get addressName => 'Address Name';

  @override
  String get addressDetail => 'Address Detail';

  @override
  String get recipientName => "Recipient's Name";

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get usePrimaryAddress => 'Use as primary address';

  @override
  String get saveAddress => 'Save Address';

  @override
  String get addressNameHint => 'Ex. My Home';

  @override
  String get addressDetailHint => 'House number and street name';

  @override
  String get recipientNameHint => "Enter recipient's name";

  @override
  String get phoneNumberHint => 'Enter phone number';

  @override
  String get savedAddressSnackBarContent => 'Address Successfully Updated';

  /// Error message
  @override
  String cannotBeEmpty(String field) => '$field can not be empty';

  @override
  String get viewCart => 'View Cart';

  /// Help Page
  @override
  String get contactUs => 'Contact Us';

  @override
  String get customerService => 'Customer Service';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get productDetails => 'Product Details';

  @override
  String get faq => 'FAQ';

  @override
  FAQ get faqs => FAQEnglish();
}
