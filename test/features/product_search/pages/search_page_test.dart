import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/home/index.dart';
import 'package:storefront_app/features/product_search/index.dart';

import '../../../../test_commons/fixtures/cart/cart_models.dart';
import '../../../commons.dart';
import '../../cart_checkout/mocks.dart';
import '../fixtures.dart';
import '../mocks.dart';

void main() {
  late SearchInventoryBloc searchInventoryCubit;
  late AutosuggestionBloc autosuggestionBloc;
  late SearchHistoryCubit historyCubit;
  late HomeNavCubit homeNavCubit;
  late ISearchHistoryRepository searchHistoryRepository;
  late IProductSearchRepository repository;
  late CartBloc cartBloc;

  setUp(() {
    repository = MockProductSearchRepository();

    // Search history
    searchHistoryRepository = MockSearchHistoryRepository();
    when(() => searchHistoryRepository.observeHistoryStream).thenAnswer(
      (_) => Stream.fromIterable([[]]),
    );

    searchInventoryCubit = SearchInventoryBloc(
      repository,
      searchHistoryRepository,
    );
    autosuggestionBloc = AutosuggestionBloc(repository);
    historyCubit = SearchHistoryCubit(searchHistoryRepository);
    homeNavCubit = HomeNavCubit();

    // Cart
    cartBloc = MockCartBloc();

    when(() => cartBloc.state)
        .thenAnswer((_) => CartLoaded.success(mockCartModel));
  });

  setUpAll(() {
    setUpLocaleInjection();
  });
  testWidgets(
    'should not display cart summary when isShowCartSummary is false',
    (WidgetTester tester) async {
      await tester.pumpSearchPage(
        searchInventoryCubit,
        autosuggestionBloc,
        historyCubit,
        homeNavCubit,
        cartBloc,
        isShowCartSummary: false,
      );

      expect(
        find.byType(CartSummary),
        findsNothing,
      );
    },
  );

  testWidgets(
    'should display cart summary when isShowCartSummary is true',
    (WidgetTester tester) async {
      await tester.pumpSearchPage(
        searchInventoryCubit,
        autosuggestionBloc,
        historyCubit,
        homeNavCubit,
        cartBloc,
      );

      expect(
        find.byType(CartSummary),
        findsOneWidget,
      );
    },
  );

  testWidgets('When Page State  is DEFAULT, show the Default Page',
      (WidgetTester tester) async {
    /// arrange
    await tester.pumpSearchPage(
      searchInventoryCubit,
      autosuggestionBloc,
      historyCubit,
      homeNavCubit,
      cartBloc,
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
      cartBloc,
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
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => right(pageInventory));

    await tester.pumpSearchPage(
      searchInventoryCubit,
      autosuggestionBloc,
      historyCubit,
      homeNavCubit,
      cartBloc,
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
          limit: any(named: 'limit'),
        ),
      ).called(1);

      await expectLater(find.byType(SearchResults), findsOneWidget);

      final _productWidgets = tester.widgetList(find.byType(ProductItemCard));
      expect(_productWidgets.length, pageInventory.length);
    });
  });
}

extension WidgetTesterX on WidgetTester {
  Future<void> pumpSearchPage(
    SearchInventoryBloc inventoryCubit,
    AutosuggestionBloc autosuggestionBloc,
    SearchHistoryCubit historyCubit,
    HomeNavCubit homeNavCubit,
    CartBloc cartBloc, {
    bool isShowCartSummary = true,
  }) async {
    await pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => inventoryCubit),
          BlocProvider(create: (context) => autosuggestionBloc),
          BlocProvider(create: (context) => historyCubit),
          BlocProvider(create: (context) => homeNavCubit),
          BlocProvider(create: (context) => cartBloc),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: SearchPage(isShowCartSummary: isShowCartSummary),
          ),
        ),
      ),
    );
  }
}
