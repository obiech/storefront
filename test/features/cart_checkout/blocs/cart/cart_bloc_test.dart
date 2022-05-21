import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/errors/failure.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';

import '../../../../../test_commons/fixtures/cart/cart_models.dart'
    as cart_fixtures;
import '../../../../../test_commons/fixtures/product/variant_models.dart'
    as variant_fixtures;
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
        registerFallbackValue(variant_fixtures.variantMango);
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
              verify(() => bloc.cartRepository.loadCart(CartBloc.dummyStoreId))
                  .called(1);

          blocTest<CartBloc, CartState>(
            'should emit [CartLoaded] with Cart contents, loading set '
            'to false, and no error message',
            setUp: () {
              when(() => cartRepository.loadCart(CartBloc.dummyStoreId))
                  .thenAnswer((_) async {
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
            'should emit [CartIsEmpty] '
            'when a [ResourceNotFoundFailure] is returned from cart repository',
            setUp: () {
              when(() => cartRepository.loadCart(CartBloc.dummyStoreId))
                  .thenAnswer((_) async {
                return left(ResourceNotFoundFailure());
              });
            },
            build: () => bloc,
            act: (bloc) => bloc.add(event),
            expect: () => const <CartState>[
              CartLoading(),
              CartIsEmpty(),
            ],
            verify: verifyFn,
          );

          blocTest<CartBloc, CartState>(
            'should emit [CartFailedToLoad] '
            'when a [Failure] is returned from cart repository',
            setUp: () {
              when(() => cartRepository.loadCart(CartBloc.dummyStoreId))
                  .thenAnswer((_) async {
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
          const mockVariant = variant_fixtures.variantMango;

          final resultCart = initialCart.copyWith(
            items: [
              const CartItemModel(
                variant: mockVariant,
                quantity: 1,
              ),
            ],
          );

          const event = AddCartItem(mockVariant);

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
                  event.variant,
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
                  event.variant,
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
                  event.variant,
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

          group(
            'when [EditCartItem] event is added',
            () {
              const variantToEdit = variant_fixtures.variantMango;
              final initialCart = cart_fixtures.mockCartModel.copyWith.items([
                const CartItemModel(
                  variant: variantToEdit,
                  quantity: 2,
                )
              ]);
              final seedState = CartLoaded(
                cart: initialCart,
                isCalculatingSummary: false,
                errorMessage: null,
              );

              /// If new quantity is greater than previous quantity,
              /// should increment product by difference in quantity
              group(
                'and quantity in event is greater than previous quantity',
                () {
                  const event = EditCartItem(variantToEdit, 10);
                  final resultCart = initialCart.copyWith.items([
                    CartItemModel(
                      variant: event.variant,
                      quantity: event.quantity,
                    ),
                  ]);
                  final loadingState = CartLoaded(
                    cart: resultCart,
                    isCalculatingSummary: true,
                    errorMessage: null,
                  );
                  void verifyFn(CartBloc bloc) {
                    verify(
                      () => bloc.cartRepository.incrementItem(
                        any(),
                        event.variant,
                        8,
                      ),
                    );
                  }

                  blocTest<CartBloc, CartState>(
                    'should emit a loading [CartLoaded] with increased item quantity '
                    'and call [CartRepository.incrementItem], '
                    'and finally emit resulting cart',
                    setUp: () {
                      when(
                        () => cartRepository.incrementItem(
                          any(),
                          event.variant,
                          8,
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
                      CartLoaded(
                        cart: resultCart,
                        isCalculatingSummary: false,
                        errorMessage: null,
                      )
                    ],
                    verify: verifyFn,
                  );

                  blocTest<CartBloc, CartState>(
                    'and on failure '
                    'should emit a loading [CartLoaded] with increased item quantity '
                    'and call [CartRepository.incrementItem], '
                    'and finally emit [CartLoaded] with cart before event is added '
                    'and an error message from Failure',
                    setUp: () {
                      when(
                        () => cartRepository.incrementItem(
                          any(),
                          event.variant,
                          8,
                        ),
                      ).thenAnswer((_) async {
                        return left(
                          Failure('Failed to increment item quantity'),
                        );
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
                        errorMessage: 'Failed to increment item quantity',
                      )
                    ],
                    verify: verifyFn,
                  );
                },
              );

              /// If new quantity is lesser than previous quantity,
              /// should decrement product by difference in quantity
              group(
                'and quantity in event is less than previous quantity',
                () {
                  const event = EditCartItem(variantToEdit, 1);
                  final resultCart = initialCart.copyWith.items([
                    CartItemModel(
                      variant: event.variant,
                      quantity: event.quantity,
                    ),
                  ]);
                  final loadingState = CartLoaded(
                    cart: resultCart,
                    isCalculatingSummary: true,
                    errorMessage: null,
                  );
                  void verifyFn(CartBloc bloc) {
                    verify(
                      () => bloc.cartRepository.decrementItem(
                        any(),
                        event.variant,
                        1,
                      ),
                    );
                  }

                  blocTest<CartBloc, CartState>(
                    'should emit a loading [CartLoaded] with decreased item quantity '
                    'and call [CartRepository.decrementItem] '
                    'and finally emit resulting cart',
                    setUp: () {
                      when(
                        () => cartRepository.decrementItem(
                          any(),
                          event.variant,
                          1,
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
                      CartLoaded(
                        cart: resultCart,
                        isCalculatingSummary: false,
                        errorMessage: null,
                      )
                    ],
                    verify: verifyFn,
                  );

                  blocTest<CartBloc, CartState>(
                    'and on failure '
                    'should emit a loading [CartLoaded] with decreased item quantity '
                    'and call [CartRepository.decrementItem], '
                    'and finally emit [CartLoaded] with cart before event is added '
                    'and an error message from Failure',
                    setUp: () {
                      when(
                        () => cartRepository.decrementItem(
                          any(),
                          event.variant,
                          1,
                        ),
                      ).thenAnswer((_) async {
                        return left(
                          Failure('Failed to decrement item quantity'),
                        );
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
                        errorMessage: 'Failed to decrement item quantity',
                      )
                    ],
                    verify: verifyFn,
                  );
                },
              );
            },
          );
        },
      );
    },
  );
}
