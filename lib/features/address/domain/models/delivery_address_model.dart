import 'package:dropezy_proto/meta/meta.pb.dart' as meta;
import 'package:dropezy_proto/v1/customer/customer.pb.dart';
import 'package:equatable/equatable.dart';
import 'package:storefront_app/core/services/geofence/models/dropezy_latlng.dart';

import '../../../../core/services/geofence/models/dropezy_polygon.dart';
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
    this.isLocatedWithinGeofence = false,
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

  /// flag that indicates if this Address is
  /// located within a Geofence Service
  final bool isLocatedWithinGeofence;

  factory DeliveryAddressModel.fromPb(Address address) {
    // TODO: Find better naming :")
    final addressDetailList = address.address.address.split(', ');

    /// Get place name of address
    final addressName = addressDetailList[0];

    /// Get place address detail
    ///
    /// P.S: Format similiar to [AddressDetailsModel.toPrettyAddress]
    final addressStreet = addressDetailList.sublist(1).join(', ');

    // TODO (widy): Map AddressDetailModel
    return DeliveryAddressModel(
      id: address.address.id,
      title: address.address.name,
      isPrimaryAddress: address.addressType == AddressType.ADDRESS_TYPE_PRIMARY,
      lat: address.address.coordinates.latitude,
      lng: address.address.coordinates.longitude,
      notes: address.address.detail,
      recipientName: address.contact.name,
      recipientPhoneNumber: address.contact.phoneNumber,
      dateCreated: address.address.timestamp.createdTime.toDateTime().toLocal(),
      details: AddressDetailsModel(
        name: addressName,
        street: addressStreet,
      ),
    );
  }

  Address toPb() {
    // TODO: Update meta.Address naming on proto
    return Address(
      address: meta.Address(
        id: id,
        name: title,
        address: details?.toDetailAddress,
        coordinates: meta.Coordinates(
          longitude: lng,
          latitude: lat,
        ),
        detail: notes,
      ),
      addressType: isPrimaryAddress
          ? AddressType.ADDRESS_TYPE_PRIMARY
          : AddressType.ADDRESS_TYPE_UNSPECIFIED,
      contact: Contact(
        name: recipientName,
        phoneNumber: recipientPhoneNumber,
      ),
    );
  }

  DeliveryAddressModel copyWith({
    AddressDetailsModel? details,
    String? recipientPhoneNumber,
    DateTime? dateCreated,
    String? recipientName,
    double? lng,
    double? lat,
    bool? isPrimaryAddress,
    String? notes,
    String? id,
    String? title,
    bool? isLocatedWithinGeofence,
  }) {
    return DeliveryAddressModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isPrimaryAddress: isPrimaryAddress ?? this.isPrimaryAddress,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      recipientName: recipientName ?? this.recipientName,
      recipientPhoneNumber: recipientPhoneNumber ?? this.recipientPhoneNumber,
      dateCreated: dateCreated ?? this.dateCreated,
      isLocatedWithinGeofence:
          isLocatedWithinGeofence ?? this.isLocatedWithinGeofence,
      notes: notes ?? this.notes,
      details: details ?? this.details,
    );
  }

  DropezyLatLng get getLntLng => DropezyLatLng(lat, lng);

  @override
  List<Object?> get props => [id];
}

extension ListDeliveryAddressModelX on List<DeliveryAddressModel> {
  void sortDate() {
    sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
  }

  /// Get the primary delivery address.
  ///
  /// If non is found, default to the first
  DeliveryAddressModel? get primaryAddress => isNotEmpty
      ? firstWhere(
          (address) => address.isPrimaryAddress,
          orElse: () => first,
        )
      : null;
}

extension CheckCoverageAreaX on List<DeliveryAddressModel> {
  List<DeliveryAddressModel> checkCoverageArea(
    Set<DropezyPolygon> polys,
    bool Function({
      required DropezyLatLng point,
      required Set<DropezyPolygon> polys,
    })
        scanMultiplePolygon,
  ) {
    final List<DeliveryAddressModel> _scannedAddresses = [];

    if (polys.isEmpty || isEmpty) return this;

    for (final address in this) {
      late bool locatedWithinArea;

      locatedWithinArea = scanMultiplePolygon(
        point: address.getLntLng,
        polys: polys,
      );

      if (locatedWithinArea) {
        _scannedAddresses.add(address.copyWith(isLocatedWithinGeofence: true));
      } else {
        _scannedAddresses.add(address.copyWith(isLocatedWithinGeofence: false));
      }
    }

    return _scannedAddresses;
  }
}
