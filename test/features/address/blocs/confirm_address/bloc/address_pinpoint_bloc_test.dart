import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/index.dart';

import '../../../../../../test_commons/fixtures/address/places_auto_complete_result.dart';
import '../../../mocks.dart';

void main() {
  group(
    '[AddressPinpointBloc]',
    () {
      late ISearchLocationRepository searchLocationRepository;
      late AddressPinpointBloc bloc;

      const mockCoords = LatLng(100, 100);
      const waitDuration =
          Duration(milliseconds: AddressPinpointBloc.debounceDuration + 10);

      setUp(() {
        searchLocationRepository = MockSearchLocationRespository();
        bloc = AddressPinpointBloc(searchLocationRepository);
      });

      test(
        'initial state should be [AddressPinpointLoading]',
        () {
          expect(bloc.state, isA<AddressPinpointLoading>());
        },
      );

      group(
        '[GetLocationFromCoordinates]',
        () {
          blocTest<AddressPinpointBloc, AddressPinpointState>(
            'should emit a [AddressPinpointLoading] '
            'and then a [AddressPinpointSuccess] '
            'when [GetLocationFromCoordinates] is added '
            'and repository get location details return success',
            setUp: () {
              when(
                () => searchLocationRepository.getCurrentLocation(mockCoords),
              ).thenAnswer((_) async => right(placeDetails));
            },
            build: () => bloc,
            act: (bloc) =>
                bloc.add(const GetLocationFromCoordinates(mockCoords)),
            wait: waitDuration,
            expect: () => [
              const AddressPinpointLoading(),
              AddressPinpointSuccess(
                placeModel: placeDetails,
                latLng: mockCoords,
              ),
            ],
            verify: (bloc) {
              verify(
                () => searchLocationRepository.getCurrentLocation(mockCoords),
              ).called(1);
            },
          );

          blocTest<AddressPinpointBloc, AddressPinpointState>(
            'should emit a [AddressPinpointLoading] '
            'and then a [AddressPinpointSuccess] '
            'when [GetLocationFromCoordinates] is added '
            'and repository get location details returns failure',
            setUp: () {
              when(
                () => searchLocationRepository.getCurrentLocation(mockCoords),
              ).thenAnswer(
                (_) async => left(
                  Failure('Failed to reverse geocode'),
                ),
              );
            },
            wait: waitDuration,
            build: () => bloc,
            act: (bloc) =>
                bloc.add(const GetLocationFromCoordinates(mockCoords)),
            expect: () => [
              const AddressPinpointLoading(),
              const AddressPinpointError('Failed to reverse geocode'),
            ],
          );
        },
      );
    },
  );
}
