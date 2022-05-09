import '../../../../core/core.dart';
import '../../../product/domain/models/product_model.dart';
import '../models/cart_model.dart';

/// Defines communication behavior with data source that is
/// responsible for Cart.
abstract class ICartRepository {
  /// Loads cart data from remote or local data source.
  RepoResult<CartModel> loadCart();

  /// Adds a new cart item [product] to a cart session
  /// at a store identified with [storeId].
  RepoResult<CartModel> addItem(String storeId, ProductModel product);
}
