import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/index.dart';

void main() {
  testWidgets(
    'should display view correctly '
    'when page is rendered',
    (tester) async {
      await tester.pumpAddressDetailPage();

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
      final context = await tester.pumpAddressDetailPage();

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
}

extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpAddressDetailPage() async {
    late BuildContext ctx;

    await pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            ctx = context;
            return const Scaffold(
              body: AddressDetailPage(),
            );
          },
        ),
      ),
    );

    return ctx;
  }
}
