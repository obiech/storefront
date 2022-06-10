/// Represents steps of payment instruction
class PaymentSteps {
  final String title;
  final List<String> steps;

  PaymentSteps({
    required this.title,
    required this.steps,
  });
}

abstract class PaymentInstructions {
  BCAVirtualAccount get virtualAccount;
  // For another payment??
}

abstract class BCAVirtualAccount {
  PaymentSteps get atm;
  PaymentSteps get klikBCA;
  PaymentSteps get mBCA;
}
