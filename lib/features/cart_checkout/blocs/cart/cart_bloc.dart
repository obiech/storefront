import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';

import '../../../product/domain/models/product_model.dart';

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

  /// Adds product [event.product] into cart.
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

    final index = currState.cart.indexOfProduct(event.product.productId);

    // Ensure item is not yet added
    if (index > -1) {
      // TODO: add better error handling
      debugPrint('Error: Item is already already added to cart.');
      return;
    }

    final newItem = CartItemModel(product: event.product, quantity: 1);

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
      event.product,
    );

    result.fold(
      (failure) => emit(CartLoaded.error(currState.cart, failure.message)),
      (cart) => emit(CartLoaded.success(cart)),
    );
  }
}
