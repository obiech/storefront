import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/index.dart';

import '../../../../../test_commons/fixtures/address/delivery_address_models.dart';
import '../../mocks.dart';

void main() {
  group('ChangeAddressPage', () {
    late DeliveryAddressCubit cubit;

    const expectedNewAddressIndex = 1;

    setUp(() {
      cubit = MockDeliveryAddressCubit();
    });

    testWidgets(
      'should display AddressLoadingView '
      'when state is DeliveryAddressLoading',
      (tester) async {
        when(() => cubit.state).thenReturn(const DeliveryAddressLoading());

        await tester.pumpChangeAddressPage(cubit: cubit);

        expect(find.byType(AddressLoadingView), findsOneWidget);
      },
    );

    testWidgets(
      'should display Address list view '
      'and show correct number of items '
      'when state is DeliveryAddressLoaded',
      (tester) async {
        when(() => cubit.state).thenReturn(
          DeliveryAddressLoaded(
            addressList: sampleDeliveryAddressList,
            activeAddress: sampleDeliveryAddressList[0],
          ),
        );

        await tester.pumpChangeAddressPage(cubit: cubit);

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
        when(() => cubit.state).thenReturn(
          DeliveryAddressLoaded(
            addressList: sampleDeliveryAddressList,
            activeAddress: sampleDeliveryAddressList[0],
          ),
        );

        await tester.pumpChangeAddressPage(cubit: cubit);

        expect(find.byType(ListView), findsOneWidget);

        await tester.tap(find.byType(AddressCard).at(expectedNewAddressIndex));

        verify(
          () => cubit.setActiveAddress(
            sampleDeliveryAddressList[expectedNewAddressIndex],
          ),
        ).called(1);
      },
    );

    testWidgets(
      'should display snack bar '
      'when active address is updated',
      (tester) async {
        when(() => cubit.state).thenReturn(
          DeliveryAddressLoaded(
            addressList: sampleDeliveryAddressList,
            activeAddress: sampleDeliveryAddressList[0],
          ),
        );
        whenListen(
          cubit,
          Stream.fromIterable([
            DeliveryAddressLoaded(
              addressList: sampleDeliveryAddressList,
              activeAddress: sampleDeliveryAddressList[expectedNewAddressIndex],
            ),
          ]),
        );

        final context = await tester.pumpChangeAddressPage(cubit: cubit);

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
        when(() => cubit.state).thenReturn(
          DeliveryAddressLoaded(
            addressList: sampleDeliveryAddressList,
            activeAddress: sampleDeliveryAddressList[activeAddressIndex],
          ),
        );
        whenListen(
          cubit,
          Stream.fromIterable([
            DeliveryAddressLoaded(
              addressList: sampleDeliveryAddressList,
              activeAddress: sampleDeliveryAddressList[activeAddressIndex],
            ),
          ]),
        );

        await tester.pumpChangeAddressPage(cubit: cubit);

        expect(find.byType(ListView), findsOneWidget);

        await tester.tap(find.byType(AddressCard).at(activeAddressIndex));
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsNothing);
        verifyNever(
          () => cubit
              .setActiveAddress(sampleDeliveryAddressList[activeAddressIndex]),
        );
      },
    );
  });
}

extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpChangeAddressPage({
    required DeliveryAddressCubit cubit,
  }) async {
    late BuildContext ctx;

    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              ctx = context;
              return BlocProvider<DeliveryAddressCubit>.value(
                value: cubit,
                child: const ChangeAddressPage(),
              );
            },
          ),
        ),
      ),
    );

    return ctx;
  }
}
