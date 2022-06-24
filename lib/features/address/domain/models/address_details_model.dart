import 'package:equatable/equatable.dart';

/// Details of an address such as:
/// - Address Name
/// - Street Name & Number
/// - Sub-District (Desa/Kelurahan)
/// - District (Kecamatan)
/// - Municipality (Kota/Kabupaten)
/// - Zip Code
/// - Province
/// - Country
///
/// All fields are nullable as they might not be available.
class AddressDetailsModel extends Equatable {
  const AddressDetailsModel({
    this.name,
    this.street,
    this.subDistrict,
    this.district,
    this.municipality,
    this.zipCode,
    this.province,
    this.country,
  });

  final String? name;

  final String? street;

  final String? subDistrict;

  final String? district;

  final String? municipality;

  final String? zipCode;

  final String? province;

  final String? country;

  @override
  List<Object?> get props => [
        name,
        street,
        subDistrict,
        district,
        municipality,
        zipCode,
        province,
        country,
      ];
}

extension AddressDetailsModelX on AddressDetailsModel {
  /// Function to join all non-null address components
  /// with a comma separator
  String get toPrettyAddress {
    return <String?>[
      street,
      subDistrict,
      district,
      municipality,
      zipCode,
      province,
      country
    ].where((x) => x != null).join(', ');
  }

  /// Function to concatenating place name as part of street
  /// being saved to backend
  String get toDetailAddress {
    return <String?>[
      name,
      toPrettyAddress,
    ].where((x) => x != null).join(', ');
  }
}
