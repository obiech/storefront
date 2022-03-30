/// The payment category for [PaymentMethod]
enum PaymentMethodType {
  /// E-Wallet provider
  EWallet,

  /// Virtual Account provider
  VirtualAccount,

  /// Other Payment provider
  Other
}

/// [PaymentMethodType] extension
extension PaymentMethodTypeX on dynamic {
  /// Converts [String] from json to a [PaymentMethodType]
  PaymentMethodType toPaymentMethod() {
    return PaymentMethodType.values.firstWhere(
      (method) => method.name == this,
      orElse: () => PaymentMethodType.Other,
    );
  }
}
