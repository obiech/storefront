/// Represents the question and respective answer of a [FAQ].
class QuestionAndAnswer {
  final String question;
  final String answer;

  QuestionAndAnswer(this.question, this.answer);
}

abstract class FAQ {
  AboutDropezy get aboutDropezy;
  Expenditure get expenditure;
  PaymentRefund get paymentRefund;
  Promo get promo;
}

abstract class AboutDropezy {
  String get section;
  QuestionAndAnswer get howDoIContactDropezy;
  QuestionAndAnswer get whenAreDropezyOpeningHours;
}

abstract class Expenditure {
  String get section;
  QuestionAndAnswer get isThereAMinimumOrder;
  QuestionAndAnswer get whenCanWeReceiveTheItems;
  QuestionAndAnswer get howMuchIsTheShippingCost;
  QuestionAndAnswer get whatAreTheMethodsOfPaymentOfDropezy;
  QuestionAndAnswer get doDropezyAcceptCashOnDeliveryPayments;
  QuestionAndAnswer get canTheOrderBeChangedAfterPayments;
  QuestionAndAnswer get canYouChangeTheAddressIfTheOrderIsRuning;
}

abstract class PaymentRefund {
  String get section;
  QuestionAndAnswer get refundPeriod;
  QuestionAndAnswer get whatAreTheCriteriaThatMustBeMetToCancelOrder;
  QuestionAndAnswer get howTheMethodOfRefundingProcess;
  QuestionAndAnswer get whatIsTheProcessOfRefundWalletEzy;
  QuestionAndAnswer get whatIsTheBankTransferProcess;
  QuestionAndAnswer get whatIsTheRefundProcessOfGopay;
}

abstract class Promo {
  String get section;
  QuestionAndAnswer get whereCanISeeThePromotionsOfDropezy;
  QuestionAndAnswer get whyIsTheRefundPriceNotAppropriate;
}
