import 'package:storefront_app/features/address/domain/domains.dart';

final sampleDeliveryAddressList = [
  DeliveryAddressModel(
    id: 'delivery-address-1',
    title: 'Rumah',
    isPrimaryAddress: true,
    lat: -6.17849,
    lng: 106.84138,
    recipientName: 'Susi Susanti',
    recipientPhoneNumber: '08123123123',
    dateCreated: DateTime(2022, 1, 20),
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
  ),
];
