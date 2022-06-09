import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/index.dart';
import 'package:storefront_app/features/permission_handler/index.dart';

import '../../../../../test_commons/fixtures/address/delivery_address_models.dart';
import '../../../../commons.dart';
import '../../../../src/mock_navigator.dart';
import '../../mocks.dart';

void main() {
  setUpAll(() {
    setUpLocaleInjection();
  });

  group('ChangeAddressPage', () {
    late StackRouter stackRouter;
    late DeliveryAddressCubit deliveryAddressCubit;
    late PermissionHandlerCubit permissionHandlerCubit;

    const expectedNewAddressIndex = 1;

    setUp(() {
      stackRouter = MockStackRouter();
      deliveryAddressCubit = MockDeliveryAddressCubit();
      permissionHandlerCubit = MockPermissionHandlerCubit();

      // Default state
      when(() => deliveryAddressCubit.state).thenReturn(
        DeliveryAddressLoaded(
          addressList: sampleDeliveryAddressList,
          activeAddress: sampleDeliveryAddressList[0],
        ),
      );
      when(() => permissionHandlerCubit.state)
          .thenReturn(const PermissionDenied());

      // if not stubbed, this will throw an UnimplementedError when called
      // here, we stub it to do nothing because we're only checking for the
      // route name that's being pushed
      when(() => stackRouter.push(any())).thenAnswer((_) async => null);
    });

    setUpAll(() {
      registerFallbackValue(FakePageRouteInfo());
    });

    testWidgets(
      'should display AddressLoadingView '
      'when state is DeliveryAddressLoading',
      (tester) async {
        when(() => deliveryAddressCubit.state)
            .thenReturn(const DeliveryAddressLoading());

        await tester.pumpChangeAddressPage(
          stackRouter: stackRouter,
          deliveryAddressCubit: deliveryAddressCubit,
          permissionHandlerCubit: permissionHandlerCubit,
        );

        expect(find.byType(AddressLoadingView), findsOneWidget);
      },
    );

    testWidgets(
      'should display AddressEmptyView '
      'when state is DeliveryAddressLoadedEmpty',
      (tester) async {
        when(() => deliveryAddressCubit.state)
            .thenReturn(const DeliveryAddressLoadedEmpty());

        final context = await tester.pumpChangeAddressPage(
          stackRouter: stackRouter,
          deliveryAddressCubit: deliveryAddressCubit,
          permissionHandlerCubit: permissionHandlerCubit,
        );

        expect(find.text(context.res.strings.addressEmpty), findsOneWidget);
        expect(find.byType(AddressEmptyView), findsOneWidget);
      },
    );

    testWidgets(
      'should display Address list view '
      'and show correct number of items '
      'when state is DeliveryAddressLoaded',
      (tester) async {
        await tester.pumpChangeAddressPage(
          stackRouter: stackRouter,
          deliveryAddressCubit: deliveryAddressCubit,
          permissionHandlerCubit: permissionHandlerCubit,
        );

        expect(find.byType(ListView), findsOneWidget);
        expect(
          find.byType(AddressCard),
          findsNWidgets(sampleDeliveryAddressList.length),
        );
        expect(find.byType(DropezyChip), findsOneWidget);
      },
    );

    testWidgets(
      'should set active address to selected index '
      'when Address Card is tapped',
      (tester) async {
        await tester.pumpChangeAddressPage(
          stackRouter: stackRouter,
          deliveryAddressCubit: deliveryAddressCubit,
          permissionHandlerCubit: permissionHandlerCubit,
        );

        expect(find.byType(ListView), findsOneWidget);

        await tester.tap(find.byType(AddressCard).at(expectedNewAddressIndex));

        verify(
          () => deliveryAddressCubit.setActiveAddress(
            sampleDeliveryAddressList[expectedNewAddressIndex],
          ),
        ).called(1);
      },
    );

    testWidgets(
      'should display snack bar '
      'when active address is updated',
      (tester) async {
        whenListen(
          deliveryAddressCubit,
          Stream.fromIterable([
            DeliveryAddressLoaded(
              addressList: sampleDeliveryAddressList,
              activeAddress: sampleDeliveryAddressList[expectedNewAddressIndex],
            ),
          ]),
        );

        final context = await tester.pumpChangeAddressPage(
          stackRouter: stackRouter,
          deliveryAddressCubit: deliveryAddressCubit,
          permissionHandlerCubit: permissionHandlerCubit,
        );

        expect(find.byType(ListView), findsOneWidget);

        await tester.tap(find.byType(AddressCard).at(expectedNewAddressIndex));
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        final newActiveAddress =
            sampleDeliveryAddressList[expectedNewAddressIndex];
        expect(
          find.text(
            context.res.strings
                .updatedAddressSnackBarContent(newActiveAddress.title),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should do nothing '
      'when Address Card is tapped '
      'and address already active',
      (tester) async {
        const activeAddressIndex = 0;
        when(() => deliveryAddressCubit.state).thenReturn(
          DeliveryAddressLoaded(
            addressList: sampleDeliveryAddressList,
            activeAddress: sampleDeliveryAddressList[activeAddressIndex],
          ),
        );
        whenListen(
          deliveryAddressCubit,
          Stream.fromIterable([
            DeliveryAddressLoaded(
              addressList: sampleDeliveryAddressList,
              activeAddress: sampleDeliveryAddressList[activeAddressIndex],
            ),
          ]),
        );

        await tester.pumpChangeAddressPage(
          stackRouter: stackRouter,
          deliveryAddressCubit: deliveryAddressCubit,
          permissionHandlerCubit: permissionHandlerCubit,
        );

        expect(find.byType(ListView), findsOneWidget);

        await tester.tap(find.byType(AddressCard).at(activeAddressIndex));
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsNothing);
        verifyNever(
          () => deliveryAddressCubit
              .setActiveAddress(sampleDeliveryAddressList[activeAddressIndex]),
        );
      },
    );

    testWidgets(
      'should request location permission '
      'when add address button is tapped',
      (tester) async {
        const locationPermission = Permission.location;
        when(() => permissionHandlerCubit.requestPermission(locationPermission))
            .thenAnswer((_) => Future.value());

        await tester.pumpChangeAddressPage(
          stackRouter: stackRouter,
          deliveryAddressCubit: deliveryAddressCubit,
          permissionHandlerCubit: permissionHandlerCubit,
        );

        await tester.tap(find.byKey(ChangeAddressPageKeys.addAddressButton));

        verify(
          () => permissionHandlerCubit.requestPermission(locationPermission),
        ).called(1);
      },
    );

    group(
      'Permission Handler',
      () {
        testWidgets(
          'should navigate to SearchLocationPage '
          'when permission is granted',
          (tester) async {
            whenListen(
              permissionHandlerCubit,
              Stream.fromIterable([
                const PermissionGranted(),
              ]),
            );

            await tester.pumpChangeAddressPage(
              stackRouter: stackRouter,
              deliveryAddressCubit: deliveryAddressCubit,
              permissionHandlerCubit: permissionHandlerCubit,
            );

            final capturedRoutes =
                verify(() => stackRouter.push(captureAny())).captured;

            // there should only be one route that's being pushed
            expect(capturedRoutes.length, 1);

            final routeInfo = capturedRoutes.first as PageRouteInfo;

            // expecting the right route being pushed
            expect(routeInfo, isA<SearchLocationRoute>());
          },
        );

        testWidgets(
          'should show snack bar '
          'when permission is denied',
          (tester) async {
            whenListen(
              permissionHandlerCubit,
              Stream.fromIterable([
                const PermissionDenied(),
              ]),
            );

            final context = await tester.pumpChangeAddressPage(
              stackRouter: stackRouter,
              deliveryAddressCubit: deliveryAddressCubit,
              permissionHandlerCubit: permissionHandlerCubit,
            );
            await tester.pumpAndSettle();

            expect(find.byType(SnackBar), findsOneWidget);
            expect(
              find.text(
                context.res.strings.locationAccessRationale,
              ),
              findsOneWidget,
            );
          },
        );

        testWidgets(
          'should navigate to RequestLocationAccessPage '
          'when permission is permanently denied',
          (tester) async {
            whenListen(
              permissionHandlerCubit,
              Stream.fromIterable([
                const PermissionPermanentlyDenied(),
              ]),
            );

            await tester.pumpChangeAddressPage(
              stackRouter: stackRouter,
              deliveryAddressCubit: deliveryAddressCubit,
              permissionHandlerCubit: permissionHandlerCubit,
            );

            final capturedRoutes =
                verify(() => stackRouter.push(captureAny())).captured;

            // there should only be one route that's being pushed
            expect(capturedRoutes.length, 1);

            final routeInfo = capturedRoutes.first as PageRouteInfo;

            // expecting the right route being pushed
            expect(routeInfo, isA<RequestLocationAccessRoute>());
          },
        );
      },
    );
  });
}

extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpChangeAddressPage({
    required StackRouter stackRouter,
    required DeliveryAddressCubit deliveryAddressCubit,
    required PermissionHandlerCubit permissionHandlerCubit,
  }) async {
    late BuildContext ctx;

    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              ctx = context;
              return StackRouterScope(
                controller: stackRouter,
                stateHash: 0,
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider<DeliveryAddressCubit>.value(
                      value: deliveryAddressCubit,
                    ),
                    BlocProvider<PermissionHandlerCubit>.value(
                      value: permissionHandlerCubit,
                    ),
                  ],
                  child: const ChangeAddressPage(),
                ),
              );
            },
          ),
        ),
      ),
    );

    return ctx;
  }
}
