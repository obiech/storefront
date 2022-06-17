import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/domain/services/search_location_history_service.dart';
import 'package:storefront_app/features/address/index.dart';

import '../../../../../test_commons/fixtures/address/places_auto_complete_result.dart';
import '../../mocks.dart';

void main() {
  late Box<SearchLocationHistoryQuery> historyBox;
  late DateTimeProvider dateTimeProvider;
  late SearchLocationHistoryService historyService;

  final now = DateTime(2022, 6, 17, 21, 37);
  final placeModel = PlaceModel.fromPlacesService(placesResultList[0]);
  final historyQuery = SearchLocationHistoryQuery(
    placeModel: placeModel,
    createdAt: now,
  );

  setUp(() {
    historyBox = MockSearchHistoryBox();
    dateTimeProvider = MockDateTimeProvider();
    historyService = SearchLocationHistoryService(historyBox, dateTimeProvider);
  });

  tearDownAll(() {
    verifyNoMoreInteractions(historyBox);
    verifyNoMoreInteractions(dateTimeProvider);
  });

  test(
    'should return place list '
    'when getSearchHistory is called '
    'and return success',
    () async {
      when(() => historyBox.values).thenReturn([historyQuery]);

      final result = await historyService.getSearchHistory();
      final places = result.getRight();

      expect(places, [historyQuery.placeModel]);
      verify(() => historyBox.values).called(1);
    },
  );

  test(
    'should return failure '
    'when getSearchHistory is called '
    'and exception is thrown',
    () async {
      final exception = Exception('Error!');
      when(() => historyBox.values).thenThrow(exception);

      final result = await historyService.getSearchHistory();
      final failure = result.getLeft();

      expect(failure, isA<Failure>());
      expect(failure.message, 'An unknown error has occured');
      verify(() => historyBox.values).called(1);
    },
  );

  test(
    'should put new place by id '
    'when addSearchQuery is called ',
    () async {
      when(() => historyBox.put(placeModel.placeId, historyQuery))
          .thenAnswer((_) async => Future.value());
      when(() => dateTimeProvider.now).thenReturn(now);

      await historyService.addSearchQuery(placeModel);

      verify(() => historyBox.put(placeModel.placeId, historyQuery)).called(1);
      verify(() => dateTimeProvider.now).called(1);
    },
  );
}
