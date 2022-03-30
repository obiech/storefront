import 'dart:convert';

import 'package:storefront_app/features/cart_checkout/domain/domains.dart';

import '../fixtures/fixture_reader.dart';

/// Loads sample payment methods for tests
///
/// From fixtures
List<PaymentMethod> get samplePaymentMethods =>
    (jsonDecode(fixture('checkout/payment_methods.json')) as List<dynamic>)
        .map(
          (json) => PaymentMethod.fromJson(json as Map<String, dynamic>),
        )
        .toList();
