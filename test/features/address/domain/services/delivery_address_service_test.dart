import 'package:dartz/dartz.dart';
import 'package:dropezy_proto/v1/customer/customer.pbgrpc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/domain/services/delivery_address_service.dart';

import '../../../../../test_commons/fixtures/address/delivery_address_models.dart';
import '../../../../../test_commons/fixtures/address/delivery_address_pb_models.dart';
import '../../../../src/mock_response_future.dart';
import '../../mocks.dart';

void main() {
  late CustomerServiceClient customerServiceClient;
  late DeliveryAddressService deliveryAddressService;

  final deliveryAddressModel = sampleDeliveryAddressList[0];

  setUp(() {
    customerServiceClient = MockCustomerServiceClient();
    deliveryAddressService = DeliveryAddressService(customerServiceClient);
  });

  tearDownAll(() {
    verifyNoMoreInteractions(customerServiceClient);
  });

  test(
    'should return address list '
    'when getProfile is called '
    'and request is successful',
    () async {
      final addresses = [
        sampleDeliveryAddressList[0],
      ];

      final request = GetProfileRequest();
      when(() => customerServiceClient.getProfile(request)).thenAnswer(
        (_) => MockResponseFuture.value(
          GetProfileResponse(
            profile: Profile(
              addresses: sampleDeliveryAddressPbList,
            ),
          ),
        ),
      );

      final response = await deliveryAddressService.getDeliveryAddresses();

      final result = response.getRight();
      expect(result, addresses);
      verify(() => customerServiceClient.getProfile(request)).called(1);
    },
  );

  test(
    'should return failure '
    'when getProfile is called '
    'and exception is thrown',
    () async {
      final exception = Exception('Error!');

      final request = GetProfileRequest();
      when(() => customerServiceClient.getProfile(request))
          .thenAnswer((_) => MockResponseFuture.error(exception));

      final response = await deliveryAddressService.getDeliveryAddresses();

      final failure = response.getLeft();
      verify(() => customerServiceClient.getProfile(request)).called(1);
      expect(failure, isA<Failure>());
      expect(failure.message, 'An unknown error has occured');
    },
  );

  test(
    'should add address '
    'when saveAddress is called '
    'and request success',
    () async {
      final addressModel = deliveryAddressModel.toPb();
      final request = AddAddressRequest(
        address: addressModel.address,
        addressType: addressModel.addressType,
        contact: addressModel.contact,
      );
      when(() => customerServiceClient.addAddress(request))
          .thenAnswer((_) => MockResponseFuture.value(AddAddressResponse()));

      final response =
          await deliveryAddressService.saveAddress(deliveryAddressModel);

      final result = response.getRight();
      expect(result, unit);
      verify(() => customerServiceClient.addAddress(request)).called(1);
    },
  );

  test(
    'should return failure '
    'when saveAddress is called '
    'and exception is thrown',
    () async {
      final exception = Exception('Error!');
      final addressModel = deliveryAddressModel.toPb();
      final request = AddAddressRequest(
        address: addressModel.address,
        addressType: addressModel.addressType,
        contact: addressModel.contact,
      );
      when(() => customerServiceClient.addAddress(request))
          .thenAnswer((_) => MockResponseFuture.error(exception));

      final result =
          await deliveryAddressService.saveAddress(deliveryAddressModel);

      final failure = result.getLeft();
      verify(() => customerServiceClient.addAddress(request)).called(1);
      expect(failure, isA<Failure>());
      expect(failure.message, 'An unknown error has occured');
    },
  );
}
