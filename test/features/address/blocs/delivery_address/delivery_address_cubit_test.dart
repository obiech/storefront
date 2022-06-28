import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/errors/failure.dart';
import 'package:storefront_app/core/services/geofence/models/dropezy_latlng.dart';
import 'package:storefront_app/core/services/geofence/models/dropezy_polygon.dart';
import 'package:storefront_app/core/services/geofence/repository/i_geofence_local_persistence.dart';
import 'package:storefront_app/core/services/geofence/repository/i_geofence_repository.dart';
import 'package:storefront_app/features/address/index.dart';

import '../../../../../test_commons/fixtures/address/delivery_address_models.dart'
    as fixtures;
import '../../../../src/mock_response_future.dart';
import '../../mocks.dart';

void main() {
  late IDeliveryAddressRepository deliveryAddressRepository;
  late IGeofenceLocalPersistence localPersistence;
  late IGeofenceRepository geofenceRepository;
  late DeliveryAddressCubit cubit;

  setUp(() {
    deliveryAddressRepository = MockDeliveryAddressRepository();
    geofenceRepository = MockIGeofenceRepository();
    localPersistence = MockIGeofenceLocalPersistence();
    when(() => localPersistence.polygons)
        .thenAnswer((invocation) => Stream.value(polygons));

    when(() => geofenceRepository.getUpdatedGeofences())
        .thenAnswer((invocation) => MockResponseFuture.value(Right(polygons)));
    cubit = DeliveryAddressCubit(
      deliveryAddressRepository: deliveryAddressRepository,
      geofenceLocalPersistence: localPersistence,
      geofenceRepository: geofenceRepository,
    );
  });
  setUpAll(() {
    registerFallbackValue(
      DropezyPolygon(
        id: 'fake',
        name: 'fake name',
        storeId: 'fake storeId',
      ),
    );
    registerFallbackValue(const DropezyLatLng(0, 0));
  });

  group(
    '[DeliveryAddressCubit]',
    () {
      test(
        'should start with Initial state '
        'and create a subscription',
        () {
          expect(cubit.state, isA<DeliveryAddressInitial>());
          verify(() => localPersistence.polygons).called(1);
          verify(() => geofenceRepository.getUpdatedGeofences()).called(1);
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
              when(
                () => geofenceRepository.scanMultiplePolygon(
                  point: any(named: 'point'),
                  polys: any(named: 'polys'),
                ),
              ).thenAnswer((invocation) => false);
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
            'should emit Loading state followed by Loaded state '
            'with addresses sorted by address creation date descending '
            'and first address from the list to be default address '
            'add [isLocatedWithinGeofence] as true for when '
            '[geofenceRepository.containsLocation] is true',
            setUp: () {
              when(
                () => deliveryAddressRepository.getDeliveryAddresses(),
              ).thenAnswer(
                (_) async => right(
                  List.from(fixtures.sampleDeliveryAddressList),
                ),
              );
              when(
                () => geofenceRepository.scanMultiplePolygon(
                  point: any(named: 'point'),
                  polys: any(named: 'polys'),
                ),
              ).thenAnswer((invocation) => true);
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
                  addressList: sortedList
                    ..map((e) => e.copyWith(isLocatedWithinGeofence: true)),
                  activeAddress:
                      sortedList.first.copyWith(isLocatedWithinGeofence: true),
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

final polygons = {
  DropezyPolygon(
    id: 'Dummy Polygon',
    points: [
      const DropezyLatLng(10, 10),
      const DropezyLatLng(10, 20),
      const DropezyLatLng(20, 20),
      const DropezyLatLng(20, 10),
      const DropezyLatLng(10, 10)
    ],
    name: 'fake name',
    storeId: 'fake storeId',
  ),
  DropezyPolygon(
    id: 'Dummy Polygon2',
    points: [
      const DropezyLatLng(10, 10),
      const DropezyLatLng(10, 20),
      const DropezyLatLng(20, 20),
      const DropezyLatLng(20, 10),
      const DropezyLatLng(10, 10)
    ],
    name: 'fake name 2',
    storeId: 'fake storeId 2',
  ),
  DropezyPolygon(
    id: 'Dummy Polygon3',
    points: [
      const DropezyLatLng(10, 10),
      const DropezyLatLng(10, 20),
      const DropezyLatLng(20, 20),
      const DropezyLatLng(20, 10),
      const DropezyLatLng(10, 10)
    ],
    name: 'fake name 3',
    storeId: 'fake storeId 3',
  )
};
