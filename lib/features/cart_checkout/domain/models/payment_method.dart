import 'package:equatable/equatable.dart';
import 'payment_method_type.dart';

/// Payment method
///
/// Models a single payment method for the checkout procedure
class PaymentMethod extends Equatable {
  /// The title of the payment method
  /// to be displayed to the user
  final String title;

  /// The payment tag to be used as a payment method
  /// identifier with backend
  final String tag;

  /// The payment provider logo
  final String image;

  /// The deeplink or external link to
  /// payment provider
  final String link;

  /// Signifies that the provided link is a deeplink
  final bool isDeeplink;

  /// Signifies that the payment is a wallet
  /// or a virtual account.
  final PaymentMethodType type;

  const PaymentMethod({
    required this.title,
    required this.tag,
    required this.image,
    required this.link,
    required this.type,
    this.isDeeplink = false,
  });

  /// Parse [PaymentMethod] from json map
  PaymentMethod.fromJson(Map<String, dynamic> json)
      : title = json['title'] ?? (throw ArgumentError('title is required')),
        tag = json['tag'] ?? (throw ArgumentError('tag is required')),
        image = json['image'] ?? (throw ArgumentError('image is required')),
        link = json['link'] ?? (throw ArgumentError('link is required')),
        type = (json['type'] as String? ?? '').toPaymentMethod(),
        isDeeplink = json['is_deep_link'] ?? false;

  /// Parse [PaymentMethod] to json map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'tag': tag,
      'image': image,
      'link': link,
      'type': type.name,
      'is_deep_link': isDeeplink
    };
  }

  @override
  List<Object?> get props => [title, tag, image, link];
}
