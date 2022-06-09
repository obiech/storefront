import 'faq/faq.dart';
import 'payment_instruction/payment_instructions.dart';

/// Interface for strings
abstract class BaseStrings {
  String shoppingForDailyNecessities();

  String enter();

  String skip();

  String account();

  String letsRegisterUsingYourCellphoneNumber();

  String iHaveReferralCode();

  String optional();

  String continueStr();

  String youAgreeTermsAndPolicy(final String terms, final String policy);

  String referralCode();

  String withTheReferralCodeYouWillGet();

  String points(int points);

  String looksLikeYoureAlreadyRegistered();

  String mobileNumberHasBeenRegisteredWithDropezy(String number);

  String otpCode();

  String verifyYourPhone();

  String otpCodeHasBeenSentTo(String number);

  String resending();

  String theOTPCodeYouEnteredIsWrong();

  String resendOTP();

  String pin();

  String createANewPINCodeToSecureYourAccount();

  String minutes(int minutes);

  String dropezyPoint(int points);

  String vouchersAvailable();

  String viewAll();

  String vegetables();

  String fruit();

  String breadEggsMilk();

  String meatSeafoodFrozen();

  String snack();

  String kitchen();

  String drink();

  String babiesEndMoms();

  String personalEquipment();

  String houseCleaning();

  String otherNeeds();

  String get home;

  String get search;

  String get promo;

  String get profile;

  String safeYouGetPointsFromTheReferralCodeYouEnter(int points);

  String letSStartShoppingAndCollectMorePoints();

  String ok();

  String kemangHouse();

  // TODO :: too long method name is absolutely not good idea :) @Jonathan can you please fix them
  String
      wellYourLocationHasnTBeenReachedByDropezyYetStayTuneWeWillDefinitelyBeThereSoon();

  String checkLocation();

  String ivoryCoconut();

  String kelapaGadingBarat();

  String kelapaGadingTimur();

  String pegangsaan();

  String rayaBoulevard();

  String jatinegara();

  String kemayoran();

  String kemang();

  String kuningan();

  String locationDoesnTExistYetLetSRegister();

  String name();

  String enterYourName();

  String email();

  String enterYourEmail();

  String noMobilePhone();

  String enterMobileNumber();

  String registeredLocation();

  String theLocationYouWantToRegister();

  String send();

  String enterYourRegisteredMobileNumber();

  String ex();

  String looksLikeYouReStillNew();

  String signUpNow();

  String welcomeBackEnterYourPinCode();

  String forgotPinCode();

  String oopsWrongPinCode();

  /// Commonly used phrases
  String get support;

  String copiedSuccessfully(String subject);

  /// Auth
  String get letsLoginOrRegister;

  /// SignOut
  String get doYouWantToSignOut;

  /// Onboarding Page
  String get shoppingForDailyNeeds;

  String get superEzyWith;

  String get register;

  String get login;

  /// Order Successful Page
  String get orderSuccessful;

  String get yourOrderWillArriveIn;

  String get onThisOrderYouHaveSuccessfully;

  String get savedMoney;

  String get pointsEarned;

  String get viewOrderDetails;

  /// Order failed
  String get orderFailed;

  String get orderFailedMessage;

  String get retry;

  /// Order History Page
  String get myOrders;

  String get completePaymentWithin;

  String get estimatedArrivalTime;

  String get orderArrivedAt;

  /// Order Details Page
  String get orderDetails;

  String get orderStatus;

  String get yourPurchases;

  String get estimation;

  String get captionOrderInProcess;

  String get captionOrderInDelivery;

  String get captionOrderHasArrived;

  String get orderTime;

  String get deliveredBy;

  String get receivedBy;

  String get contact;

  String get deliveryLocation;

  // button labels
  String get continuePayment;

  String get orderAgain;

  String get otherProducts;

  String get totalSpent;

  String get payNow;

  String get yesSignOut;

  String get cancel;

  /// Order Status
  String get awaitingPayment;

  String get inProcess;

  String get inDelivery;

  String get arrived;

  String get arrivedAtDestination;

  String get cancelled;

  String get unspecified;

  String get failed;

  /// Order Payment Summary
  String get wowYouManagedToSave;

  String get paymentDetails;

  String get paymentMethod;

  String get subtotal;

  String get deliveryFee;

  String get free;

  String get discount;

  String get voucher;

  String get dropezyPoints;

  String get totalPayment;

  /// Order Waiting Payment
  String get payment;

  String get finishPaymentBefore;

  String get processOrderAfterVerify;

  String get virtualAccountNumber;

  String get copy;

  String get totalBill;

  String get details;

  String get virtualAccount;

  String get howToPay;

  /// Cart Page
  String get shoppingConfirmation;

  String get addProduct;

  String get chooseAll;

  String get pilihVoucherPromo;

  String get deliveryDetails;

  String get cart;

  String get useDropezyPoints;

  String get pack;

  String get remainder;

  String get addNote;

  String get viewCart;

  String get outOfStockItems;

  String get delete;

  /// Home Page
  String hiWhatAreYouShoppingForToday(String name);

  String get promptLoginOrRegister;

  String get findYourNeeds;

  /// Search Page
  String get youPreviouslySearchedFor;

  String get clearAll;

  String get addToCart;

  String get searchForWhatYouNeed;

  String get cantFindYourProduct;

  String get searchForAnotherProduct;

  // Internet status
  String get lostInternetConnection;

  String get checkConnectionSettings;

  /// Products
  String stockLeft(int stock);

  String get thatIsAllTheStockWeHave;

  String get outOfStock;

  /// Location Access Page
  String get locationAccess;

  String get locationAccessRationale;

  String get activateNow;

  String get later;

  /// Search Location page
  String get whereIsYourAddress;

  /// Profile Page
  String hiUser(String name);

  String get changeAddress;

  String get changePin;

  String get myVoucher;

  String get selectLanguage;

  String get general;

  String get privacyPolicy;

  String get help;

  String get termsOfUse;

  String get howItWorks;

  String get aboutUs;

  String get signOut;

  /// Address Selection Bottom sheet
  String get addAddress;

  String get chooseAddress;

  /// Address List
  String get addressPrimary;

  String get update;

  String get addressEmpty;

  String updatedAddressSnackBarContent(String newAddress);

  /// Address Detail
  String get addressName;

  String get addressDetail;

  String get recipientName;

  String get phoneNumber;

  String get usePrimaryAddress;

  String get saveAddress;

  String get addressNameHint;

  String get addressDetailHint;

  String get recipientNameHint;

  String get phoneNumberHint;

  String get savedAddressSnackBarContent;

  /// Edit Profile Page
  String get editProfile;

  String get saveProfile;

  String get savedProfileSnackBarContent;

  /// Error message
  String cannotBeEmpty(String field);

  /// Help Page
  String get contactUs;

  String get customerService;

  String get whatsapp;

  /// Product Details Page
  String get productDetails;

  String get variants;

  String get pay;

  String maximumQty(int qty);

  String get choosePaymentMethod;

  String get loading;

  String get faq;

  FAQ get faqs;

  PaymentInstructions get paymentInstructions;

  /// confirm Location.
  String get isThisReallyYourLocation;

  String get locationConfirm;

  String get viewMap;
}
