import '../domains.dart';

/// Repo structure for payment methods repository
abstract class IPaymentRepository {
  /// Get list of all payment methods
  Future<List<PaymentMethod>> getPaymentMethods();

  /// Checkout Cart
  Future<String> checkoutPayment(PaymentMethod method);
}
