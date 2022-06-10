import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/address/index.dart';
import 'package:storefront_app/features/home/widgets/appbar/appbar.dart';

import '../../../../../../test_commons/fixtures/address/delivery_address_models.dart';
import '../../../../../commons.dart';
import '../../../mocks.dart';

extension WidgetTesterX on WidgetTester {
  Future<void> pumpAddressSelection({
    required DeliveryAddressCubit cubit,
    required DeliveryAddressState currentState,
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
        home: BlocProvider<DeliveryAddressCubit>(
          create: (_) => cubit,
          child: Scaffold(
            body: AddressSelection(
              onTap: () {},
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  setUpAll(() {
    setUpLocaleInjection();
  });

  group('[AddressSelection]', () {
    late DeliveryAddressCubit cubit;

    setUp(() {
      cubit = MockDeliveryAddressCubit();
    });
    testWidgets(
      'should display active address title when status is Loaded',
      (tester) async {
        final state = DeliveryAddressLoaded(
          addressList: sampleDeliveryAddressList,
          activeAddress: sampleDeliveryAddressList[0],
        );

        await tester.pumpAddressSelection(
          cubit: cubit,
          currentState: state,
        );

        expect(find.text(state.activeAddress.title), findsOneWidget);
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
        );

        expect(find.text(state.message), findsOneWidget);
      },
    );

    // TODO(leovinsen): Add test cases for loading when design reference is available
  });
}
