import 'package:dropezy_proto/v1/order/order.pb.dart';
import 'package:storefront_app/core/core.dart';

import '../domains.dart';

/// Repo structure for payment methods repository
abstract class IPaymentRepository {
  /// Get list of all payment methods
  RepoResult<List<PaymentMethodDetails>> getPaymentMethods();

  /// Checkout Cart
  RepoResult<String> checkoutPayment(PaymentMethod method);
}
