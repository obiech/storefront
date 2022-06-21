import 'package:dartz/dartz.dart';
import 'package:dropezy_proto/v1/cart/cart.pbgrpc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/di_environment.dart';
import 'package:storefront_app/features/discovery/index.dart';
import 'package:storefront_app/features/product/index.dart';

import '../domains.dart';

/// [ICartRepository] that communicates with storefront-backend
/// CartService with [CartServiceClient].
///
/// Currently cart session will be reset whenever Store is changed.
///
/// When user's cart contains no items, a [ResourceNotFoundFailure] will
/// be returned from any of the methods below.
@LazySingleton(as: ICartRepository, env: DiEnvironment.grpcEnvs)
class CartService extends ICartRepository {
  CartService(this._cartServiceClient, this._storeRepository);

  final CartServiceClient _cartServiceClient;
  final IStoreRepository _storeRepository;

  /// Fetches current active cart using [CartServiceClient.summary].
  ///
  /// Call this method after every successful operation (add, edit, delete)
  /// to get latest cart contents and payment summary.
  @override
  RepoResult<CartModel> loadCart() async {
    return safeCall(() async {
      final response = await _cartServiceClient.summary(
        SummaryRequest(
          storeId: _storeRepository.activeStoreId,
        ),
      );

      return right(CartModel.fromPb(response));
    });
  }

  /// First sends an add item request to storefront-backend.
  /// Then calls [loadCart] to receive latest cart session.
  @override
  RepoResult<CartModel> addItem(VariantModel variant) async {
    return safeCall(() async {
      final req = AddRequest(
        storeId: _storeRepository.activeStoreId,
        item: UpdateItem(
          variantId: variant.id,
          quantity: 1,
        ),
      );

      // Ignore value returned
      await _cartServiceClient.add(req);

      return loadCart();
    });
  }

  @override
  RepoResult<CartModel> incrementItem(
    VariantModel variant,
    int quantity,
  ) async {
    return _cartServiceUpdateItem(
      variantId: variant.id,
      quantity: quantity,
      action: UpdateAction.UPDATE_ACTION_ADD,
    );
  }

  @override
  RepoResult<CartModel> decrementItem(
    VariantModel variant,
    int quantity,
  ) async {
    return _cartServiceUpdateItem(
      variantId: variant.id,
      quantity: quantity,
      action: UpdateAction.UPDATE_ACTION_SUBSTRACT,
    );
  }

  @override
  RepoResult<CartModel> removeItem(VariantModel variant) {
    return _cartServiceUpdateItem(
      variantId: variant.id,
      quantity: 1,
      action: UpdateAction.UPDATE_ACTION_REMOVE,
    );
  }

  /// Updates cart item by calling [CartServiceClient.update].
  /// Then calls [loadCart] to receive latest cart session.
  RepoResult<CartModel> _cartServiceUpdateItem({
    required String variantId,
    required int? quantity,
    required UpdateAction action,
  }) async {
    return safeCall(() async {
      final req = UpdateRequest(
        storeId: _storeRepository.activeStoreId,
        item: UpdateItem(
          variantId: variantId,
          quantity: quantity,
        ),
        action: action,
      );

      // Ignore value returned
      await _cartServiceClient.update(req);

      return loadCart();
    });
  }
}
