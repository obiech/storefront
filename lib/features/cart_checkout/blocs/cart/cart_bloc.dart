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
@injectable
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(this.cartRepository) : super(const CartInitial()) {
    on<LoadCart>(_loadCart);
    on<AddCartItem>(_addCartItem);
    on<EditCartItem>(_editCartItem);
  }

  final ICartRepository cartRepository;

  FutureOr<void> _loadCart(
    LoadCart event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());

    final result = await cartRepository.loadCart();

    result.fold(
      (_) => emit(const CartFailedToLoad()),
      (cart) => emit(CartLoaded.success(cart)),
    );
  }

  /// Adds product [event.variant] into cart.
  ///
  /// Can only be used when [state] is [CartLoaded].
  FutureOr<void> _addCartItem(
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

  /// - Given [event.quantity] is zero, will remove the product from cart instead.
  ///
  /// - Given [event.quantity] is greater than current quantity, will increment
  /// [event.variant] quantity in cart by the difference in quantity.
  ///
  /// - Given [event.quantity] is less than current quantity, will decrement
  /// [event.variant] quantity in cart by the difference in quantity.
  ///
  /// Can only be used when [state] is [CartLoaded].
  FutureOr<void> _editCartItem(
    EditCartItem event,
    Emitter<CartState> emit,
  ) async {
    if (state is! CartLoaded) {
      // TODO: add better error handling
      debugPrint('Cannot edit item in cart when state is not CartLoaded');
      return;
    }

    final currState = state as CartLoaded;

    final index = currState.cart.items.indexWhere(
      (item) => item.variant.id == event.variant.id,
    );

    // Ensure item exists
    if (index == -1) {
      // TODO: add better error handling
      debugPrint('Cannot edit cart item because item does not exist!');
      return;
    }

    final tempList = List.of(currState.cart.items);
    final oldItem = tempList.removeAt(index);

    late Either<Failure, CartModel> result;

    // Remove product when quantity is zero
    if (event.quantity == 0) {
      debugPrint('Remove cart item is not yet implemented');
      return;
    } else {
      final qtyChange = event.quantity - oldItem.quantity;

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
    }

    final newState = result.fold(
      (failure) => CartLoaded.error(currState.cart, failure.message),
      (result) => CartLoaded.success(result),
    );

    emit(newState);
  }
}
