import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';

class MockPaymentMethodRepository extends Mock implements IPaymentRepository {}

class MockCartService extends Mock implements ICartRepository {}

class MockCartBloc extends MockBloc<CartEvent, CartState> implements CartBloc {}

class MockPaymentMethodCubit extends MockCubit<PaymentMethodState>
    implements PaymentMethodCubit {}

class MockPaymentCheckoutCubit extends MockCubit<PaymentCheckoutState>
    implements PaymentCheckoutCubit {}
