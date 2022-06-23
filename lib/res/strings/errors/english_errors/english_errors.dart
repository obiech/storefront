import '../errors.dart';
import '../parts/cart_checkout.dart';

part 'parts/cart_checkout.dart';

class EnglishErrors implements AppErrors {
  @override
  CartCheckoutErrors get cartCheckout => EnglishCartCheckoutErrors();
}
