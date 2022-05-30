import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/index.dart';
import 'package:storefront_app/features/home/widgets/address_selection_bottom_sheet/address_selection_bottom_sheet.dart';

import '../../../../../test_commons/fixtures/address/delivery_address_models.dart';
import '../../../../src/mock_navigator.dart';
import '../../mocks.dart';

extension WidgetTesterX on WidgetTester {
  Future<void> pumpAddressSelection({
    required DeliveryAddressCubit cubit,
    required DeliveryAddressState currentState,
    required StackRouter router,
  }) async {
    when(() => cubit.state).thenReturn(currentState);
    whenListen(
      cubit,
      Stream.fromIterable(
        [
          const DeliveryAddressInitial(),
          currentState,
        ],
      ),
    );
    when(() => cubit.close()).thenAnswer((_) async {});

    await pumpWidget(
      MaterialApp(
        home: StackRouterScope(
          stateHash: 0,
          controller: router,
          child: Scaffold(
            body: BlocProvider<DeliveryAddressCubit>(
              create: (_) => cubit,
              child: const AddressSelectionBottomSheet(),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  late StackRouter router;
  late DeliveryAddressCubit cubit;
  const activeAddressIndex = 0;

  final state = DeliveryAddressLoaded(
    addressList: sampleDeliveryAddressList,
    activeAddress: sampleDeliveryAddressList[activeAddressIndex],
  );

  setUp(() {
    cubit = MockDeliveryAddressCubit();

    router = MockStackRouter();
    registerFallbackValue(FakePageRouteInfo());
    when(() => router.push(any())).thenAnswer((_) async => null);
  });

  testWidgets(
    'should display address list and active address '
    'when status is Loaded including active and inactive '
    'Radio Icon',
    (tester) async {
      await tester.pumpAddressSelection(
        cubit: cubit,
        currentState: state,
        router: router,
      );

      // Address List
      expect(find.byType(ListView), findsOneWidget);

      for (int index = 0; index < state.addressList.length; index++) {
        final formattedAddress =
            state.addressList[index].details?.toPrettyAddress;

        expect(find.text(state.addressList[index].title), findsOneWidget);
        expect(find.text(formattedAddress.toString()), findsOneWidget);
      }

      // Active address
      final formattedAddress = state.activeAddress.details?.toPrettyAddress;
      expect(find.text(state.activeAddress.title), findsOneWidget);
      expect(find.text(formattedAddress.toString()), findsOneWidget);

      // Inactive radio icon
      expect(
        find.byWidgetPredicate(
          (widget) => widget is RadioIcon && widget.active == false,
        ),
        findsNWidgets(state.addressList.length - 1),
      );

      // Active radio icon
      expect(
        find.byWidgetPredicate(
          (widget) => widget is RadioIcon && widget.active,
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should display error message when status is error',
    (tester) async {
      const state = DeliveryAddressError('Unknown error');

      when(() => cubit.state).thenReturn(state);
      whenListen(
        cubit,
        Stream.fromIterable(
          [
            const DeliveryAddressInitial(),
            state,
          ],
        ),
      );

      await tester.pumpAddressSelection(
        cubit: cubit,
        currentState: state,
        router: router,
      );

      expect(find.text(state.message), findsOneWidget);
    },
  );

  testWidgets(
    'should do nothing '
    'when active address is tapped',
    (tester) async {
      await tester.pumpAddressSelection(
        cubit: cubit,
        currentState: state,
        router: router,
      );

      expect(find.byType(ListView), findsOneWidget);

      await tester.tap(find.byType(ListTile).at(activeAddressIndex));
      await tester.pumpAndSettle();

      verifyNever(
        () => cubit
            .setActiveAddress(sampleDeliveryAddressList[activeAddressIndex]),
      );
    },
  );

  testWidgets(
    'should move to [AddressDetailPage] '
    'when [AddAddress] is tapped',
    (tester) async {
      await tester.pumpAddressSelection(
        cubit: cubit,
        currentState: state,
        router: router,
      );

      await tester.tap(find.byType(AddAddress));
      await tester.pumpAndSettle();

      final capturedRoutes = verify(() => router.push(captureAny())).captured;
      expect(capturedRoutes.length, 1);

      final routeInfo = capturedRoutes.first as PageRouteInfo;
      expect(routeInfo, isA<AddressDetailRoute>());
    },
  );

  testWidgets(
    'should set active address to selected index '
    'when Address List Tile is tapped',
    (tester) async {
      await tester.pumpAddressSelection(
        cubit: cubit,
        currentState: state,
        router: router,
      );

      expect(find.byType(ListView), findsOneWidget);

      await tester.tap(find.byType(ListTile).at(1));
      await tester.pumpAndSettle();

      verify(
        () => cubit.setActiveAddress(
          sampleDeliveryAddressList[1],
        ),
      ).called(1);
    },
  );
}
