import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/auth/domain/domain.dart';
import 'package:storefront_app/features/auth/domain/services/user_credentials_storage.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/discovery/index.dart';
import 'package:storefront_app/features/home/index.dart';
import 'package:storefront_app/features/product_search/index.dart';
import 'package:storefront_app/features/profile/pages/profile_page.dart';

import '../../../../test_commons/fixtures/cart/cart_models.dart';
import '../../../src/mock_customer_service_client.dart';
import '../mocks.dart';
import 'main_page_finder.dart';

/// Helper functions specific to this test
extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpMainPage({
    required AppRouter router,
    required CartBloc cartBloc,
    required HomeNavCubit homeNavCubit,
    required SearchInventoryBloc searchInventoryBloc,
    required SearchHistoryCubit searchHistoryCubit,
    required DiscoveryCubit discoveryCubit,
  }) async {
    late BuildContext ctx;

    await pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => cartBloc,
          ),
          BlocProvider(
            create: (context) => homeNavCubit,
          ),
          BlocProvider(
            create: (context) => searchInventoryBloc,
          ),
          BlocProvider(
            create: (context) => searchHistoryCubit,
          ),
          BlocProvider(
            create: (context) => discoveryCubit,
          ),
        ],
        child: MaterialApp.router(
          routerDelegate: router.delegate(),
          routeInformationParser: router.defaultRouteParser(),
          builder: (context, child) {
            ctx = context;
            return child!;
          },
        ),
      ),
    );

    return ctx;
  }
}

void main() {
  late AppRouter router;
  late CartBloc cartBloc;
  late HomeNavCubit homeNavCubit;
  late SearchInventoryBloc searchInventoryBloc;
  late SearchHistoryCubit searchHistoryCubit;
  late DiscoveryCubit discoveryCubit;

  setUp(() {
    final prefs = MockIPrefsRepository();
    router = AppRouter(
      checkAuthStatus: CheckAuthStatus(prefs),
      checkOrderStatus: CheckOrderStatus(),
    );

    cartBloc = MockCartBloc();
    homeNavCubit = MockHomeNavCubit();
    searchInventoryBloc = MockSearchInventoryBloc();
    searchHistoryCubit = MockSearchHistoryCubit();
    discoveryCubit = MockDiscoveryCubit();

    late UserCredentialsStorage userCredsStorage;
    late ParentCategoriesCubit parentCategoriesCubit;

    when(() => cartBloc.state)
        .thenAnswer((_) => CartLoaded.success(mockCartModel));

    when(() => searchInventoryBloc.state).thenReturn(SearchInventoryInitial());
    whenListen(
      searchInventoryBloc,
      const Stream<SearchInventoryState>.empty(),
    );
    when(() => searchInventoryBloc.close()).thenAnswer((_) async {});

    when(() => homeNavCubit.state)
        .thenReturn(const HomeNavState(PageState.NOTHING, ''));

    when(() => searchHistoryCubit.state).thenReturn(SearchHistoryInitial());
    whenListen(
      searchHistoryCubit,
      const Stream<SearchHistoryState>.empty(),
    );
    when(() => searchHistoryCubit.close()).thenAnswer((_) async {});

    userCredsStorage = MockUserCredentialsStorage();

    when(() => prefs.isOnBoarded()).thenAnswer((invocation) => true);
    when(() => prefs.getDeviceLocale())
        .thenAnswer((invocation) => const Locale('en', 'EN'));

    parentCategoriesCubit = MockParentCategoriesCubit();
    when(() => parentCategoriesCubit.fetchParentCategories())
        .thenAnswer((_) async => []);
    whenListen(
      parentCategoriesCubit,
      const Stream<ParentCategoriesState>.empty(),
    );

    when(() => parentCategoriesCubit.close()).thenAnswer((_) async {});

    when(() => parentCategoriesCubit.state)
        .thenReturn(InitialParentCategoriesState());

    userCredsStorage = MockUserCredentialsStorage();
    when(() => userCredsStorage.stream).thenAnswer((_) => const Stream.empty());

    if (GetIt.I.isRegistered<UserCredentialsStorage>()) {
      GetIt.I.unregister<UserCredentialsStorage>();
    }

    GetIt.I.registerSingleton<UserCredentialsStorage>(userCredsStorage);

    if (GetIt.I.isRegistered<ParentCategoriesCubit>()) {
      GetIt.I.unregister<ParentCategoriesCubit>();
    }

    GetIt.I.registerSingleton<ParentCategoriesCubit>(parentCategoriesCubit);

    if (GetIt.I.isRegistered<HomeNavObserver>()) {
      GetIt.I.unregister<HomeNavObserver>();
    }

    GetIt.instance
        .registerSingleton<HomeNavObserver>(HomeNavObserver(HomeNavCubit()));

    if (!GetIt.I.isRegistered<IPrefsRepository>()) {
      GetIt.I.registerSingleton<IPrefsRepository>(prefs);
    }
  });

  testWidgets(
    'should display a floating cart summary '
    'when tabs show HomePage',
    (tester) async {
      final context = await tester.pumpMainPage(
        cartBloc: cartBloc,
        router: router,
        searchInventoryBloc: searchInventoryBloc,
        searchHistoryCubit: searchHistoryCubit,
        homeNavCubit: homeNavCubit,
        discoveryCubit: discoveryCubit,
      );

      await tester.pumpAndSettle();
      //Tap on Home Tab
      await tester.tap(find.text(context.res.strings.home));
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
      expect(MainPageFinders.cartSummary, findsOneWidget);
    },
  );

  testWidgets(
    'should display a floating cart summary '
    'when tabs show SearchPage',
    (tester) async {
      final context = await tester.pumpMainPage(
        cartBloc: cartBloc,
        router: router,
        searchInventoryBloc: searchInventoryBloc,
        searchHistoryCubit: searchHistoryCubit,
        homeNavCubit: homeNavCubit,
        discoveryCubit: discoveryCubit,
      );

      await tester.pumpAndSettle();
      //Tap on Search Tab
      await tester.tap(find.text(context.res.strings.search));
      await tester.pumpAndSettle();
      expect(find.byType(SearchPage), findsOneWidget);
      expect(MainPageFinders.cartSummary, findsOneWidget);
    },
  );

  testWidgets(
    'should not display a floating cart summary '
    'when tabs show ProfilePage',
    (tester) async {
      final context = await tester.pumpMainPage(
        cartBloc: cartBloc,
        router: router,
        searchInventoryBloc: searchInventoryBloc,
        searchHistoryCubit: searchHistoryCubit,
        homeNavCubit: homeNavCubit,
        discoveryCubit: discoveryCubit,
      );

      await tester.pumpAndSettle();
      //Tap on Profile Tab
      await tester.tap(find.text(context.res.strings.profile));
      await tester.pumpAndSettle();
      expect(find.byType(ProfilePage), findsOneWidget);
      expect(MainPageFinders.cartSummary, findsNothing);
    },
  );
}
