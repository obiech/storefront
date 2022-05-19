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

  static const deliveryFee = 1500000;

  static const initialVariant = VariantModel(
    variantId: 'mango-id',
    sku: 'mango-sku',
    name: 'Sweet Mangoes',
    price: '3000000',
    stock: 3,
    discount: '1000000',
    defaultImageUrl: 'image-url',
    imagesUrls: ['image-url'],
    unit: '500g',
  );

  @override
  RepoResult<CartModel> loadCart() async {
    await Future.delayed(const Duration(seconds: 1));

    _cart = CartModel(
      id: 'cart-id-1',
      storeId: 'store-id-1',
      items: const [
        CartItemModel(
          variant: initialVariant,
          quantity: 1,
        )
      ],
      paymentSummary: CartPaymentSummaryModel(
        discount: '000',
        deliveryFee: deliveryFee.toString(),
        subTotal: '000',
        total: '000',
      ),
    );

    _calculatePaymentSummary();

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

  @override
  RepoResult<CartModel> incrementItem(
    String storeId,
    VariantModel variant,
    int quantity,
  ) async {
    // Simulate a short network loading
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _cart.indexOfProduct(variant.id);

    _cart = _cart.copyWith(
      items: List.of(_cart.items)
        ..replaceRange(
          index,
          index + 1,
          [
            CartItemModel(
              variant: variant,
              quantity: _cart.items[index].quantity + quantity,
            )
          ],
        ),
    );

    _calculatePaymentSummary();

    return right(_cart);
  }

  @override
  RepoResult<CartModel> decrementItem(
    String storeId,
    VariantModel variant,
    int quantity,
  ) async {
    // Simulate a short network loading
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _cart.indexOfProduct(variant.id);

    _cart = _cart.copyWith(
      items: List.of(_cart.items)
        ..replaceRange(
          index,
          index + 1,
          [
            CartItemModel(
              variant: variant,
              quantity: _cart.items[index].quantity - quantity,
            )
          ],
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

    final newDiscount = _cart.items.fold<int>(
      0,
      (prev, item) =>
          prev +
          item.quantity * (int.tryParse(item.variant.discount ?? '000') ?? 0),
    );

    _cart = _cart.copyWith(
      paymentSummary: CartPaymentSummaryModel(
        discount: newDiscount.toString(),
        deliveryFee: deliveryFee.toString(),
        subTotal: newTotal.toString(),
        total: (newTotal + deliveryFee - newDiscount).toString(),
      ),
    );
  }
}
