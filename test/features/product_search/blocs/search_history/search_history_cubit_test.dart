import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storefront_app/features/product_search/index.dart';

void main() {
  late ISearchHistoryRepository _repository;
  late SearchHistoryCubit cubit;

  const List<String> queries = [
    'bananas',
    'peaches',
    'apples',
    'chicken',
    'paprika'
  ];

  setUp(() async {
    SharedPreferences.setMockInitialValues({});

    _repository =
        SearchHistoryRepository(await SharedPreferences.getInstance());

    cubit = SearchHistoryCubit(_repository);
    for (final query in queries) {
      await cubit.addSearchQuery(query);
    }
  });

  group('[getSearchQueries]', () {
    test(
        'When "getSearchQueries" is called, '
        'the _searchQueries is updated and '
        'LoadedQueries is emitted with all search history', () async {
      await cubit.getSearchQueries();

      expect(cubit.state, isA<LoadedSearchQueries>());

      final state = cubit.state as LoadedSearchQueries;
      expect(state.queries.length, queries.length);
    });
  });

  group('[addSearchQuery]', () {
    test(
        'When "addSearchQuery" is called, '
        'If we have maximum number of history queries, '
        'the oldest will be overridden', () async {
      const _newQuery = 'beans';
      final before = await _repository.getSearchQueries();
      await cubit.addSearchQuery(_newQuery);

      expect(cubit.state, isA<LoadedSearchQueries>());

      final state = cubit.state as LoadedSearchQueries;
      expect(state.queries.first, _newQuery);
      expect(state.queries.last, before[maxSearchHistory - 2]);
    });

    test(
        'When "addSearchQuery" is called, '
        'LoadedQueries is emitted with the inserted query '
        'and the query is added as the latest', () async {
      const _newQuery = 'beans';
      await cubit.addSearchQuery(_newQuery);

      expect(cubit.state, isA<LoadedSearchQueries>());
      final state = cubit.state as LoadedSearchQueries;
      expect(state.queries.contains(_newQuery), true);
      expect(state.queries.first, _newQuery);
    });

    test(
        'When "addSearchQuery" is called with a duplicate query, '
        'it should be combined with existing one and set as latest', () async {
      const _newQuery = 'beans';
      await cubit.addSearchQuery(_newQuery);
      await cubit.addSearchQuery(_newQuery);

      expect(cubit.state, isA<LoadedSearchQueries>());
      final state = cubit.state as LoadedSearchQueries;
      expect(state.queries.where((query) => query == _newQuery).length, 1);
    });
  });

  group('[removeSearchQuery]', () {
    test(
        'When "removeSearchQuery" is called,the provided query is LoadedQueries is emitted without the removed query',
        () async {
      await cubit.getSearchQueries();
      expect(cubit.state, isA<LoadedSearchQueries>());
      var state = cubit.state as LoadedSearchQueries;
      final initialLength = state.queries.length;
      final remove = state.queries.first;

      await cubit.removeSearchQuery(remove);

      expect(cubit.state, isA<LoadedSearchQueries>());
      state = cubit.state as LoadedSearchQueries;
      expect(state.queries.length, initialLength - 1);
      expect(state.queries.contains(remove), false);
    });
  });

  test('Queries will always have a maximum [maxSearchHistory] results',
      () async {
    await cubit.getSearchQueries();

    expect(cubit.state, isA<LoadedSearchQueries>());
    var state = cubit.state as LoadedSearchQueries;
    expect(state.queries.length, maxSearchHistory);

    const _newQueries = ['rice', 'meat', 'peas', 'fish', 'carrots'];
    for (final val in _newQueries) {
      await cubit.addSearchQuery(val);
    }

    expect(cubit.state, isA<LoadedSearchQueries>());
    state = cubit.state as LoadedSearchQueries;
    expect(state.queries.length, maxSearchHistory);
  });

  group('[clearSearchQueries]', () {
    test(
        'When "clearSearchQueries" is called, LoadedQueries is emitted with no query',
        () async {
      await cubit.getSearchQueries();

      expect(cubit.state, isA<LoadedSearchQueries>());
      var state = cubit.state as LoadedSearchQueries;
      expect(state.queries.isNotEmpty, true);
      expect(state.queries.length, queries.length);

      await cubit.clearSearchQueries();

      expect(cubit.state, isA<LoadedSearchQueries>());
      state = cubit.state as LoadedSearchQueries;
      expect(state.queries.isEmpty, true);
    });
  });
}
