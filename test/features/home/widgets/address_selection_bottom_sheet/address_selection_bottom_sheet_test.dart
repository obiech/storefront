import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/index.dart';
import 'package:storefront_app/features/home/widgets/address_selection_bottom_sheet/address_selection_bottom_sheet.dart';

import '../../../../../test_commons/fixtures/address/delivery_address_models.dart';
import '../../mocks.dart';

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
        home: Scaffold(
          body: BlocProvider<DeliveryAddressCubit>(
            create: (_) => cubit,
            child: const AddressSelectionBottomSheet(),
          ),
        ),
      ),
    );
  }
}

void main() {
  late DeliveryAddressCubit cubit;

  setUp(() {
    cubit = MockDeliveryAddressCubit();
  });

  testWidgets(
    'should display address list and active address '
    'when status is Loaded including active and inactive '
    'Radio Icon',
    (tester) async {
      final state = DeliveryAddressLoaded(
        addressList: sampleDeliveryAddressList,
        activeAddress: sampleDeliveryAddressList[0],
      );

      await tester.pumpAddressSelection(
        cubit: cubit,
        currentState: state,
      );
      // Address List
      for (int index = 0; index < state.addressList.length; index++) {
        final formattedAddress =
            state.addressList[index].details?.toPrettyAddress;

        await tester.pumpAddressSelection(
          cubit: cubit,
          currentState: state,
        );

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
      );

      expect(find.text(state.message), findsOneWidget);
    },
  );
}
