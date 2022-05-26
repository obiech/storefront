import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/cart_checkout/widgets/checkout/keys.dart';

class CartCheckoutPageFinders {
  static Finder buyButton = find.byKey(const ValueKey(CheckoutKeys.buy));

  static Finder buyElevatedButton =
      find.descendant(of: buyButton, matching: find.byType(ElevatedButton));
}
