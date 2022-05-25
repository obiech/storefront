import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/index.dart';

import '../../mocks.dart';

void main() {
  late AddressDetailBloc bloc;

  const addressName = 'My Home';
  const addressDetail = 'Jl. Dropezy No. 18';
  const recipientName = 'John Doe';
  const recipientPhone = '081234567890';

  setUp(() {
    bloc = MockAddressDetailBloc();

    // Default state
    when(() => bloc.state).thenReturn(const AddressDetailState());
  });

  testWidgets(
    'should display view correctly '
    'when page is rendered',
    (tester) async {
      await tester.pumpAddressDetailPage(bloc);

      expect(
        find.byKey(AddressDetailPageKeys.addressNameField),
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
    'should show validation error '
    'when save address button is tapped '
    'and form is empty',
    (tester) async {
      final context = await tester.pumpAddressDetailPage(bloc);

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
    },
  );

  testWidgets(
    'should add FormSubmitted event to bloc '
    'when save address button is tapped '
    'and form is filled',
    (tester) async {
      await tester.pumpAddressDetailPage(bloc);

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

      await tester
          .tap(find.byKey(AddressDetailPageKeys.primaryAddressCheckbox));

      await tester.tap(find.byKey(AddressDetailPageKeys.saveAddressButton));
      await tester.pumpAndSettle();

      verify(() => bloc.add(const AddressNameChanged(addressName))).called(1);
      verify(() => bloc.add(const AddressDetailChanged(addressDetail)))
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
      whenListen(
        bloc,
        Stream.fromIterable([
          const AddressDetailState(errorMessage: 'Error!'),
        ]),
      );

      await tester.pumpAddressDetailPage(bloc);

      // TODO (widy): pre-fill form to make it simpler
      // https://dropezy.atlassian.net/browse/STOR-496
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

      await tester.tap(find.byKey(AddressDetailPageKeys.saveAddressButton));
      await tester.pumpAndSettle();

      verify(() => bloc.add(const FormSubmitted())).called(1);

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text('Error!'),
        findsOneWidget,
      );
    },
  );
}

extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpAddressDetailPage(AddressDetailBloc bloc) async {
    late BuildContext ctx;

    await pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            ctx = context;
            return Scaffold(
              body: BlocProvider.value(
                value: bloc,
                child: const AddressDetailPage(),
              ),
            );
          },
        ),
      ),
    );

    return ctx;
  }
}
