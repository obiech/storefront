import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/index.dart';

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
      'should emit address name '
      'when AddressNameChanged is added',
      build: () => bloc,
      act: (bloc) => bloc.add(AddressNameChanged(addressModel.title)),
      expect: () => [
        AddressDetailState(addressName: addressModel.title),
      ],
    );

    blocTest<AddressDetailBloc, AddressDetailState>(
      'should emit address detail '
      'when AddressDetailChanged is added',
      build: () => bloc,
      act: (bloc) => bloc.add(const AddressDetailChanged('addressDetail')),
      expect: () => [
        const AddressDetailState(addressDetail: 'addressDetail'),
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
      'and repository returns failure',
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
      'and repository returns right',
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
  });
}
