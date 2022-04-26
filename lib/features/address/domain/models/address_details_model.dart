/// Details of an address such as:
/// - Street Name & Number
/// - District (Kecamatan)
/// - Sub-District (Kabupaten)
/// - Municipality (Kotamadya)
/// - Zip Code
/// - Province
/// - Country
///
/// All fields are nullable as they might not be available.
class AddressDetailsModel {
  const AddressDetailsModel({
    this.street,
    this.district,
    this.subDistrict,
    this.municipality,
    this.zipCode,
    this.province,
    this.country,
  });

  final String? street;

  final String? district;

  final String? subDistrict;

  final String? municipality;

  final String? zipCode;

  final String? province;

  final String? country;
}
