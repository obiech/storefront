import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dropezy_proto/v1/order/order.pb.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/cart_checkout/blocs/blocs.dart';
import 'package:storefront_app/features/cart_checkout/domain/domains.dart';
import 'package:storefront_app/res/strings/english_strings.dart';

import '../../../../commons.dart';
import '../../mocks.dart';

void main() {
  group('[PaymentCheckoutCubit]', () {
    late PaymentCheckoutCubit _cubit;
    late IPaymentRepository _repository;
    final List<PaymentMethodDetails> _paymentMethods =
        samplePaymentMethods.toPaymentDetails();

    final paymentResults = mockGoPayPaymentResults;
    final baseStrings = EnglishStrings();

    setUp(() {
      _repository = MockPaymentMethodRepository();
      _cubit = PaymentCheckoutCubit(_repository, baseStrings);
    });

    test('should have [InitialPaymentCheckoutState] on start', () async {
      /// assert
      expect(_cubit.state is InitialPaymentCheckoutState, true);
    });

    blocTest<PaymentCheckoutCubit, PaymentCheckoutState>(
      'When repository checkout is successful '
      'should emit a checkout link',
      setUp: () {
        /// arrange
        when(
          () => _repository.checkoutPayment(
            _paymentMethods.first.method,
          ),
        ).thenAnswer(
          (_) async => right(
            paymentResults,
          ),
        );
      },
      build: () => _cubit,
      act: (cubit) => cubit.checkoutPayment(_paymentMethods.first),
      expect: () => [
        isA<LoadingPaymentCheckout>(),
        LoadedPaymentCheckout(
          paymentResults,
        )
      ],
    );

    blocTest<PaymentCheckoutCubit, PaymentCheckoutState>(
      'When repository checkout is unsuccessful '
      'should emit an error',
      setUp: () {
        /// arrange
        when(
          () => _repository.checkoutPayment(_paymentMethods.first.method),
        ).thenAnswer(
          (_) async => left(
            PaymentMethodNotSupported(
              baseStrings,
              PaymentMethod.PAYMENT_METHOD_UNSPECIFIED,
            ),
          ),
        );
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
