import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/domain/services/search_location_service.dart';

import '../../../../../test_commons/fixtures/address/places_auto_complete_result.dart';
import '../../mocks.dart';

void main() {
  late DropezyPlacesService placesService;
  late SearchLocationService searchLocationService;

  const query = 'Lebak Bulus';
  const latLng = LatLng(-6.1754463, 106.8377065);

  setUp(() {
    placesService = MockDropezyPlacesService();
    searchLocationService = SearchLocationService(placesService);
  });

  tearDownAll(() {
    verifyNoMoreInteractions(placesService);
  });

  group('searchLocation', () {
    test(
      'should return list '
      'when searchLocation is called '
      'and request is successful',
      () async {
        when(() => placesService.getAutoComplete(query))
            .thenAnswer((_) async => placesResultList);

        final result = await searchLocationService.searchLocation(query);

        expect(result, right(placesResultList));
        verify(() => placesService.getAutoComplete(query)).called(1);
      },
    );

    test(
      'should return failure '
      'when searchLocation is called '
      'and exception is thrown',
      () async {
        final exception = Exception('Error!');
        when(() => placesService.getAutoComplete(query)).thenThrow(exception);

        final result = await searchLocationService.searchLocation(query);

        final failure = result.getLeft();
        expect(failure, isA<Failure>());
        expect(failure.message, 'An unknown error has occured');
        verify(() => placesService.getAutoComplete(query)).called(1);
      },
    );
  });

  group('getLocationDetail', () {
    const id = 'places-details-1';

    test(
      'should return AddressDetailsModel '
      'when getLocationDetail is called '
      'and request is successful',
      () async {
        when(() => placesService.getPlaceDetailsModel(id))
            .thenAnswer((_) async => placeDetails);

        final result = await searchLocationService.getLocationDetail(id);

        expect(result, right(placeDetails));
        verify(() => placesService.getPlaceDetailsModel(id)).called(1);
      },
    );

    test(
      'should return failure '
      'when getLocationDetail is called '
      'and exception is thrown',
      () async {
        final exception = Exception('Error!');
        when(() => placesService.getPlaceDetailsModel(id)).thenThrow(exception);

        final result = await searchLocationService.getLocationDetail(id);

        final failure = result.getLeft();
        expect(failure, isA<Failure>());
        expect(failure.message, 'An unknown error has occured');
        verify(() => placesService.getPlaceDetailsModel(id)).called(1);
      },
    );
  });

  group('getCurrentLocation', () {
    test(
      'should return AddressDetailsModel '
      'when getCurrentLocation is called '
      'and request is successful',
      () async {
        when(() => placesService.getPlaceDetailsFromLocation(latLng))
            .thenAnswer((_) async => placeDetails);

        final result = await searchLocationService.getCurrentLocation(latLng);

        expect(result, right(placeDetails));
        verify(() => placesService.getPlaceDetailsFromLocation(latLng))
            .called(1);
      },
    );

    test(
      'should return failure '
      'when getCurrentLocation is called '
      'and exception is thrown',
      () async {
        final exception = Exception('Error!');
        when(() => placesService.getPlaceDetailsFromLocation(latLng))
            .thenThrow(exception);

        final result = await searchLocationService.getCurrentLocation(latLng);

        final failure = result.getLeft();
        expect(failure, isA<Failure>());
        expect(failure.message, 'An unknown error has occured');
        verify(() => placesService.getPlaceDetailsFromLocation(latLng))
            .called(1);
      },
    );
  });
}
