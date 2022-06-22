import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:storefront_app/core/app_router.gr.dart';
import 'package:storefront_app/features/address/index.dart';
import 'package:storefront_app/features/permission_handler/bloc/permission_handler_cubit.dart';

import '../../../../../test_commons/fixtures/address/places_auto_complete_result.dart';
import '../../../../commons.dart';
import '../../../../src/mock_navigator.dart';
import '../../mocks.dart';

void main() {
  late StackRouter stackRouter;
  late SearchLocationBloc searchLocationBloc;
  late SearchLocationHistoryBloc searchLocationHistoryBloc;
  late PermissionHandlerCubit permissionCubit;

  const locationPermission = Permission.location;
  const latLng = LatLng(-6.1754463, 106.8377065);

  setUp(() {
    stackRouter = MockStackRouter();
    searchLocationBloc = MockSearchLocationBloc();
    searchLocationHistoryBloc = MockSearchLocationHistoryBloc();
    permissionCubit = MockPermissionHandlerCubit();

    // default state
    when(() => searchLocationBloc.state)
        .thenReturn(const SearchLocationInitial());
    when(() => searchLocationHistoryBloc.state)
        .thenReturn(const SearchLocationHistoryLoading());
    when(() => permissionCubit.state).thenReturn(const PermissionDenied());
    when(() => permissionCubit.requestPermission(locationPermission))
        .thenAnswer((_) => Future.value());

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
        permissionHandlerCubit: permissionCubit,
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
        permissionHandlerCubit: permissionCubit,
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
        permissionHandlerCubit: permissionCubit,
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
        permissionHandlerCubit: permissionCubit,
      );

      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text('Error'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should request location permission '
    'when use current location button is pressed ',
    (tester) async {
      await tester.pumpSearchLocationPage(
        stackRouter: stackRouter,
        bloc: searchLocationBloc,
        historyBloc: searchLocationHistoryBloc,
        permissionHandlerCubit: permissionCubit,
      );

      await tester
          .tap(find.byKey(SearchLocationPageKeys.useCurrentLocationButton));
      await tester.pumpAndSettle();

      verify(
        () => searchLocationBloc.add(
          const RequestLocationPermission(
            SearchLocationAction.useCurrentLocation,
          ),
        ),
      ).called(1);
    },
  );

  testWidgets(
    'should request location permission '
    'when view map button is pressed ',
    (tester) async {
      await tester.pumpSearchLocationPage(
        stackRouter: stackRouter,
        bloc: searchLocationBloc,
        historyBloc: searchLocationHistoryBloc,
        permissionHandlerCubit: permissionCubit,
      );

      await tester.tap(find.byKey(SearchLocationPageKeys.viewMapChip));
      await tester.pumpAndSettle();

      verify(
        () => searchLocationBloc.add(
          const RequestLocationPermission(
            SearchLocationAction.viewMap,
          ),
        ),
      ).called(1);
    },
  );

  testWidgets(
    'should navigate to AddressPinpointPage '
    'and then AddressDetailPage '
    'when state is OnViewMap '
    'and route return address',
    (tester) async {
      whenListen(
        searchLocationBloc,
        Stream.fromIterable([
          const OnViewMap(latLng),
        ]),
      );
      when(() => stackRouter.push(AddressPinpointRoute(cameraTarget: latLng)))
          .thenAnswer((_) async => placeDetails);

      await tester.pumpSearchLocationPage(
        stackRouter: stackRouter,
        bloc: searchLocationBloc,
        historyBloc: searchLocationHistoryBloc,
        permissionHandlerCubit: permissionCubit,
      );

      final capturedRoutes =
          verify(() => stackRouter.push(captureAny())).captured;

      final routeInfo = capturedRoutes.last as PageRouteInfo;

      // expecting the right route being pushed
      expect(routeInfo, isA<AddressDetailRoute>());
    },
  );

  testWidgets(
    'should navigate to AddressPinpointPage '
    'when state is OnViewMap '
    'and route return null',
    (tester) async {
      whenListen(
        searchLocationBloc,
        Stream.fromIterable([
          const OnViewMap(latLng),
        ]),
      );
      when(() => stackRouter.push(AddressPinpointRoute(cameraTarget: latLng)))
          .thenAnswer((_) async => null);

      await tester.pumpSearchLocationPage(
        stackRouter: stackRouter,
        bloc: searchLocationBloc,
        historyBloc: searchLocationHistoryBloc,
        permissionHandlerCubit: permissionCubit,
      );

      final capturedRoutes =
          verify(() => stackRouter.push(captureAny())).captured;

      final routeInfo = capturedRoutes.last as PageRouteInfo;

      // expecting the right route being pushed
      expect(routeInfo, isA<AddressPinpointRoute>());
    },
  );

  group('location permission handler', () {
    testWidgets(
      'should add UseCurrentLocation to bloc '
      'when permission is granted '
      'and action is useCurrentLocation',
      (tester) async {
        whenListen(
          searchLocationBloc,
          Stream.fromIterable([
            const OnRequestPermission(SearchLocationAction.useCurrentLocation),
          ]),
        );
        whenListen(
          permissionCubit,
          Stream.fromIterable([
            const PermissionGranted(),
          ]),
        );

        await tester.pumpSearchLocationPage(
          stackRouter: stackRouter,
          bloc: searchLocationBloc,
          historyBloc: searchLocationHistoryBloc,
          permissionHandlerCubit: permissionCubit,
        );

        await tester.pump();

        verify(() => searchLocationBloc.add(const UseCurrentLocation()))
            .called(1);
      },
    );

    testWidgets(
      'should add ViewMap to bloc '
      'when permission is granted '
      'and action is viewMap',
      (tester) async {
        whenListen(
          searchLocationBloc,
          Stream.fromIterable([
            const OnRequestPermission(SearchLocationAction.viewMap),
          ]),
        );
        whenListen(
          permissionCubit,
          Stream.fromIterable([
            const PermissionGranted(),
          ]),
        );

        await tester.pumpSearchLocationPage(
          stackRouter: stackRouter,
          bloc: searchLocationBloc,
          historyBloc: searchLocationHistoryBloc,
          permissionHandlerCubit: permissionCubit,
        );

        await tester.pump();

        verify(() => searchLocationBloc.add(const ViewMap())).called(1);
      },
    );

    testWidgets(
      'should open RequestLocationBottomSheet '
      'when permission is denied',
      (tester) async {
        whenListen(
          permissionCubit,
          Stream.fromIterable([
            const PermissionDenied(),
          ]),
        );

        await tester.pumpSearchLocationPage(
          stackRouter: stackRouter,
          bloc: searchLocationBloc,
          historyBloc: searchLocationHistoryBloc,
          permissionHandlerCubit: permissionCubit,
        );

        await tester.pumpAndSettle();

        expect(find.byType(RequestLocationBottomSheet), findsOneWidget);
      },
    );

    testWidgets(
      'should open RequestLocationBottomSheet '
      'when permission is permanently denied',
      (tester) async {
        whenListen(
          permissionCubit,
          Stream.fromIterable([
            const PermissionPermanentlyDenied(),
          ]),
        );

        await tester.pumpSearchLocationPage(
          stackRouter: stackRouter,
          bloc: searchLocationBloc,
          historyBloc: searchLocationHistoryBloc,
          permissionHandlerCubit: permissionCubit,
        );

        await tester.pumpAndSettle();

        expect(find.byType(RequestLocationBottomSheet), findsOneWidget);
      },
    );
  });

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
          permissionHandlerCubit: permissionCubit,
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
          permissionHandlerCubit: permissionCubit,
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
    required PermissionHandlerCubit permissionHandlerCubit,
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
                    BlocProvider.value(
                      value: permissionHandlerCubit,
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
