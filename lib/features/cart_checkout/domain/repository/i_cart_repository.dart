import '../../../../core/core.dart';
import '../../../product/domain/domain.dart';
import '../models/cart_model.dart';

/// Defines communication behavior with data source that is
/// responsible for Cart.
abstract class ICartRepository {
  /// Loads cart data from remote or local data source.
  RepoResult<CartModel> loadCart();

  /// Adds a new cart item [variant] to the current active cart session
  RepoResult<CartModel> addItem(VariantModel variant);

  /// Increases the amount of cart item [variant] by [quantity]
  /// to the current active cart session.
  RepoResult<CartModel> incrementItem(
    VariantModel variant,
    int quantity,
  );

  /// Subtracts the amount of cart item [variant] by [quantity]
  /// to the current active cart session.
  RepoResult<CartModel> decrementItem(
    VariantModel variant,
    int quantity,
  );

  /// Removes a cart item [variant] from the current active cart session.
  RepoResult<CartModel> removeItem(VariantModel variant);
}
