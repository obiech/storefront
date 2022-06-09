import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/address/domain/models/address_details_model.dart';

void main() {
  const mockAddressDetails = AddressDetailsModel(
    street: 'Jl. Senen Raya No.135, RW.2',
    district: 'Kec. Senen',
    subDistrict: 'Senen',
    municipality: 'Jakarta Pusat',
    province: 'DKI Jakarta',
    zipCode: '10410',
    country: 'Indonesia',
  );

  const mockSeparator = AddressDetailsModel(
    street: 'Jl. Senen Raya No.135, RW.2',
    province: 'DKI Jakarta',
    zipCode: '10410',
  );

  const mockStreetNotNull = AddressDetailsModel(
    street: 'Jl. Senen Raya No.135, RW.2',
  );

  const mockDistrictNotNull = AddressDetailsModel(
    district: 'Senen',
  );

  const mockSubDistrictNotNull = AddressDetailsModel(
    subDistrict: 'Kec. Senen',
  );

  const mockMunicipalityNotNull = AddressDetailsModel(
    municipality: 'Jakarta Pusat',
  );

  const mockProvinceNotNull = AddressDetailsModel(
    province: 'DKI Jakarta',
  );

  const mockZipCodeNotNull = AddressDetailsModel(
    zipCode: '10410',
  );

  const mockCountryNotNull = AddressDetailsModel(
    country: 'Indonesia',
  );

  group('[AddressDetailsModel] null checking', () {
    test('when there is no null', () {
      final formattedAddress = mockAddressDetails.toPrettyAddress;
      expect(
        formattedAddress,
        'Jl. Senen Raya No.135, RW.2, Senen, Kec. Senen, Jakarta Pusat, 10410, DKI Jakarta, Indonesia',
      );
    });

    test(
        'when there is more than one string, separator is shown '
        'and the last string wont get separator', () {
      final formattedAddress = mockSeparator.toPrettyAddress;
      expect(
        formattedAddress,
        'Jl. Senen Raya No.135, RW.2, 10410, DKI Jakarta',
      );
    });
    group('when everything else null and', () {
      test(
          'street is not null then '
          'display only street name', () {
        final formattedAddress = mockStreetNotNull.toPrettyAddress;
        expect(
          formattedAddress,
          'Jl. Senen Raya No.135, RW.2',
        );
      });
      test(
          'district is not null then '
          'display only district name', () {
        final formattedAddress = mockDistrictNotNull.toPrettyAddress;
        expect(
          formattedAddress,
          'Senen',
        );
      });
      test(
          'subDistrict is not null then '
          'display only subDistrict name', () {
        final formattedAddress = mockSubDistrictNotNull.toPrettyAddress;
        expect(
          formattedAddress,
          'Kec. Senen',
        );
      });

      test(
          'municipality is not null then '
          'display only municipality name', () {
        final formattedAddress = mockMunicipalityNotNull.toPrettyAddress;
        expect(
          formattedAddress,
          'Jakarta Pusat',
        );
      });

      test(
          'province is not null then '
          'display only province name', () {
        final formattedAddress = mockProvinceNotNull.toPrettyAddress;
        expect(
          formattedAddress,
          'DKI Jakarta',
        );
      });

      test(
          'zipcode is not null then '
          'display only zipcode name', () {
        final formattedAddress = mockZipCodeNotNull.toPrettyAddress;
        expect(
          formattedAddress,
          '10410',
        );
      });

      test(
          'country is not null then '
          'display only country name', () {
        final formattedAddress = mockCountryNotNull.toPrettyAddress;
        expect(
          formattedAddress,
          'Indonesia',
        );
      });
    });
  });
}
