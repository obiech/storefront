import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/di/di_environment.dart';

import '../../../../core/core.dart';
import '../domains.dart';

/// Contains dummy data for [DeliveryAddressModel]
@LazySingleton(as: IDeliveryAddressRepository, env: [DiEnvironment.dummy])
class DummyDeliveryAddressService extends IDeliveryAddressRepository {
  DeliveryAddressModel? _activeAddress;

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
        name: 'Monas',
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
        name: 'Senen Raya No.135',
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
        name: 'Senen Raya No.135',
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
        name: 'Senen Raya No.135',
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
        name: 'Senen Raya No.135',
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
        name: 'Senen Raya No.135',
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
    _activeAddress = addressList.primaryAddress;
    return right(addressList);
  }

  @override
  RepoResult<Unit> saveAddress(DeliveryAddressModel address) async {
    try {
      //  Simulate network loading
      await Future.delayed(const Duration(seconds: 1));
      addressList.add(address);
      _activeAddress = addressList.primaryAddress;
      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  RepoResult<Unit> updateAddress(DeliveryAddressModel address) async {
    try {
      //  Simulate network loading
      await Future.delayed(const Duration(seconds: 1));
      final oldIndex = addressList.indexWhere((e) => e.id == address.id);

      if (address.isPrimaryAddress && addressList.primaryAddress != null) {
        final oldPrimaryAddress = addressList.primaryAddress!;
        final oldPrimaryIndex = addressList.indexOf(oldPrimaryAddress);

        // Mark previous primary as non-primary
        // TODO: replace with copywith
        addressList[oldPrimaryIndex] = DeliveryAddressModel(
          id: oldPrimaryAddress.id,
          title: oldPrimaryAddress.title,
          isPrimaryAddress: false,
          lat: oldPrimaryAddress.lat,
          lng: oldPrimaryAddress.lng,
          notes: oldPrimaryAddress.notes,
          recipientName: oldPrimaryAddress.recipientName,
          recipientPhoneNumber: oldPrimaryAddress.recipientPhoneNumber,
          dateCreated: oldPrimaryAddress.dateCreated,
          details: oldPrimaryAddress.details,
        );
      }

      addressList[oldIndex] = address;
      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  DeliveryAddressModel? get activeDeliveryAddress => _activeAddress;
}
