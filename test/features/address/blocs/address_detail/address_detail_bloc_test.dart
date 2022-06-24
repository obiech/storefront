import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/index.dart';

import '../../../../../test_commons/fixtures/address/delivery_address_models.dart';
import '../../../../../test_commons/fixtures/address/places_auto_complete_result.dart';
import '../../mocks.dart';

void main() {
  late IDeliveryAddressRepository deliveryAddressRepository;
  late DateTimeProvider dateTimeProvider;
  late AddressDetailBloc bloc;

  final now = DateTime(2022, 5, 25, 10, 14);

  final DeliveryAddressModel addressModel = DeliveryAddressModel(
    id: 'id',
    title: 'Address Name',
    isPrimaryAddress: true,
    lat: 0.0,
    lng: 0.0,
    recipientName: 'recipientName',
    recipientPhoneNumber: 'recipientPhoneNumber',
    dateCreated: now,
  );

  final DeliveryAddressModel loadedAddress = sampleDeliveryAddressList[0];

  setUp(() {
    deliveryAddressRepository = MockDeliveryAddressRepository();
    dateTimeProvider = MockDateTimeProvider();
    bloc = AddressDetailBloc(
      repository: deliveryAddressRepository,
      dateTimeProvider: dateTimeProvider,
    );

    when(() => dateTimeProvider.now).thenReturn(now);
  });

  tearDown(() {
    verifyNoMoreInteractions(deliveryAddressRepository);
  });

  group('AddressDetailBloc', () {
    blocTest<AddressDetailBloc, AddressDetailState>(
      'should emit lat, lng, & address detail '
      'when LoadPlaceDetail is added '
      'and PlaceDetailsModel is provided',
      build: () => bloc,
      act: (bloc) => bloc.add(LoadPlaceDetail(placeDetailsModel: placeDetails)),
      expect: () => [
        AddressDetailState(
          addressDetailsName: placeDetails.name,
          addressDetails: placeDetails.addressDetails.toPrettyAddress,
          latLng: LatLng(placeDetails.lat, placeDetails.lng),
        ),
      ],
    );

    blocTest<AddressDetailBloc, AddressDetailState>(
      'should emit id, lat, lng, address detail, address name,  '
      'address notes, recipient name, recipient phone number, '
      'is primary address, & turn into edit mode '
      'when LoadDeliveryAddress is added '
      'and DeliveryAddressModel is provided',
      build: () => bloc,
      act: (bloc) =>
          bloc.add(LoadDeliveryAddress(deliveryAddressModel: loadedAddress)),
      expect: () {
        final state = AddressDetailState(
          id: loadedAddress.id,
          addressName: loadedAddress.title,
          addressDetailsNote: loadedAddress.notes ?? '',
          recipientName: loadedAddress.recipientName,
          recipientPhoneNumber: loadedAddress.recipientPhoneNumber,
          isPrimaryAddress: loadedAddress.isPrimaryAddress,
          isEditMode: true,
        );
        return [
          state,
          state.copyWith(
            latLng: LatLng(loadedAddress.lat, loadedAddress.lng),
            addressDetailsName: loadedAddress.details?.name,
            addressDetails: loadedAddress.details?.toPrettyAddress,
          ),
        ];
      },
    );

    blocTest<AddressDetailBloc, AddressDetailState>(
      'should emit address name '
      'when AddressNameChanged is added',
      build: () => bloc,
      act: (bloc) => bloc.add(AddressNameChanged(addressModel.title)),
      expect: () => [
        AddressDetailState(addressName: addressModel.title),
      ],
    );

    blocTest<AddressDetailBloc, AddressDetailState>(
      'should emit isMapReady & updateLatLng '
      'when MapIsReady is added',
      build: () => bloc,
      act: (bloc) => bloc.add(const MapIsReady()),
      expect: () => [
        const AddressDetailState(
          isMapReady: true,
          updateLatLng: true,
        ),
      ],
    );

    blocTest<AddressDetailBloc, AddressDetailState>(
      'should emit address detail '
      'when AddressDetailChanged is added',
      build: () => bloc,
      act: (bloc) => bloc.add(const AddressDetailNoteChanged('addressDetail')),
      expect: () => [
        const AddressDetailState(addressDetailsNote: 'addressDetail'),
      ],
    );

    blocTest<AddressDetailBloc, AddressDetailState>(
      'should emit recipient name '
      'when RecipientNameChanged is added',
      build: () => bloc,
      act: (bloc) => bloc.add(RecipientNameChanged(addressModel.recipientName)),
      expect: () => [
        AddressDetailState(recipientName: addressModel.recipientName),
      ],
    );

    blocTest<AddressDetailBloc, AddressDetailState>(
      'should emit recipient phone '
      'when RecipientPhoneChanged is added',
      build: () => bloc,
      act: (bloc) =>
          bloc.add(RecipientPhoneChanged(addressModel.recipientPhoneNumber)),
      expect: () => [
        AddressDetailState(
          recipientPhoneNumber: addressModel.recipientPhoneNumber,
        ),
      ],
    );

    blocTest<AddressDetailBloc, AddressDetailState>(
      'should emit primary address status '
      'when PrimaryAddressChanged is added',
      build: () => bloc,
      act: (bloc) =>
          bloc.add(PrimaryAddressChanged(addressModel.isPrimaryAddress)),
      expect: () => [
        AddressDetailState(isPrimaryAddress: addressModel.isPrimaryAddress),
      ],
    );

    blocTest<AddressDetailBloc, AddressDetailState>(
      'should emit error message '
      'when FormSubmitted event is added '
      'and save address returns failure',
      setUp: () {
        when(() => deliveryAddressRepository.saveAddress(addressModel))
            .thenAnswer((_) async => left(Failure('Error!')));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(
        const FormSubmitted(),
      ),
      expect: () => [
        const AddressDetailState(loading: true),
        const AddressDetailState(errorMessage: 'Error!'),
      ],
      verify: (_) {
        verify(() => deliveryAddressRepository.saveAddress(addressModel))
            .called(1);
      },
    );

    blocTest<AddressDetailBloc, AddressDetailState>(
      'should emit valid state '
      'when FormSubmitted event is added '
      'and save address returns right',
      setUp: () {
        when(() => deliveryAddressRepository.saveAddress(addressModel))
            .thenAnswer((_) async => right(unit));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(
        const FormSubmitted(),
      ),
      expect: () => [
        const AddressDetailState(loading: true),
        const AddressDetailState(addressUpdated: true),
      ],
      verify: (_) {
        verify(() => deliveryAddressRepository.saveAddress(addressModel))
            .called(1);
      },
    );

    blocTest<AddressDetailBloc, AddressDetailState>(
      'should emit error message '
      'when FormSubmitted event is added '
      'and update address returns failure',
      setUp: () {
        when(() => deliveryAddressRepository.updateAddress(addressModel))
            .thenAnswer((_) async => left(Failure('Error!')));
      },
      seed: () => const AddressDetailState(isEditMode: true),
      build: () => bloc,
      act: (bloc) => bloc.add(
        const FormSubmitted(),
      ),
      expect: () => [
        const AddressDetailState(loading: true, isEditMode: true),
        const AddressDetailState(errorMessage: 'Error!', isEditMode: true),
      ],
      verify: (_) {
        verify(() => deliveryAddressRepository.updateAddress(addressModel))
            .called(1);
      },
    );

    blocTest<AddressDetailBloc, AddressDetailState>(
      'should emit valid state '
      'when FormSubmitted event is added '
      'and update address returns right',
      setUp: () {
        when(() => deliveryAddressRepository.updateAddress(addressModel))
            .thenAnswer((_) async => right(unit));
      },
      seed: () => const AddressDetailState(isEditMode: true),
      build: () => bloc,
      act: (bloc) => bloc.add(
        const FormSubmitted(),
      ),
      expect: () => [
        const AddressDetailState(loading: true, isEditMode: true),
        const AddressDetailState(addressUpdated: true, isEditMode: true),
      ],
      verify: (_) {
        verify(() => deliveryAddressRepository.updateAddress(addressModel))
            .called(1);
      },
    );
  });
}
