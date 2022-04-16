import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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
  late ISearchHistoryRepository _repository;
  late SearchHistoryCubit cubit;
  final strings = EnglishStrings();

  const List<String> queries = [
    'bananas',
    'peaches',
    'apples',
    'chicken',
    'paprika'
  ];

  setUp(() async {
    _repository = MockSearchHistoryRepository();
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
    when(() => _repository.getSearchQueries()).thenAnswer((_) async => queries);

    await tester.pumpSearchHistory(cubit);
    await cubit.getSearchQueries();
    verify(() => _repository.getSearchQueries()).called(1);
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
    when(() => _repository.getSearchQueries()).thenAnswer((_) async => queries);

    await tester.pumpSearchHistory(cubit);
    await cubit.getSearchQueries();
    verify(() => _repository.getSearchQueries()).called(1);
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
    when(() => _repository.getSearchQueries()).thenAnswer((_) async => queries);
    when(() => _repository.removeSearchQuery(any()))
        .thenAnswer((invocation) async {
      final _queries = List.of(queries);
      _queries.remove(invocation.positionalArguments[0].toString());
      return _queries;
    });

    await tester.pumpSearchHistory(cubit);
    await cubit.getSearchQueries();
    verify(() => _repository.getSearchQueries()).called(1);
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
    await tester.tap(
      find.descendant(
        of: searchHistoryItemFinder,
        matching: find.byIcon(DropezyIcons.cross),
      ),
    );
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
    when(() => _repository.getSearchQueries()).thenAnswer((_) async => queries);
    when(() => _repository.clearSearchQueries()).thenAnswer((_) async => []);

    await tester.pumpSearchHistory(cubit);
    await cubit.getSearchQueries();
    verify(() => _repository.getSearchQueries()).called(1);
    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsOneWidget);

    // Clear search history
    await tester.tap(find.byIcon(DropezyIcons.trash));
    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsNothing);
  });

  /// Add Item
  testWidgets(
      'When search history item is added, '
      'ListView items get refreshed with item included',
      (WidgetTester tester) async {
    final _sampleQueries = queries.take(maxSearchHistory - 1).toList();
    const _addedQuery = 'meat';
    when(() => _repository.getSearchQueries())
        .thenAnswer((_) async => _sampleQueries);
    when(() => _repository.addSearchQuery(any()))
        .thenAnswer((invocation) async {
      final _queries = List.of(_sampleQueries);
      _queries.add(invocation.positionalArguments[0].toString());
      return _queries;
    });

    await tester.pumpSearchHistory(cubit);
    await cubit.getSearchQueries();
    verify(() => _repository.getSearchQueries()).called(1);
    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsOneWidget);

    var _queryWidgets = tester.widgetList(
      find.descendant(
        of: find.byType(ListView),
        matching: find.byType(SearchHistoryItem),
      ),
    );
    expect(_queryWidgets.length, _sampleQueries.length);

    await cubit.addSearchQuery(_addedQuery);
    await tester.pumpAndSettle();

    _queryWidgets = tester.widgetList(
      find.descendant(
        of: find.byType(ListView),
        matching: find.byType(SearchHistoryItem),
      ),
    );
    expect(_queryWidgets.length, _sampleQueries.length + 1);

    final searchHistoryItemFinder = find.byKey(
      ValueKey('${SearchHistoryKeys.searchHistoryItemKey}_$_addedQuery'),
    );
    expect(searchHistoryItemFinder, findsOneWidget);
    final searchHistoryItem =
        tester.firstWidget(searchHistoryItemFinder) as SearchHistoryItem;
    expect(searchHistoryItem.query, _addedQuery);
  });
}
