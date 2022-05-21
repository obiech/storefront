import '../../../../core/core.dart';
import '../../../product/domain/domain.dart';
import '../models/cart_model.dart';

/// Defines communication behavior with data source that is
/// responsible for Cart.
abstract class ICartRepository {
  /// Loads cart data from remote or local data source.
  RepoResult<CartModel> loadCart(String storeId);

  /// Adds a new cart item [variant] to a cart session
  /// at a store identified with [storeId].
  RepoResult<CartModel> addItem(String storeId, VariantModel variant);

  /// Increases the amount of cart item [variant] by [quantity]
  /// to a cart session at a store identified with [storeId].
  RepoResult<CartModel> incrementItem(
    String storeId,
    VariantModel variant,
    int quantity,
  );

  /// Subtracts the amount of cart item [variant] by [quantity]
  /// to a cart session at a store identified with [storeId].
  RepoResult<CartModel> decrementItem(
    String storeId,
    VariantModel variant,
    int quantity,
  );
}
