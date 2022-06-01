import 'package:dartz/dartz.dart';
import 'package:dropezy_proto/v1/cart/cart.pbgrpc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/models/repo_result.dart';
import 'package:storefront_app/di/di_environment.dart';
import 'package:storefront_app/features/product/domain/models/variant_model.dart';

import '../../../../core/errors/failure.dart';
import '../domains.dart';

/// [ICartRepository] that communicates with storefront-backend
/// CartService with [CartServiceClient].
///
/// Currently cart session will be reset whenever Store is changed.
///
/// When user's cart contains no items, a [ResourceNotFoundFailure] will
/// be returend from any of the methods below.
@LazySingleton(as: ICartRepository, env: DiEnvironment.grpcEnvs)
class CartService extends ICartRepository {
  CartService(this._cartServiceClient);

  final CartServiceClient _cartServiceClient;

  /// Fetches current active cart using [CartServiceClient.summary].
  ///
  /// Call this method after every successful operation (add, edit, delete)
  /// to get latest cart contents and payment summary.
  @override
  RepoResult<CartModel> loadCart(String storeId) async {
    try {
      final response =
          await _cartServiceClient.summary(SummaryRequest(storeId: storeId));

      return right(CartModel.fromPb(response));
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }

  /// First sends an add item request to storefront-backend.
  /// Then calls [loadCart] to receive latest cart session.
  @override
  RepoResult<CartModel> addItem(String storeId, VariantModel variant) async {
    try {
      final req = AddRequest(
        storeId: storeId,
        item: UpdateItem(variantId: variant.id),
      );

      // Ignore value returned
      await _cartServiceClient.add(req);

      return await loadCart(storeId);
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }

  @override
  RepoResult<CartModel> decrementItem(
    String storeId,
    VariantModel variant,
    int quantity,
  ) {
    // TODO: implement decrementItem
    throw UnimplementedError();
  }

  @override
  RepoResult<CartModel> incrementItem(
    String storeId,
    VariantModel variant,
    int quantity,
  ) {
    // TODO: implement incrementItem
    throw UnimplementedError();
  }

  @override
  RepoResult<CartModel> removeItem(String storeId, VariantModel variant) {
    // TODO: implement removeItem
    throw UnimplementedError();
  }
}
