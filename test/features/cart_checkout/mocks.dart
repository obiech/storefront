import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/cart_checkout/domain/domains.dart';

class MockPaymentMethodRepository extends Mock implements IPaymentRepository {}

class MockCartService extends Mock implements ICartRepository {}
