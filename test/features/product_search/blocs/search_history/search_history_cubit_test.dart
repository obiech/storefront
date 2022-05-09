import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:storefront_app/features/product_search/index.dart';

import '../../mocks.dart';

void main() {
  late Box<DateTime> _box;
  late SearchHistoryRepository _repository;
  late SearchHistoryCubit cubit;

  const List<String> queries = [
    'bananas',
    'peaches',
    'apples',
    'chicken',
    'paprika'
  ];

  late Map<String, DateTime> _store;
  late BehaviorSubject<BoxEvent> _hiveWatch;

  setUp(() async {
    _box = MockDateTimeHiveBox();
    _hiveWatch = BehaviorSubject();
    _store = {};

    /// Box stubs
    when(() => _box.keys).thenAnswer((_) => _store.keys);
    when(() => _box.watch()).thenAnswer((_) => _hiveWatch);

    when(() => _box.put(any(), any())).thenAnswer((invocation) async {
      final _key = invocation.positionalArguments.first as String;
      final _value = invocation.positionalArguments[1] as DateTime;

      _store[_key] = _value;
      _hiveWatch.add(BoxEvent(_key, _value, false));
    });

    when(() => _box.delete(any())).thenAnswer((invocation) async {
      final _key = invocation.positionalArguments.first as String;

      _store.remove(_key);
      _hiveWatch.add(BoxEvent(_key, DateTime.now(), true));
    });

    when(() => _box.clear()).thenAnswer((_) async {
      for (final _key in _store.keys) {
        _hiveWatch.add(BoxEvent(_key, _store[_key], true));
      }
      final _size = _store.length;
      _store.clear();

      return _size;
    });

    _repository = SearchHistoryRepository(_box);

    cubit = SearchHistoryCubit(_repository);
    for (final query in queries) {
      await cubit.addSearchQuery(query);
    }
  });

  tearDown(() {
    _hiveWatch.close();
  });

  group('[getSearchQueries]', () {
    test(
        'When cubit is created, '
        'LoadedQueries is emitted with all search history', () async {
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

      await cubit.addSearchQuery(_newQuery);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(cubit.state, isA<LoadedSearchQueries>());

      final state = cubit.state as LoadedSearchQueries;

      expect(state.queries.first, _newQuery);
      expect(
        state.queries.last,
        _repository.queries.getLatest[maxSearchHistory - 1],
      );
    });

    test(
        'When "addSearchQuery" is called, '
        'LoadedQueries is emitted with the inserted query '
        'and the query is added as the latest', () async {
      const _newQuery = 'beans';
      await cubit.addSearchQuery(_newQuery);
      await Future.delayed(const Duration(milliseconds: 100));

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
      await Future.delayed(const Duration(milliseconds: 100));

      expect(cubit.state, isA<LoadedSearchQueries>());
      final state = cubit.state as LoadedSearchQueries;
      expect(state.queries.where((query) => query == _newQuery).length, 1);
    });
  });

  group('[removeSearchQuery]', () {
    test(
        'When "removeSearchQuery" is called,the provided query is LoadedQueries is emitted without the removed query',
        () async {
      expect(cubit.state, isA<LoadedSearchQueries>());
      var state = cubit.state as LoadedSearchQueries;
      final initialLength = state.queries.length;
      final remove = state.queries.first;

      await cubit.removeSearchQuery(remove);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(cubit.state, isA<LoadedSearchQueries>());
      state = cubit.state as LoadedSearchQueries;
      expect(state.queries.length, initialLength - 1);
      expect(state.queries.contains(remove), false);
    });
  });

  test('Queries will always have a maximum [maxSearchHistory] results',
      () async {
    await Future.delayed(const Duration(milliseconds: 100));
    expect(cubit.state, isA<LoadedSearchQueries>());
    var state = cubit.state as LoadedSearchQueries;
    expect(state.queries.length, maxSearchHistory);

    const _newQueries = ['rice', 'meat', 'peas', 'fish', 'carrots'];
    for (final val in _newQueries) {
      await cubit.addSearchQuery(val);
    }
    await Future.delayed(const Duration(milliseconds: 100));

    expect(cubit.state, isA<LoadedSearchQueries>());
    state = cubit.state as LoadedSearchQueries;
    expect(state.queries.length, maxSearchHistory);
  });

  group('[clearSearchQueries]', () {
    test(
        'When "clearSearchQueries" is called, LoadedQueries is emitted with no query',
        () async {
      await Future.delayed(const Duration(milliseconds: 100));
      expect(cubit.state, isA<LoadedSearchQueries>());
      var state = cubit.state as LoadedSearchQueries;
      expect(state.queries.isNotEmpty, true);
      expect(state.queries.length, queries.length);

      await cubit.clearSearchQueries();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(cubit.state, isA<LoadedSearchQueries>());
      state = cubit.state as LoadedSearchQueries;
      expect(state.queries.isEmpty, true);
    });
  });
}
