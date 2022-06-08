import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/domain/services/search_location_service.dart';

import '../../../../../test_commons/fixtures/address/places_auto_complete_result.dart';
import '../../mocks.dart';

void main() {
  late DropezyPlacesService placesService;
  late SearchLocationService searchLocationService;

  const query = 'Lebak Bulus';

  setUp(() {
    placesService = MockDropezyPlacesService();
    searchLocationService = SearchLocationService(placesService);
  });

  tearDownAll(() {
    verifyNoMoreInteractions(placesService);
  });

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
}
