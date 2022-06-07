import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../../product/domain/domain.dart';
import '../../domain/domains.dart';

part 'cart_event.dart';
part 'cart_state.dart';

/// BLoC responsible for orchestrating Cart state changes from
/// multiple places in the app, such as:
/// - Search Results page,
/// - Child Categories (C2) Page,
/// - and Cart Checkout Page.
///
/// When a [ResourceNotFoundFailure] is received,
/// it indicates that cart is still empty.
@injectable
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(this.cartRepository) : super(const CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddCartItem>(_onAddCartItem);
    on<EditCartItem>(_onEditCartItem);
    on<RemoveCartItem>(_onRemoveCartItem);
  }

  //TODO (leovinsen): Revisit how to obtain storeId on cold start
  // when store coverage bloc is available. Perhaps by having a
  // StreamSubscription on said bloc.
  /// In the meantime, when trying to run gRPC version of CartService,
  /// replace this with store ID from your local Mongo instance
  static const dummyStoreId = 'dummy-store-id';

  final ICartRepository cartRepository;

  FutureOr<void> _onLoadCart(
    LoadCart event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());

    final result = await cartRepository.loadCart(dummyStoreId);

    result.fold(
      (failure) => failure is ResourceNotFoundFailure
          ? emit(CartLoaded.success(CartModel.empty(dummyStoreId)))
          : emit(const CartFailedToLoad()),
      (cart) => emit(CartLoaded.success(cart)),
    );
  }

  /// Handler for [AddCartItem] that
  /// adds product [event.variant] into cart.
  ///
  /// Can only be used when [state] is [CartLoaded].
  FutureOr<void> _onAddCartItem(
    AddCartItem event,
    Emitter<CartState> emit,
  ) async {
    if (state is! CartLoaded) {
      // TODO: add better error handling
      debugPrint('Cannot add item to cart when state is not CartLoaded');
      return;
    }

    final currState = state as CartLoaded;

    final index = currState.cart.indexOfProduct(event.variant.id);

    // Ensure item is not yet added
    if (index > -1) {
      // TODO: add better error handling
      debugPrint('Error: Item is already already added to cart.');
      return;
    }

    final newItem = CartItemModel(variant: event.variant, quantity: 1);

    // Trigger loading to signal we're waiting for cart summary
    // while still maintaining current cart state
    final newItems = List.of(currState.cart.items)..add(newItem);
    emit(
      CartLoaded.loading(
        currState.cart.copyWith.items(newItems),
      ),
    );

    final result = await cartRepository.addItem(
      currState.cart.storeId,
      event.variant,
    );

    result.fold(
      (failure) => emit(CartLoaded.error(currState.cart, failure.message)),
      (cart) => emit(CartLoaded.success(cart)),
    );
  }

  /// Handler for [EditCartItem].
  ///
  /// - Given [event.quantity] is zero, will remove the product from cart instead.
  ///
  /// - Given [event.quantity] is greater than current quantity, will increment
  /// [event.variant] quantity in cart by the difference in quantity.
  ///
  /// - Given [event.quantity] is less than current quantity, will decrement
  /// [event.variant] quantity in cart by the difference in quantity.
  ///
  /// Can only be used when [state] is [CartLoaded].
  FutureOr<void> _onEditCartItem(
    EditCartItem event,
    Emitter<CartState> emit,
  ) async {
    if (state is! CartLoaded) {
      // TODO: add better error handling
      debugPrint('Cannot edit item in cart when state is not CartLoaded');
      return;
    }

    final currState = state as CartLoaded;

    final index = currState.cart.indexOfProduct(event.variant.id);

    // Ensure item exists
    if (index == -1) {
      // TODO: add better error handling
      debugPrint('Cannot edit cart item because item does not exist!');
      return;
    }

    // Remove product when quantity is zero
    if (event.quantity == 0) {
      await _removeCartItem(event.variant, emit);
      return;
    } else {
      final tempList = List.of(currState.cart.items);
      final oldItem = tempList.removeAt(index);

      final qtyChange = event.quantity - oldItem.quantity;

      late Either<Failure, CartModel> result;

      if (qtyChange == 0) {
        debugPrint('Skipping edit cart item because quantity is unchanged');
        return;
      }

      // Re-insert product with new quantity
      tempList.insert(
        index,
        CartItemModel(
          variant: event.variant,
          quantity: event.quantity,
        ),
      );

      emit(CartLoaded.loading(currState.cart.copyWith.items(tempList)));

      if (qtyChange > 0) {
        result = await cartRepository.incrementItem(
          currState.cart.storeId,
          event.variant,
          qtyChange,
        );
      } else {
        result = await cartRepository.decrementItem(
          currState.cart.storeId,
          event.variant,
          qtyChange.abs(),
        );
      }

      result.fold(
        (failure) => emit(CartLoaded.error(currState.cart, failure.message)),
        (result) => emit(CartLoaded.success(result)),
      );
    }
  }

  /// Handler for [RemoveCartItem] event.
  ///
  /// Calls [_removeCartItem] using event contents.
  ///
  /// Can only be used when [state] is [CartLoaded].
  FutureOr<void> _onRemoveCartItem(
    RemoveCartItem event,
    Emitter<CartState> emit,
  ) async {
    if (state is! CartLoaded) {
      debugPrint('Cannot remove item from cart when state is not CartLoaded');
      return;
    }

    await _removeCartItem(event.variant, emit);
  }

  /// Removes product [variant] from cart.
  Future<void> _removeCartItem(
    VariantModel variant,
    Emitter<CartState> emit,
  ) async {
    final currState = state as CartLoaded;

    final index = currState.cart.indexOfProduct(variant.id);

    if (index == -1) {
      debugPrint('Error: Cart item being removed does not exist');
      return;
    }

    // remove item from cart
    final newItems = List.of(currState.cart.items);
    final newCart = currState.cart.copyWith(items: newItems..removeAt(index));

    emit(CartLoaded.loading(newCart));

    final result = await cartRepository.removeItem(
      currState.cart.storeId,
      variant,
    );

    result.fold(
      (failure) => emit(CartLoaded.error(currState.cart, failure.message)),
      (cart) => emit(CartLoaded.success(cart)),
    );
  }
}
