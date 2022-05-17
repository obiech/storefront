import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/models/repo_result.dart';
import '../../../product/domain/domain.dart';
import '../domains.dart';

/// Dummy [ICartRepository] for development purposes.
///
/// Payment summary calculation is done locally and
/// all actions will always return success results.
@LazySingleton(as: ICartRepository)
class DummyCartService implements ICartRepository {
  late CartModel _cart;

  @override
  RepoResult<CartModel> loadCart() async {
    await Future.delayed(const Duration(seconds: 1));

    _cart = const CartModel(
      id: 'cart-id-1',
      storeId: 'store-id-1',
      items: [],
      paymentSummary: CartPaymentSummaryModel(
        discount: '000',
        deliveryFee: '1500000',
        subTotal: '000',
        total: '000',
      ),
    );

    return right(_cart);
  }

  @override
  RepoResult<CartModel> addItem(String storeId, VariantModel variant) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _cart = _cart.copyWith(
      items: List.of(_cart.items)
        ..add(
          CartItemModel(variant: variant, quantity: 1),
        ),
    );
    _calculatePaymentSummary();

    return right(_cart);
  }

  void _calculatePaymentSummary() {
    final newTotal = _cart.items.fold<int>(
      0,
      (prev, item) =>
          prev + item.quantity * (int.tryParse(item.variant.price) ?? 0),
    );

    _cart = _cart.copyWith(
      paymentSummary: CartPaymentSummaryModel(
        discount: '000',
        deliveryFee: '1500000',
        subTotal: newTotal.toString(),
        total: newTotal.toString(),
      ),
    );
  }
}
