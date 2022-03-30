import 'package:storefront_app/features/cart_checkout/domain/models/payment_method.dart';

/// Repo structure for payment methods repository
abstract class IPaymentMethodRepository {
  /// Get list of all payment methods
  Future<List<PaymentMethod>> getPaymentMethods();
}
