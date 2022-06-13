import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/shared_widgets/address/delivery_address_detail.dart';
import 'package:storefront_app/features/address/index.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';

import '../../../../../test_commons/fixtures/address/delivery_address_models.dart'
    as address_fixtures;
import '../../../../commons.dart';
import '../../../home/mocks.dart';

void main() {
  group(
    '[CartAddressSelection]',
    () {
      late DeliveryAddressCubit deliveryAddressCubit;

      setUp(() {
        deliveryAddressCubit = MockDeliveryAddressCubit();
      });

      setUpAll(() {
        setUpLocaleInjection();
      });

      testWidgets(
        'should display a [DeliveryAddressDetail] using current active address '
        'and enabled address selection '
        'when state is [DeliveryAddressLoaded]',
        (tester) async {
          // arramge
          final addressList = address_fixtures.sampleDeliveryAddressList;
          final mockState = DeliveryAddressLoaded(
            addressList: addressList,
            activeAddress: addressList[0],
          );
          when(() => deliveryAddressCubit.state).thenReturn(mockState);

          // act
          await tester.pumpCartAddressSelection(
            deliveryAddressCubit: deliveryAddressCubit,
          );

          // assert
          final addressDetail = tester.widget<DeliveryAddressDetail>(
            find.byType(DeliveryAddressDetail),
          );

          expect(addressDetail.address, mockState.activeAddress);
          expect(addressDetail.enableAddressSelection, true);
        },
      );

      group(
        'should display nothing '
        'when state is not [DeliveryAddressLoaded], such as',
        () {
          /// Expects that only a [SizedBox] is shown for given [state].
          Future<void> testFn(DeliveryAddressState state) async {
            testWidgets('[${state.runtimeType.toString()}]', (tester) async {
              // arrange
              when(() => deliveryAddressCubit.state).thenReturn(state);

              // act
              await tester.pumpCartAddressSelection(
                deliveryAddressCubit: deliveryAddressCubit,
              );

              // assert
              expect(find.byType(DeliveryAddressDetail), findsNothing);
              expect(find.byType(SizedBox), findsOneWidget);
            });
          }

          const otherStates = [
            DeliveryAddressInitial(),
            DeliveryAddressLoadedEmpty(),
            DeliveryAddressLoading(),
            DeliveryAddressError('Error message'),
          ];

          otherStates.forEach(testFn);
        },
      );
    },
  );
}

extension WidgetTesterX on WidgetTester {
  Future<void> pumpCartAddressSelection({
    required DeliveryAddressCubit deliveryAddressCubit,
  }) async {
    await pumpWidget(
      BlocProvider<DeliveryAddressCubit>(
        create: (_) => deliveryAddressCubit,
        child: const MaterialApp(
          home: Scaffold(
            body: CartAddressSelection(),
          ),
        ),
      ),
    );
  }
}
