import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/discovery/index.dart';

import '../../../../../test_commons/fixtures/cart/cart_models.dart'
    as cart_fixtures;
import '../../../../src/mock_customer_service_client.dart';
import '../../mocks.dart';

void main() {
  const mockStoreId = 'store-id-1';
  late CartBloc bloc;
  late ICartRepository cartRepository;
  late IStoreRepository storeRepository;

  const mockCart = cart_fixtures.mockCartModel;

  void verifyFn(CartBloc bloc) =>
      verify(() => bloc.cartRepository.loadCart()).called(1);

  setUp(() {
    final storeStream = BehaviorSubject<String>();
    storeRepository = MockStoreRepository();
    when(() => storeRepository.storeStream).thenAnswer((_) => storeStream);

    when(() => storeRepository.activeStoreId)
        .thenAnswer((_) => storeStream.valueOrNull);

    cartRepository = MockCartService();

    bloc = CartBloc(cartRepository, storeRepository);

    when(() => cartRepository.loadCart()).thenAnswer((_) async {
      return right(mockCart);
    });
  });

  group('[store]', () {
    void expectEmptyStoreStream() {
      expect(storeRepository.storeStream.valueOrNull, null);
    }

    blocTest<CartBloc, CartState>(
      'should add [LoadCart] event when store is changed',
      setUp: expectEmptyStoreStream,
      build: () => bloc,
      act: (bloc) => [storeRepository.storeStream.add(mockStoreId)],
      expect: () => <CartState>[
        const CartLoading(),
        CartLoaded.success(mockCart),
      ],
      verify: verifyFn,
    );

    blocTest<CartBloc, CartState>(
      'should not add [LoadCart] event when store is not changed',
      setUp: expectEmptyStoreStream,
      build: () => bloc,
      act: (bloc) => [
        storeRepository.storeStream.add(mockStoreId),
        storeRepository.storeStream.add(mockStoreId)
      ],
      expect: () => <CartState>[
        const CartLoading(),
        CartLoaded.success(mockCart),
      ],
      verify: verifyFn,
    );
  });
}
