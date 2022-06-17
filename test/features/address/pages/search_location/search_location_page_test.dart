import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/app_router.gr.dart';
import 'package:storefront_app/features/address/index.dart';

import '../../../../../test_commons/fixtures/address/places_auto_complete_result.dart';
import '../../../../commons.dart';
import '../../../../src/mock_navigator.dart';
import '../../mocks.dart';

void main() {
  late StackRouter stackRouter;
  late SearchLocationBloc searchLocationBloc;
  late SearchLocationHistoryBloc searchLocationHistoryBloc;

  setUp(() {
    stackRouter = MockStackRouter();
    searchLocationBloc = MockSearchLocationBloc();
    searchLocationHistoryBloc = MockSearchLocationHistoryBloc();

    // default state
    when(() => searchLocationBloc.state)
        .thenReturn(const SearchLocationInitial());
    when(() => searchLocationHistoryBloc.state)
        .thenReturn(const SearchLocationHistoryLoading());

    // if not stubbed, this will throw an UnimplementedError when called
    // here, we stub it to do nothing because we're only checking for the
    // route name that's being pushed
    when(() => stackRouter.push(any())).thenAnswer((_) async => null);
    when(() => stackRouter.popAndPush(any())).thenAnswer((_) async => null);
  });

  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());
  });

  setUpAll(() {
    setUpLocaleInjection();
  });

  testWidgets(
    'should display view correctly '
    'when page is rendered',
    (tester) async {
      await tester.pumpSearchLocationPage(
        bloc: searchLocationBloc,
        stackRouter: stackRouter,
        historyBloc: searchLocationHistoryBloc,
      );

      expect(find.byType(SearchLocationHeader), findsOneWidget);
      expect(find.byType(SearchLocationResult), findsOneWidget);
    },
  );

  testWidgets(
    'should display list of places '
    'when state is loaded',
    (tester) async {
      when(() => searchLocationBloc.state)
          .thenReturn(SearchLocationLoaded(placesResultList));

      await tester.pumpSearchLocationPage(
        bloc: searchLocationBloc,
        stackRouter: stackRouter,
        historyBloc: searchLocationHistoryBloc,
      );

      expect(find.byType(SearchLocationHeader), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(
        find.byType(PlaceSuggestionTile),
        findsNWidgets(placesResultList.length),
      );
    },
  );

  testWidgets(
    'should navigate to AddressDetailPage '
    'when LocationSelectSuccess',
    (tester) async {
      whenListen(
        searchLocationBloc,
        Stream.fromIterable([
          LocationSelectSuccess(placeDetails),
        ]),
      );

      await tester.pumpSearchLocationPage(
        stackRouter: stackRouter,
        bloc: searchLocationBloc,
        historyBloc: searchLocationHistoryBloc,
      );

      final capturedRoutes =
          verify(() => stackRouter.popAndPush(captureAny())).captured;

      // there should only be one route that's being pushed
      expect(capturedRoutes.length, 1);

      final routeInfo = capturedRoutes.first as PageRouteInfo;

      // expecting the right route being pushed
      expect(routeInfo, isA<AddressDetailRoute>());

      // expecting args
      final args = routeInfo.args as AddressDetailRouteArgs;
      expect(args.placeDetails, placeDetails);
    },
  );

  testWidgets(
    'should show snack bar '
    'when LocationSelectError',
    (tester) async {
      whenListen(
        searchLocationBloc,
        Stream.fromIterable([
          const LocationSelectError('Error'),
        ]),
      );

      await tester.pumpSearchLocationPage(
        stackRouter: stackRouter,
        bloc: searchLocationBloc,
        historyBloc: searchLocationHistoryBloc,
      );

      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text('Error'),
        findsOneWidget,
      );
    },
  );

  group('search location history', () {
    final placeModelList = placesResultList
        .map((place) => PlaceModel.fromPlacesService(place))
        .toList();

    testWidgets(
      'should add LoadSearchLocationHistory to SearchLocationHistoryBloc '
      'when state is SearchLocationInitial',
      (tester) async {
        whenListen(
          searchLocationBloc,
          Stream.fromIterable([
            const SearchLocationInitial(),
          ]),
        );

        await tester.pumpSearchLocationPage(
          stackRouter: stackRouter,
          bloc: searchLocationBloc,
          historyBloc: searchLocationHistoryBloc,
        );

        await tester.pump();

        verify(
          () =>
              searchLocationHistoryBloc.add(const LoadSearchLocationHistory()),
        ).called(1);
      },
    );

    testWidgets(
      'should display SearchHistoryList '
      'when state is SearchLocationInitial',
      (tester) async {
        when(() => searchLocationBloc.state)
            .thenReturn(const SearchLocationInitial());
        when(() => searchLocationHistoryBloc.state)
            .thenReturn(SearchLocationHistoryLoaded(placeModelList));

        await tester.pumpSearchLocationPage(
          stackRouter: stackRouter,
          bloc: searchLocationBloc,
          historyBloc: searchLocationHistoryBloc,
        );

        await tester.pump();

        expect(find.byType(SearchLocationHistoryList), findsOneWidget);
      },
    );
  });
}

extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpSearchLocationPage({
    required StackRouter stackRouter,
    required SearchLocationBloc bloc,
    required SearchLocationHistoryBloc historyBloc,
  }) async {
    late BuildContext ctx;

    await pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            ctx = context;
            return StackRouterScope(
              controller: stackRouter,
              stateHash: 0,
              child: Scaffold(
                body: MultiBlocProvider(
                  providers: [
                    BlocProvider.value(
                      value: bloc,
                    ),
                    BlocProvider.value(
                      value: historyBloc,
                    ),
                  ],
                  child: const SearchLocationPage(),
                ),
              ),
            );
          },
        ),
      ),
    );

    return ctx;
  }
}
