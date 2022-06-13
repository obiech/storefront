import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/index.dart';

import '../../../../test_commons/fixtures/address/delivery_address_models.dart';
import '../../../../test_commons/utils/locale_setup.dart';

extension WidgetTesterX on WidgetTester {
  Future<void> pumpWidgetForTest({
    required DeliveryAddressModel expectedAddress,
  }) async {
    await pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: DeliveryAddressDetail(
                address: expectedAddress,
                heading: context.res.strings.deliveryLocation,
              ),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  setUpAll(() {
    setUpLocaleInjection();
  });

  group('[OrderAddress]', () {
    testWidgets(
      'should consists of address title, recipient, '
      'delivery address and notes when [DeliveryAddressDetail] is called',
      (tester) async {
        final expectedAddress = sampleDeliveryAddressList[0];
        final formattedAddress = expectedAddress.details?.toPrettyAddress ?? '';
        await tester.pumpWidgetForTest(expectedAddress: expectedAddress);

        // Text for address title
        expect(find.text(expectedAddress.title), findsOneWidget);

        // Text for recipient name and phone
        expect(
          find.text(
            '${expectedAddress.recipientName} | ${expectedAddress.recipientPhoneNumber}',
          ),
          findsOneWidget,
        );

        // Text for recipient address
        expect(find.text(formattedAddress), findsOneWidget);

        // Text for recipient notes
        expect(find.text(expectedAddress.notes ?? ''), findsOneWidget);
      },
    );

    testWidgets(
      'Notes should be not visible when Notes is null',
      (tester) async {
        final expectedAddress = sampleDeliveryAddressList[1];

        await tester.pumpWidgetForTest(expectedAddress: expectedAddress);

        expect(find.text(expectedAddress.notes ?? ''), findsNothing);
      },
    );
  });
}
