import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/product_search/index.dart';
import 'package:storefront_app/res/strings/english_strings.dart';

import '../../mocks.dart';

extension WidgetX on WidgetTester {
  Future<void> pumpSearchHistory(SearchHistoryCubit cubit) async {
    await pumpWidget(
      BlocProvider(
        create: (context) => cubit,
        child: const MaterialApp(
          home: Scaffold(
            body: SearchHistory(),
          ),
        ),
      ),
    );
  }
}

void main() {
  late Box<DateTime> _box;
  late SearchHistoryRepository _repository;
  late SearchHistoryCubit cubit;

  late Map<String, DateTime> _store;
  late BehaviorSubject<BoxEvent> _hiveWatch;

  final strings = EnglishStrings();

  const List<String> queries = [
    'bananas',
    'peaches',
    'apples',
    'chicken',
    'paprika'
  ];

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
  });

  testWidgets(
      "When search history hasn't been loaded, "
      'nothing is displayed', (WidgetTester tester) async {
    await tester.pumpSearchHistory(cubit);
    expect(find.byType(ListView), findsNothing);
    expect(find.byType(SizedBox), findsOneWidget);
  });

  testWidgets(
      'When search history is loaded, '
      'show search history header with clear options',
      (WidgetTester tester) async {
    await _loadDefaultQueries(queries, cubit);

    await tester.runAsync(() async {
      await tester.pumpSearchHistory(cubit);
    });

    await tester.pumpAndSettle();

    /// Title
    expect(
      find.text(strings.youPreviouslySearchedFor),
      findsOneWidget,
    );

    /// Clear
    expect(find.byIcon(DropezyIcons.trash), findsOneWidget);
    expect(find.text(strings.clearAll), findsOneWidget);
  });

  testWidgets(
      'When search history is loaded, '
      'show search history with list of all queries',
      (WidgetTester tester) async {
    await _loadDefaultQueries(queries, cubit);

    await tester.runAsync(() async {
      await tester.pumpSearchHistory(cubit);
      await Future.delayed(Duration.zero);
    });

    await tester.pumpAndSettle();

    final _queryWidgets = tester.widgetList(
      find.descendant(
        of: find.byType(ListView),
        matching: find.byType(SearchHistoryItem),
      ),
    );

    expect(_queryWidgets.length, queries.length);

    for (final query in queries) {
      final searchHistoryItem = tester.firstWidget(
        find.descendant(
          of: find.byType(ListView),
          matching: find.byKey(
            ValueKey('${SearchHistoryKeys.searchHistoryItemKey}_$query'),
          ),
        ),
      ) as SearchHistoryItem;

      expect(searchHistoryItem.query, query);
    }
  });

  /// Delete Item
  testWidgets(
      'When search history item is deleted, '
      'ListView items get refreshed with item removed',
      (WidgetTester tester) async {
    await _loadDefaultQueries(queries, cubit);

    await tester.runAsync(() async {
      await tester.pumpSearchHistory(cubit);
      await Future.delayed(Duration.zero);
    });

    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsOneWidget);

    var _queryWidgets = tester.widgetList(
      find.descendant(
        of: find.byType(ListView),
        matching: find.byType(SearchHistoryItem),
      ),
    );
    expect(_queryWidgets.length, queries.length);

    final remove = queries.first;
    final searchHistoryItemFinder = find
        .byKey(ValueKey('${SearchHistoryKeys.searchHistoryItemKey}_$remove'));
    expect(searchHistoryItemFinder, findsOneWidget);
    final searchHistoryItem =
        tester.firstWidget(searchHistoryItemFinder) as SearchHistoryItem;
    expect(searchHistoryItem.query, remove);

    // Delete first item
    await tester.runAsync(() async {
      await tester.tap(
        find.descendant(
          of: searchHistoryItemFinder,
          matching: find.byIcon(DropezyIcons.cross),
        ),
      );

      await Future.delayed(Duration.zero);
    });

    await tester.pumpAndSettle();

    _queryWidgets = tester.widgetList(
      find.descendant(
        of: find.byType(ListView),
        matching: find.byType(SearchHistoryItem),
      ),
    );
    expect(_queryWidgets.length, queries.length - 1);
    expect(searchHistoryItemFinder, findsNothing);
  });

  /// Clear All
  testWidgets(
      'When search history is cleared, '
      'nothing is displayed', (WidgetTester tester) async {
    await _loadDefaultQueries(queries, cubit);

    await tester.runAsync(() async {
      await tester.pumpSearchHistory(cubit);
      await Future.delayed(Duration.zero);
    });

    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsOneWidget);

    // Clear search history
    await tester.runAsync(() async {
      await tester.tap(find.byIcon(DropezyIcons.trash));
      await Future.delayed(Duration.zero);
    });

    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsNothing);
  });

  /// Add Item
  testWidgets(
      'When search history item is added, '
      'ListView items get refreshed with item included',
      (WidgetTester tester) async {
    await _loadDefaultQueries(queries, cubit);
    const _addedQuery = 'meat';

    await tester.runAsync(() async {
      await tester.pumpSearchHistory(cubit);
      await Future.delayed(Duration.zero);
    });

    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsOneWidget);

    var _queryWidgets = tester.widgetList(
      find.descendant(
        of: find.byType(ListView),
        matching: find.byType(SearchHistoryItem),
      ),
    );
    expect(_queryWidgets.length, queries.length);

    await tester.runAsync(() async {
      await cubit.addSearchQuery(_addedQuery);
      await Future.delayed(Duration.zero);
    });

    await tester.pumpAndSettle();

    _queryWidgets = tester.widgetList(
      find.descendant(
        of: find.byType(ListView),
        matching: find.byType(SearchHistoryItem),
      ),
    );

    final searchHistoryItemFinder = find.byKey(
      ValueKey('${SearchHistoryKeys.searchHistoryItemKey}_$_addedQuery'),
    );
    expect(searchHistoryItemFinder, findsOneWidget);
    final searchHistoryItem =
        tester.firstWidget(searchHistoryItemFinder) as SearchHistoryItem;
    expect(searchHistoryItem.query, _addedQuery);
  });
}

Future<void> _loadDefaultQueries(
  List<String> queries,
  SearchHistoryCubit cubit,
) async {
  for (final query in queries) {
    await cubit.addSearchQuery(query);
  }
}
