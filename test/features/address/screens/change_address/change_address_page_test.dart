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
  });
}

extension WidgetTesterX on WidgetTester {
  Future<void> pumpChangeAddressPage({
    required DeliveryAddressCubit cubit,
  }) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<DeliveryAddressCubit>.value(
            value: cubit,
            child: const ChangeAddressPage(),
          ),
        ),
      ),
    );
  }
}
