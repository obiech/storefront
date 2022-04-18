part of 'order_model.dart';

/// Representation of an order's driver details
class OrderDriverModel {
  OrderDriverModel({
    required this.fullName,
    required this.vehicleLicenseNumber,
    required this.imageUrl,
    required this.whatsappNumber,
  }) : assert(
          whatsappNumber.startsWith('+62'),
          "Driver's WhatsApp Number has to be in international format",
        );

  final String fullName;

  /// Driver's vehicle license number
  final String vehicleLicenseNumber;

  /// URL to driver's profile image
  final String imageUrl;

  /// Driver's number registered in WhatsApp in international format
  final String whatsappNumber;
}
