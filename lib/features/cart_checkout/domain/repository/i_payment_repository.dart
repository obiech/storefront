import 'package:dropezy_proto/v1/order/order.pb.dart';

/// Repo structure for payment methods repository
abstract class IPaymentRepository {
  /// Get list of all payment methods
  Future<List<PaymentChannel>> getPaymentMethods();

  /// Checkout Cart
  Future<String> checkoutPayment(PaymentMethod method);
}
