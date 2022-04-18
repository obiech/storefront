part of 'order_model.dart';

/// Representation of an order's recipient details
class OrderRecipientModel {
  OrderRecipientModel({
    required this.fullName,
    required this.relationToCustomer,
    required this.imageUrl,
  });

  final String fullName;

  /// Label left behind by driver to identify
  /// recipient's relation to customer
  ///
  /// e.g. children, spouse, etc
  final String relationToCustomer;

  /// URL to recipient's photo taken by driver
  final String imageUrl;
}
