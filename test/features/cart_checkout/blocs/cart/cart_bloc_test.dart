import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/errors/failure.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';

import '../../../../../test_commons/fixtures/cart/cart_models.dart'
    as cart_fixtures;
import '../../../../../test_commons/fixtures/product/product_models.dart'
    as product_fixtures;
import '../../mocks.dart';

void main() {
  group(
    '[CartBloc]',
    () {
      late CartBloc bloc;
      late ICartRepository cartRepository;

      setUp(() {
        cartRepository = MockCartService();
        bloc = CartBloc(cartRepository);
        registerFallbackValue(product_fixtures.productBellPepperYellow);
      });

      test(
        'initial state is [CartInitial]',
        () => expect(bloc.state, isA<CartInitial>()),
      );

      group(
        'when [LoadCart] event is added',
        () {
          const mockCart = cart_fixtures.mockCartModel;
          const event = LoadCart();
          void verifyFn(CartBloc bloc) =>
              verify(() => bloc.cartRepository.loadCart()).called(1);

          blocTest<CartBloc, CartState>(
            'should emit [CartLoaded] with Cart contents, loading set '
            'to false, and no error message',
            setUp: () {
              when(() => cartRepository.loadCart()).thenAnswer((_) async {
                return right(mockCart);
              });
            },
            build: () => bloc,
            act: (bloc) => bloc.add(event),
            expect: () => <CartState>[
              const CartLoading(),
              CartLoaded.success(mockCart),
            ],
            verify: verifyFn,
          );

          blocTest<CartBloc, CartState>(
            'on failure should emit [CartFailedToLoad]',
            setUp: () {
              when(() => cartRepository.loadCart()).thenAnswer((_) async {
                return left(Failure('Failed to load cart'));
              });
            },
            build: () => bloc,
            act: (bloc) => bloc.add(event),
            expect: () => const <CartState>[
              CartLoading(),
              CartFailedToLoad(),
            ],
            verify: verifyFn,
          );
        },
      );

      group(
        'when [AddToCart] event is added',
        () {
          final initialCart = cart_fixtures.mockCartModel.copyWith(items: []);
          const mockProduct = product_fixtures.productSeladaRomaine;

          final resultCart = initialCart.copyWith(
            items: [
              const CartItemModel(
                product: mockProduct,
                quantity: 1,
              ),
            ],
          );

          const event = AddCartItem(mockProduct);

          final seedState = CartLoaded(
            cart: initialCart,
            isCalculatingSummary: false,
            errorMessage: null,
          );

          // Loading state will be previous state's cart items
          // plus event's product
          final loadingState = CartLoaded.loading(resultCart);

          void verifyFn(CartBloc bloc) => verify(
                () => bloc.cartRepository.addItem(
                  initialCart.storeId,
                  event.product,
                ),
              ).called(1);

          blocTest<CartBloc, CartState>(
            'should add a cart item with quantity of 1, '
            'emit a loading [CartLoaded], '
            'call [CartRepository.addItem], then finally emit resulting cart.',
            setUp: () {
              when(
                () => cartRepository.addItem(
                  any(),
                  event.product,
                ),
              ).thenAnswer((_) async {
                return right(resultCart);
              });
            },
            build: () => bloc,
            seed: () => seedState,
            act: (bloc) => bloc.add(event),
            expect: () => <CartState>[
              loadingState,
              CartLoaded.success(resultCart),
            ],
            verify: verifyFn,
          );

          blocTest<CartBloc, CartState>(
            'on failure has the same flow as success case, but '
            'instead emits [CartLoaded] with an [errorMessage] and '
            'cart contents before [AddToCart] is added',
            setUp: () {
              when(
                () => cartRepository.addItem(
                  any(),
                  event.product,
                ),
              ).thenAnswer((_) async {
                return left(Failure('Failed to add item'));
              });
            },
            build: () => bloc,
            seed: () => seedState,
            act: (bloc) => bloc.add(event),
            expect: () => <CartState>[
              loadingState,
              CartLoaded(
                cart: initialCart,
                isCalculatingSummary: false,
                errorMessage: 'Failed to add item',
              )
            ],
            verify: verifyFn,
          );

          group(
            'nothing should happen if current state is not [CartLoaded], for example',
            () {
              const List<CartState> states = [
                CartInitial(),
                CartFailedToLoad(),
                CartLoading(),
              ];

              for (final CartState testedState in states) {
                blocTest<CartBloc, CartState>(
                  '[${testedState.runtimeType.toString()}]',
                  build: () => bloc,
                  seed: () => testedState,
                  act: (bloc) => bloc.add(event),
                  expect: () => <CartState>[],
                  verify: (bloc) => verifyNever(
                    () => bloc.cartRepository.addItem(any(), any()),
                  ),
                );
              }
            },
          );
        },
      );
    },
  );
}
