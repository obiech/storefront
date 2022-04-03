/// Interface for strings
abstract class BaseStrings {
  String shoppingForDailyNecessities();
  String superEasyWithDropezy();
  String register();
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
  String locationAccess();
  String letSActivateLocationAccessSoWeCanSendYourShoppingEasily();
  String activateNow();
  String later();
  String minutes(int minutes);
  String hiWhatAreYouShoppingForToday();
  String findYourNeeds();
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
  String home();
  String search();
  String promo();
  String profile();
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

  /// Order Successful Page
  String get orderSuccessful;
  String get yourOrderWillArriveIn;
  String get onThisOrderYouHaveSuccessfully;
  String get savedMoney;
  String get pointsEarned;
  String get viewOrderDetails;

  /// Order History Page
  String get myOrders;
  String get otherProducts;
  String get totalSpent;

  /// Order Status
  String get awaitingPayment;
  String get inProcess;
  String get inDelivery;
  String get arrived;
  String get cancelled;
  String get unspecified;
}