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
  ];

  @override
  Future<Either<Failure, List<DeliveryAddressModel>>>
      getDeliveryAddresses() async {
    //  Simulate network loading
    await Future.delayed(const Duration(seconds: 1));
    return right(addressList);
  }
}
