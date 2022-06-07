import 'package:dropezy_proto/google/protobuf/timestamp.pb.dart';
import 'package:dropezy_proto/meta/meta.pb.dart' as meta;
import 'package:dropezy_proto/v1/customer/customer.pbgrpc.dart';
import 'package:storefront_app/features/address/index.dart';

final sampleDeliveryAddressPbList = [
  Address(
    address: meta.Address(
      id: 'delivery-address-1',
      name: 'Rumah',
      address: const AddressDetailsModel(
        street: 'Jl. Monas',
        district: 'Gambir',
        subDistrict: 'Gambir',
        municipality: 'Jakarta Pusat',
        province: 'DKI Jakarta',
        country: 'Indonesia',
      ).toPrettyAddress,
      detail: 'Pagar Silver, paket taruh di depan pintu',
      coordinates: meta.Coordinates(
        latitude: -6.17849,
        longitude: 106.84138,
      ),
      timestamp: meta.Timestamp(
        createdTime: Timestamp.fromDateTime(DateTime(2022, 1, 20)),
      ),
    ),
    contact: Contact(
      name: 'Susi Susanti',
      phoneNumber: '08123123123',
    ),
    addressType: AddressType.ADDRESS_TYPE_PRIMARY,
  ),
];
