import '../errors.dart';
import '../parts/cart_checkout.dart';

part 'parts/cart_checkout.dart';

class IndonesianErrors implements AppErrors {
  @override
  CartCheckoutErrors get cartCheckout => IndonesianCartCheckoutErrors();
}
