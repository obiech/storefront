import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:storefront_app/core/errors/failure.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/discovery/index.dart';

import '../../../../../test_commons/fixtures/cart/cart_models.dart'
    as cart_fixtures;
import '../../../../../test_commons/fixtures/product/variant_models.dart'
    as variant_fixtures;
import '../../../../src/mock_customer_service_client.dart';
import '../../mocks.dart';

void main() {
  group(
    '[CartBloc]',
    () {
      late CartBloc bloc;
      late ICartRepository cartRepository;
      late IStoreRepository storeRepository;

      setUp(() {
        cartRepository = MockCartService();
        bloc = CartBloc(cartRepository, storeRepository);
        registerFallbackValue(variant_fixtures.variantMango);
      });

      setUpAll(() {
        storeRepository = MockStoreRepository();
        when(() => storeRepository.storeStream)
            .thenAnswer((_) => BehaviorSubject());
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
            'should emit an empty [CartLoaded.success] '
            'when a [ResourceNotFoundFailure] is returned from cart repository',
            setUp: () {
              when(() => cartRepository.loadCart()).thenAnswer((_) async {
                return left(ResourceNotFoundFailure());
              });
            },
            build: () => bloc,
            act: (bloc) => bloc.add(event),
            expect: () => <CartState>[
              const CartLoading(),
              CartLoaded.success(CartModel.empty()),
            ],
            verify: verifyFn,
          );

          blocTest<CartBloc, CartState>(
            'should emit [CartFailedToLoad] '
            'when a [Failure] is returned from cart repository',
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
                    () => bloc.cartRepository.addItem(any()),
                  ),
                );
              }
            },
          );

          // TODO(leovinsen): move this group out of [AddToCart] group
          group(
            'when [EditCartItem] event is added',
            () {
              const variantToEdit = variant_fixtures.variantMango;
              final initialCart = cart_fixtures.mockCartModel.copyWith(
                items: [
                  const CartItemModel(
                    variant: variantToEdit,
                    quantity: 2,
                  )
                ],
              );
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

              /// If new quantity zero,
              /// should remove product from cart
              group(
                'and quantity in event is zero',
                () {
                  const event = EditCartItem(variantToEdit, 0);
                  final resultCart = initialCart.copyWith.items([]);
                  final loadingState = CartLoaded.loading(resultCart);
                  void verifyFn(CartBloc bloc) {
                    verify(
                      () => bloc.cartRepository.removeItem(
                        event.variant,
                      ),
                    );
                  }

                  blocTest<CartBloc, CartState>(
                    'should emit a loading [CartLoaded] with item removed from cart '
                    'and call [CartRepository.removeItem()] '
                    'and finally emit resulting cart',
                    setUp: () {
                      when(
                        () => cartRepository.removeItem(
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
                      CartLoaded.success(resultCart)
                    ],
                    verify: verifyFn,
                  );

                  blocTest<CartBloc, CartState>(
                    'and cart repository returns a Failure '
                    'should emit a loading [CartLoaded] with cart removed '
                    'and call [CartRepository.removeItem()], '
                    'and finally emit [CartLoaded] with cart before event is added '
                    'and an error message from Failure',
                    setUp: () {
                      when(
                        () => cartRepository.removeItem(
                          event.variant,
                        ),
                      ).thenAnswer((_) async {
                        return left(
                          Failure('Failed to remove item'),
                        );
                      });
                    },
                    build: () => bloc,
                    seed: () => seedState,
                    act: (bloc) => bloc.add(event),
                    expect: () => <CartState>[
                      loadingState,
                      CartLoaded.error(initialCart, 'Failed to remove item')
                    ],
                    verify: verifyFn,
                  );
                },
              );
            },
          );
        },
      );

      group(
        'when [RemoveCartItem] event is added',
        () {
          const variantToRemove = variant_fixtures.variantMango;
          final initialCart = cart_fixtures.mockCartModel.copyWith(
            items: [
              const CartItemModel(
                variant: variantToRemove,
                quantity: 10,
              )
            ],
          );
          final resultCart = initialCart.copyWith.items([]);

          const event = RemoveCartItem(variantToRemove);
          final loadingState = CartLoaded.loading(resultCart);
          final seedState = CartLoaded.success(initialCart);

          void verifyFn(CartBloc bloc) {
            verify(
              () => bloc.cartRepository.removeItem(
                event.variant,
              ),
            );
          }

          blocTest<CartBloc, CartState>(
            'should emit a loading [CartLoaded] with item removed from cart '
            'and call [CartRepository.removeItem()] '
            'and finally emit resulting cart',
            setUp: () {
              when(
                () => cartRepository.removeItem(
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
            'and cart repository returns a Failure '
            'should emit a loading [CartLoaded] with cart removed '
            'and call [CartRepository.removeItem()], '
            'and finally emit [CartLoaded] with cart before event is added '
            'and an error message from Failure',
            setUp: () {
              when(
                () => cartRepository.removeItem(
                  event.variant,
                ),
              ).thenAnswer((_) async {
                return left(
                  Failure('Failed to remove item'),
                );
              });
            },
            build: () => bloc,
            seed: () => seedState,
            act: (bloc) => bloc.add(event),
            expect: () => <CartState>[
              loadingState,
              CartLoaded.error(initialCart, 'Failed to remove item'),
            ],
            verify: verifyFn,
          );
        },
      );
    },
  );
}
