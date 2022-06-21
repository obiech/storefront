import 'package:dropezy_proto/v1/order/order.pb.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/order/index.dart';

import '../domains.dart';

/// Repo structure for payment methods repository
abstract class IPaymentRepository {
  /// Get list of all payment methods
  RepoResult<List<PaymentMethodDetails>> getPaymentMethods();

  /// Checkout Cart
  RepoResult<OrderModel> checkoutPayment(PaymentMethod method);
}
