import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/errors/failure.dart';
import 'package:storefront_app/features/address/index.dart';

import '../../../../../test_commons/fixtures/address/delivery_address_models.dart'
    as fixtures;
import '../../mocks.dart';

void main() {
  late IDeliveryAddressRepository deliveryAddressRepository;
  late DeliveryAddressCubit cubit;

  setUp(() {
    deliveryAddressRepository = MockDeliveryAddressRepository();
    cubit = DeliveryAddressCubit(
      deliveryAddressRepository: deliveryAddressRepository,
    );
  });

  group(
    '[DeliveryAddressCubit]',
    () {
      test(
        'should start with Initial state',
        () {
          expect(cubit.state, isA<DeliveryAddressInitial>());
        },
      );

      group(
        '[fetchDeliveryAddresses()]',
        () {
          blocTest<DeliveryAddressCubit, DeliveryAddressState>(
            'should emit Loading state followed by Loaded state '
            'with addresses sorted by address creation date descending '
            'and first address from the list to be default address',
            setUp: () {
              when(
                () => deliveryAddressRepository.getDeliveryAddresses(),
              ).thenAnswer(
                (_) async => right(
                  List.from(fixtures.sampleDeliveryAddressList),
                ),
              );
            },
            build: () => cubit,
            act: (cubit) async {
              await cubit.fetchDeliveryAddresses();
            },
            expect: () {
              final sortedList = List<DeliveryAddressModel>.from(
                fixtures.sampleDeliveryAddressList,
              )..sort((a, b) => b.dateCreated.compareTo(a.dateCreated));

              return [
                const DeliveryAddressLoading(),
                DeliveryAddressLoaded(
                  addressList: sortedList,
                  activeAddress: sortedList.first,
                ),
              ];
            },
            verify: (cubit) {
              verify(() => deliveryAddressRepository.getDeliveryAddresses())
                  .called(1);
            },
          );

          blocTest<DeliveryAddressCubit, DeliveryAddressState>(
            'Change selected address into the active one',
            build: () => cubit,
            seed: () => DeliveryAddressLoaded(
              addressList: fixtures.sampleDeliveryAddressList,
              activeAddress: fixtures.sampleDeliveryAddressList[0],
            ),
            act: (cubit) =>
                cubit.setActiveAddress(fixtures.sampleDeliveryAddressList[1]),
            expect: () => [
              DeliveryAddressLoaded(
                addressList: fixtures.sampleDeliveryAddressList,
                activeAddress: fixtures.sampleDeliveryAddressList[1],
              ),
            ],
          );

          blocTest<DeliveryAddressCubit, DeliveryAddressState>(
            'should emit Loading state followed by Error state if '
            'a Failure is returned',
            setUp: () {
              when(
                () => deliveryAddressRepository.getDeliveryAddresses(),
              ).thenAnswer(
                (_) async => left(Failure('An unexpected error occured.')),
              );
            },
            build: () => cubit,
            act: (cubit) async {
              await cubit.fetchDeliveryAddresses();
            },
            expect: () {
              return [
                const DeliveryAddressLoading(),
                const DeliveryAddressError('An unexpected error occured.'),
              ];
            },
            verify: (cubit) {
              verify(() => deliveryAddressRepository.getDeliveryAddresses())
                  .called(1);
            },
          );
        },
      );
    },
  );
}
