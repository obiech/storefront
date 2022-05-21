import 'package:bloc_test/bloc_test.dart';
import 'package:dropezy_proto/v1/cart/cart.pbgrpc.dart' as cart_proto;
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';

class MockPaymentMethodRepository extends Mock implements IPaymentRepository {}

class MockCartService extends Mock implements ICartRepository {}

class MockCartServiceClient extends Mock
    implements cart_proto.CartServiceClient {}

class MockCartBloc extends MockBloc<CartEvent, CartState> implements CartBloc {}

class MockPaymentMethodCubit extends MockCubit<PaymentMethodState>
    implements PaymentMethodCubit {}

class MockPaymentCheckoutCubit extends MockCubit<PaymentCheckoutState>
    implements PaymentCheckoutCubit {}
