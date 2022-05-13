import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';

import '../../../../../test_commons/utils/payment_methods.dart';
import '../../mocks.dart';

void main() {
  late PaymentMethodCubit _cubit;
  late IPaymentRepository _repository;

  final List<PaymentMethodDetails> _paymentMethods =
      samplePaymentMethods.toPaymentDetails();

  setUp(() {
    _repository = MockPaymentMethodRepository();
    _cubit = PaymentMethodCubit(_repository);
  });

  test('should have [InitialPaymentMethodState] on start', () async {
    /// assert
    expect(_cubit.state, isA<InitialPaymentMethodState>());
  });

  blocTest<PaymentMethodCubit, PaymentMethodState>(
    'When payment method query is successful '
    'should emit a list of payment methods '
    'and select the first as the active payment method',
    setUp: () {
      /// arrange
      when(
        () => _repository.getPaymentMethods(),
      ).thenAnswer((_) async => right(_paymentMethods));
    },
    build: () => _cubit,
    act: (cubit) => cubit.queryPaymentMethods(),
    expect: () => [
      isA<LoadingPaymentMethods>(),
      LoadedPaymentMethods(_paymentMethods, _paymentMethods.first)
    ],
    verify: (_) => verify(() => _repository.getPaymentMethods()).called(1),
  );

  blocTest<PaymentMethodCubit, PaymentMethodState>(
    'When payment method query is unsuccessful '
    'should emit an error ',
    setUp: () {
      /// arrange
      when(
        () => _repository.getPaymentMethods(),
      ).thenAnswer((_) async => left(NetworkFailure()));
    },
    build: () => _cubit,
    act: (cubit) => cubit.queryPaymentMethods(),
    expect: () => [
      isA<LoadingPaymentMethods>(),
      isA<ErrorLoadingPaymentMethods>(),
    ],
    verify: (_) => verify(() => _repository.getPaymentMethods()).called(1),
  );

  blocTest<PaymentMethodCubit, PaymentMethodState>(
    'When a payment method is selected '
    'should emit [LoadedPaymentMethods] with selected payment method',
    setUp: () {
      /// arrange
      when(
        () => _repository.getPaymentMethods(),
      ).thenAnswer((_) async => right(_paymentMethods));
    },
    build: () => _cubit,
    act: (cubit) async {
      await cubit.queryPaymentMethods();
      cubit.setPaymentMethod(_paymentMethods[1]);
    },
    expect: () => [
      isA<LoadingPaymentMethods>(),
      LoadedPaymentMethods(_paymentMethods, _paymentMethods.first),
      LoadedPaymentMethods(_paymentMethods, _paymentMethods[1]),
    ],
    verify: (_) => verify(() => _repository.getPaymentMethods()).called(1),
  );
}
