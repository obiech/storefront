import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/index.dart';

import '../../../../commons.dart';
import '../../../../src/mock_navigator.dart';
import '../../mocks.dart';

void main() {
  late StackRouter stackRouter;
  late AddressDetailBloc bloc;

  const addressName = 'My Home';
  const addressDetail = 'Jl. Dropezy No. 18';
  const recipientName = 'John Doe';
  const recipientPhone = '081234567890';

  setUp(() {
    stackRouter = MockStackRouter();
    bloc = MockAddressDetailBloc();

    // Default state
    when(() => bloc.state).thenReturn(const AddressDetailState());

    // if not stubbed, this will throw an UnimplementedError when called
    // here, we stub it to do nothing because we're only checking for the
    // route name that's being pushed
    when(() => stackRouter.push(any())).thenAnswer((_) async => null);
  });

  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());
    setUpLocaleInjection();
  });

  testWidgets(
    'should display view correctly '
    'when page is rendered',
    (tester) async {
      await tester.pumpAddressDetailPage(stackRouter, bloc);

      expect(
        find.byKey(AddressDetailPageKeys.addressNameField),
        findsOneWidget,
      );
      expect(
        find.byKey(AddressDetailPageKeys.googleMapView),
        findsOneWidget,
      );
      expect(
        find.byKey(AddressDetailPageKeys.addressDetailField),
        findsOneWidget,
      );
      expect(
        find.byKey(AddressDetailPageKeys.recipientNameField),
        findsOneWidget,
      );
      expect(
        find.byKey(AddressDetailPageKeys.phoneNumberField),
        findsOneWidget,
      );
      expect(
        find.byKey(AddressDetailPageKeys.primaryAddressCheckbox),
        findsOneWidget,
      );
      expect(
        find.byKey(AddressDetailPageKeys.saveAddressButton),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should set initial value to fields '
    'when page is rendered and values is provided',
    (tester) async {
      when(() => bloc.state).thenReturn(
        const AddressDetailState(
          addressName: addressName,
          addressDetailsNote: addressDetail,
          recipientName: recipientName,
          recipientPhoneNumber: recipientPhone,
        ),
      );

      await tester.pumpAddressDetailPage(stackRouter, bloc);

      expect(find.text(addressName), findsOneWidget);
      expect(find.text(addressDetail), findsOneWidget);
      expect(find.text(recipientName), findsOneWidget);
      expect(find.text(recipientPhone), findsOneWidget);
    },
  );

  testWidgets(
    'should show validation error '
    'when save address button is tapped '
    'and form is empty',
    (tester) async {
      final context = await tester.pumpAddressDetailPage(stackRouter, bloc);

      await tester.tap(find.byKey(AddressDetailPageKeys.saveAddressButton));
      await tester.pumpAndSettle();

      expect(
        find.text(
          context.res.strings.cannotBeEmpty(context.res.strings.addressName),
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          context.res.strings.cannotBeEmpty(context.res.strings.addressDetail),
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          context.res.strings.cannotBeEmpty(context.res.strings.recipientName),
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          context.res.strings.cannotBeEmpty(context.res.strings.phoneNumber),
        ),
        findsOneWidget,
      );
      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text(
          context.res.strings.makeSureFieldsFilled,
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should add FormSubmitted event to bloc '
    'when save address button is tapped '
    'and form is filled',
    (tester) async {
      await tester.pumpAddressDetailPage(stackRouter, bloc);

      await tester.enterText(
        find.byKey(AddressDetailPageKeys.addressNameField),
        addressName,
      );

      await tester.enterText(
        find.byKey(AddressDetailPageKeys.addressDetailField),
        addressDetail,
      );

      await tester.enterText(
        find.byKey(AddressDetailPageKeys.recipientNameField),
        recipientName,
      );

      await tester.enterText(
        find.byKey(AddressDetailPageKeys.phoneNumberField),
        recipientPhone,
      );

      await tester.ensureVisible(
        find.byKey(AddressDetailPageKeys.primaryAddressCheckbox),
      );
      await tester
          .tap(find.byKey(AddressDetailPageKeys.primaryAddressCheckbox));

      await tester.tap(find.byKey(AddressDetailPageKeys.saveAddressButton));
      await tester.pumpAndSettle();

      verify(() => bloc.add(const AddressNameChanged(addressName))).called(1);
      verify(() => bloc.add(const AddressDetailNoteChanged(addressDetail)))
          .called(1);
      verify(() => bloc.add(const RecipientNameChanged(recipientName)))
          .called(1);
      verify(() => bloc.add(const RecipientPhoneChanged(recipientPhone)))
          .called(1);
      verify(() => bloc.add(const PrimaryAddressChanged(true))).called(1);
      verify(() => bloc.add(const FormSubmitted())).called(1);
    },
  );

  testWidgets(
    'should display snack bar '
    'when save address button is tapped '
    'and form is filled '
    'and error occurred',
    (tester) async {
      when(() => bloc.state).thenReturn(
        const AddressDetailState(
          addressName: addressName,
          addressDetailsNote: addressDetail,
          recipientName: recipientName,
          recipientPhoneNumber: recipientPhone,
        ),
      );

      whenListen(
        bloc,
        Stream.fromIterable([
          const AddressDetailState(errorMessage: 'Error!'),
        ]),
      );

      await tester.pumpAddressDetailPage(stackRouter, bloc);

      await tester.tap(find.byKey(AddressDetailPageKeys.saveAddressButton));
      await tester.pumpAndSettle();

      expect(find.text(addressName), findsOneWidget);
      expect(find.text(addressDetail), findsOneWidget);
      expect(find.text(recipientName), findsOneWidget);
      expect(find.text(recipientPhone), findsOneWidget);

      verify(() => bloc.add(const FormSubmitted())).called(1);

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text('Error!'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should navigate to Address Pinpoint Page '
    'when map view is tapped',
    (tester) async {
      await tester.pumpAddressDetailPage(stackRouter, bloc);

      await tester.tap(find.byKey(AddressDetailPageKeys.googleMapView));
      await tester.pumpAndSettle();

      final capturedRoutes =
          verify(() => stackRouter.push(captureAny())).captured;

      // there should only be one route that's being pushed
      expect(capturedRoutes.length, 1);

      final routeInfo = capturedRoutes.first as PageRouteInfo;

      // expecting the right route being pushed
      expect(routeInfo, isA<AddressPinpointRoute>());
    },
    // TODO (widy): Fix gesture testing
    // Testing gestures on platform views is not supported yet
    // https://github.com/flutter/flutter/issues/30471
    skip: true,
  );
}

extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpAddressDetailPage(
    StackRouter stackRouter,
    AddressDetailBloc bloc,
  ) async {
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
                body: BlocProvider.value(
                  value: bloc,
                  child: const AddressDetailPage(),
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
