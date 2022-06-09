import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/discovery/index.dart';
import 'package:storefront_app/features/home/index.dart';
import 'package:storefront_app/features/product_search/index.dart';

import '../../../commons.dart';
import '../fixtures.dart';
import '../mocks.dart';

extension WidgetTesterX on WidgetTester {
  Future<void> pumpSearchPage(
    SearchInventoryBloc inventoryCubit,
    AutosuggestionBloc autosuggestionBloc,
    SearchHistoryCubit historyCubit,
    HomeNavCubit homeNavCubit,
    DiscoveryCubit discoveryCubit,
  ) async {
    await pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => inventoryCubit),
          BlocProvider(create: (context) => autosuggestionBloc),
          BlocProvider(create: (context) => historyCubit),
          BlocProvider(create: (context) => homeNavCubit),
          BlocProvider(create: (context) => discoveryCubit),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SearchPage(),
          ),
        ),
      ),
    );
  }
}

void main() {
  late SearchInventoryBloc searchInventoryCubit;
  late AutosuggestionBloc autosuggestionBloc;
  late SearchHistoryCubit historyCubit;
  late HomeNavCubit homeNavCubit;
  late DiscoveryCubit discoveryCubit;
  late ISearchHistoryRepository searchHistoryRepository;
  late IProductSearchRepository repository;

  const mockStoreId = 'store-id-1';

  setUp(() {
    repository = MockProductSearchRepository();

    // Search history
    searchHistoryRepository = MockSearchHistoryRepository();
    when(() => searchHistoryRepository.observeHistoryStream).thenAnswer(
      (_) => Stream.fromIterable([[]]),
    );

    discoveryCubit = MockDiscoveryCubit();
    when(() => discoveryCubit.state).thenReturn(mockStoreId);

    searchInventoryCubit = SearchInventoryBloc(
      repository,
      searchHistoryRepository,
    );
    autosuggestionBloc = AutosuggestionBloc(repository);
    historyCubit = SearchHistoryCubit(searchHistoryRepository);
    homeNavCubit = HomeNavCubit();
  });

  setUpAll(() {
    setUpLocaleInjection();
  });

  testWidgets('When Page State  is DEFAULT, show the Default Page',
      (WidgetTester tester) async {
    /// arrange
    await tester.pumpSearchPage(
      searchInventoryCubit,
      autosuggestionBloc,
      historyCubit,
      homeNavCubit,
      discoveryCubit,
    );

    await tester.pumpAndSettle();
    expect(find.byType(DefaultSearchPage), findsOneWidget);
  });

  testWidgets('When Page State is PRODUCT_SEARCH, show autosuggestions widget',
      (WidgetTester tester) async {
    /// arrange
    when(() => repository.getSearchSuggestions(any()))
        .thenAnswer((_) async => right(['bea']));

    when(
      () => repository.searchInventoryForItems(
        any(),
        any(),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => right(pageInventory));

    when(() => searchHistoryRepository.addSearchQuery(any()))
        .thenAnswer((_) async => ['bea']);

    await tester.pumpSearchPage(
      searchInventoryCubit,
      autosuggestionBloc,
      historyCubit,
      homeNavCubit,
      discoveryCubit,
    );

    await tester.pumpAndSettle();

    await tester.enterText(
      find.descendant(
        of: find.byType(SearchTextField),
        matching: find.byType(TextField),
      ),
      'query',
    );

    await tester.pumpAndSettle();

    expect(find.byType(SearchSuggestion), findsOneWidget);
  });

  testWidgets('When Page State is PRODUCT_SEARCH, show inventory list',
      (WidgetTester tester) async {
    /// arrange
    when(
      () => repository.getSearchSuggestions(
        any(),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => right(autosuggestions));

    when(() => searchHistoryRepository.addSearchQuery(any()))
        .thenAnswer((_) async => [_.positionalArguments.first.toString()]);

    when(
      () => repository.searchInventoryForItems(
        any(),
        any(),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => right(pageInventory));

    await tester.pumpSearchPage(
      searchInventoryCubit,
      autosuggestionBloc,
      historyCubit,
      homeNavCubit,
      discoveryCubit,
    );

    await tester.pumpAndSettle();

    const query = 'query';
    await tester.enterText(
      find.descendant(
        of: find.byType(SearchTextField),
        matching: find.byType(TextField),
      ),
      query,
    );

    await tester.runAsync(() async {
      await Future.delayed(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      verify(
        () => repository.searchInventoryForItems(
          query,
          any(),
          limit: any(named: 'limit'),
        ),
      ).called(1);

      await expectLater(find.byType(SearchResults), findsOneWidget);

      final _productWidgets = tester.widgetList(find.byType(ProductItemCard));
      expect(_productWidgets.length, pageInventory.length);
    });
  });
}
