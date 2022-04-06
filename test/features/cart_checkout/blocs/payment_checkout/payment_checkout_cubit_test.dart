import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/cart_checkout/blocs/blocs.dart';
import 'package:storefront_app/features/cart_checkout/domain/domains.dart';

import '../../../../../test_commons/utils/payment_methods.dart';
import '../../mocks.dart';

void main() {
  group('[PaymentCheckoutCubit]', () {
    late PaymentCheckoutCubit _cubit;
    late IPaymentRepository _repository;
    final List<PaymentMethodDetails> _paymentMethods =
        samplePaymentMethods.toPaymentDetails();

    setUp(() {
      _repository = MockPaymentMethodRepository();
      _cubit = PaymentCheckoutCubit(_repository);
    });

    test('should have [InitialPaymentCheckoutState] on start', () async {
      /// assert
      expect(_cubit.state is InitialPaymentCheckoutState, true);
    });

    const link = 'gogek://app';

    blocTest<PaymentCheckoutCubit, PaymentCheckoutState>(
      'When repository checkout is successful '
      'should emit a checkout link',
      setUp: () {
        /// arrange
        when(
          () => _repository.checkoutPayment(
            _paymentMethods.first.method,
          ),
        ).thenAnswer((_) async => link);
      },
      build: () => _cubit,
      act: (cubit) => cubit.checkoutPayment(_paymentMethods.first),
      expect: () =>
          [isA<LoadingPaymentCheckout>(), const LoadedPaymentCheckout(link)],
    );

    blocTest<PaymentCheckoutCubit, PaymentCheckoutState>(
      'When repository checkout is unsuccessful '
      'should emit an error',
      setUp: () {
        /// arrange
        when(
          () => _repository.checkoutPayment(_paymentMethods.first.method),
        ).thenThrow(Exception('No such payment method'));
      },
      build: () => _cubit,
      act: (cubit) => cubit.checkoutPayment(_paymentMethods.first),
      expect: () => [
        isA<LoadingPaymentCheckout>(),
        isA<ErrorLoadingPaymentCheckout>(),
      ],
    );
  });
}
