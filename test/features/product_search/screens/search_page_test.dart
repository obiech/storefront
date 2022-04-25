import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/home/index.dart';
import 'package:storefront_app/features/product_search/index.dart';

import '../fixtures.dart';
import '../mocks.dart';

extension WidgetTesterX on WidgetTester {
  Future<void> pumpSearchPage(
    SearchInventoryCubit inventoryCubit,
    AutosuggestionBloc autosuggestionBloc,
    SearchHistoryCubit historyCubit,
    HomeNavCubit homeNavCubit,
  ) async {
    await pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => inventoryCubit),
          BlocProvider(create: (context) => autosuggestionBloc),
          BlocProvider(create: (context) => historyCubit),
          BlocProvider(create: (context) => homeNavCubit),
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
  late SearchInventoryCubit searchInventoryCubit;
  late AutosuggestionBloc autosuggestionBloc;
  late SearchHistoryCubit historyCubit;
  late HomeNavCubit homeNavCubit;
  late ISearchHistoryRepository searchHistoryRepository;
  late IProductSearchRepository repository;

  setUp(() {
    repository = MockProductSearchRepository();
    searchHistoryRepository = MockSearchHistoryRepository();
    searchInventoryCubit = SearchInventoryCubit(repository);
    autosuggestionBloc = AutosuggestionBloc(repository);
    historyCubit = SearchHistoryCubit(searchHistoryRepository);
    homeNavCubit = HomeNavCubit();
  });

  testWidgets('When Page State  is DEFAULT, show the Default Page',
      (WidgetTester tester) async {
    /// arrange
    await tester.pumpSearchPage(
      searchInventoryCubit,
      autosuggestionBloc,
      historyCubit,
      homeNavCubit,
    );

    await tester.pumpAndSettle();
    expect(find.byType(DefaultSearchPage), findsOneWidget);
  });

  testWidgets('When Page State is PRODUCT_SEARCH, show autosuggestions widget',
      (WidgetTester tester) async {
    /// arrange
    await tester.pumpSearchPage(
      searchInventoryCubit,
      autosuggestionBloc,
      historyCubit,
      homeNavCubit,
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
    when(() => repository.getSearchSuggestions(any()))
        .thenAnswer((_) async => autosuggestions);
    when(() => searchHistoryRepository.addSearchQuery(any()))
        .thenAnswer((_) async => [_.positionalArguments.first.toString()]);
    when(() => repository.searchInventoryForItems(any()))
        .thenAnswer((_) async => pageInventory);

    await tester.pumpSearchPage(
      searchInventoryCubit,
      autosuggestionBloc,
      historyCubit,
      homeNavCubit,
    );

    await tester.pumpAndSettle();

    await tester.enterText(
      find.descendant(
        of: find.byType(SearchTextField),
        matching: find.byType(TextField),
      ),
      'query',
    );

    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(find.byType(SearchResults), findsOneWidget);

    final _productWidgets = tester.widgetList(find.byType(ProductItemCard));
    expect(_productWidgets.length, pageInventory.length);
  });
}
