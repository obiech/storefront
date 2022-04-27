import 'package:equatable/equatable.dart';

import 'address_details_model.dart';

class DeliveryAddressModel extends Equatable {
  const DeliveryAddressModel({
    required this.id,
    required this.title,
    this.notes,
    required this.isPrimaryAddress,
    required this.lat,
    required this.lng,
    required this.recipientName,
    required this.recipientPhoneNumber,
    this.details,
    required this.dateCreated,
  });

  /// Unique identifier for this address
  final String id;

  /// Identifier for this address
  /// e.g. Home, Work
  final String title;

  /// Notes for the delivery address
  /// such as landmarks or directions
  final String? notes;

  /// Whether or not this user's primary address
  final bool isPrimaryAddress;

  /// Latitude
  final double lat;

  /// Longitude
  final double lng;

  /// Person that will be receiving the order
  final String recipientName;

  final String recipientPhoneNumber;

  /// Details of the location such as
  /// Street Name or District Name.
  ///
  /// i.e. the result of Reverse Geocoding
  final AddressDetailsModel? details;

  /// Date & Time at which this address
  /// was first created
  final DateTime dateCreated;

  @override
  List<Object?> get props => [id];
}
