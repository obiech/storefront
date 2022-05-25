import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../domains.dart';

/// Contains dummy data for [DeliveryAddressModel]
@LazySingleton(as: IDeliveryAddressRepository)
class DummyDeliveryAddressService extends IDeliveryAddressRepository {
  static final addressList = [
    DeliveryAddressModel(
      id: 'delivery-address-1',
      title: 'Rumah',
      notes: 'Pagar Silver, paket taruh di depan pintu',
      isPrimaryAddress: true,
      lat: -6.175392,
      lng: 106.827153,
      recipientName: 'Susi Susanti',
      recipientPhoneNumber: '08123123123',
      dateCreated: DateTime(2022, 1, 20),
      details: const AddressDetailsModel(
        street: 'Jl. Monas',
        district: 'Gambir',
        subDistrict: 'Gambir',
        municipality: 'Jakarta Pusat',
        province: 'DKI Jakarta',
        country: 'Indonesia',
      ),
    ),
    DeliveryAddressModel(
      id: 'delivery-address-2',
      title: 'Kantor',
      isPrimaryAddress: false,
      lat: -6.17849,
      lng: 106.84138,
      recipientName: 'Indra',
      recipientPhoneNumber: '08123123123',
      dateCreated: DateTime(2022, 2, 27),
      details: const AddressDetailsModel(
        street: 'Jl. Senen Raya No.135, RW.2',
        district: 'Senen',
        subDistrict: 'Kec. Senen',
        municipality: 'Jakarta Pusat',
        province: 'DKI Jakarta',
        zipCode: '10410',
        country: 'Indonesia',
      ),
    ),
    DeliveryAddressModel(
      id: 'delivery-address-3',
      title: 'Mall',
      isPrimaryAddress: false,
      lat: -6.17849,
      lng: 106.84138,
      recipientName: 'Indra',
      recipientPhoneNumber: '08123123123',
      dateCreated: DateTime(2022, 2, 27),
      details: const AddressDetailsModel(
        street: 'Jl. Senen Raya No.135, RW.2',
        district: 'Senen',
        subDistrict: 'Kec. Senen',
        municipality: 'Jakarta Pusat',
        province: 'DKI Jakarta',
        zipCode: '10410',
        country: 'Indonesia',
      ),
    ),
    DeliveryAddressModel(
      id: 'delivery-address-4',
      title: 'Kos',
      isPrimaryAddress: false,
      lat: -6.17849,
      lng: 106.84138,
      recipientName: 'Indra',
      recipientPhoneNumber: '08123123123',
      dateCreated: DateTime(2022, 2, 27),
      details: const AddressDetailsModel(
        street: 'Jl. Senen Raya No.135, RW.2',
        district: 'Senen',
        subDistrict: 'Kec. Senen',
        municipality: 'Jakarta Pusat',
        province: 'DKI Jakarta',
        zipCode: '10410',
        country: 'Indonesia',
      ),
    ),
    DeliveryAddressModel(
      id: 'delivery-address-5',
      title: 'Pelabuhan',
      isPrimaryAddress: false,
      lat: -6.17849,
      lng: 106.84138,
      recipientName: 'Indra',
      recipientPhoneNumber: '08123123123',
      dateCreated: DateTime(2022, 2, 27),
      details: const AddressDetailsModel(
        street: 'Jl. Senen Raya No.135, RW.2',
        district: 'Senen',
        subDistrict: 'Kec. Senen',
        municipality: 'Jakarta Pusat',
        province: 'DKI Jakarta',
        zipCode: '10410',
        country: 'Indonesia',
      ),
    ),
    DeliveryAddressModel(
      id: 'delivery-address-6',
      title: 'Pasar',
      isPrimaryAddress: false,
      lat: -6.17849,
      lng: 106.84138,
      recipientName: 'Indra',
      recipientPhoneNumber: '08123123123',
      dateCreated: DateTime(2022, 2, 27),
      details: const AddressDetailsModel(
        street: 'Jl. Senen Raya No.135, RW.2',
        district: 'Senen',
        subDistrict: 'Kec. Senen',
        municipality: 'Jakarta Pusat',
        province: 'DKI Jakarta',
        zipCode: '10410',
        country: 'Indonesia',
      ),
    ),
  ];

  @override
  RepoResult<List<DeliveryAddressModel>> getDeliveryAddresses() async {
    //  Simulate network loading
    await Future.delayed(const Duration(seconds: 1));
    return right(addressList);
  }

  @override
  RepoResult<Unit> saveAddress(DeliveryAddressModel address) async {
    try {
      //  Simulate network loading
      await Future.delayed(const Duration(seconds: 1));
      addressList.add(address);

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
