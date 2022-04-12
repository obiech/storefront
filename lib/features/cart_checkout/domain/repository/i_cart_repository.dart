import 'package:dropezy_proto/v1/cart/cart.pb.dart';

import '../domains.dart';

/// Repo structure for cart methods repository
abstract class ICartRepository {
  /// Add adds new cart item to existing cart session, or new cart session.
  Future<AddResponse> add(AddRequest request);

  /// Update updates the content of existing cart session.
  Future<UpdateResponse> update(UpdateRequest method);

  /// Summary will return cart summary for the existing cart session
  Future<CartPaymentSummaryModel> summary(SummaryRequest request);
}
