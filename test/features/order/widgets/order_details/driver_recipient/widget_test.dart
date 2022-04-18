import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/order/index.dart';

import '../../../../../../test_commons/features/order/finders/driver_and_recipient_section_finders.dart';

/// Helper functions specific to this test
extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpWidgetForTest({
    required OrderDriverModel driverModel,
    OrderRecipientModel? recipientModel,
  }) async {
    late BuildContext ctx;
    await pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            ctx = context;
            return Scaffold(
              body: DriverAndRecipientSection(
                driverModel: driverModel,
                recipientModel: recipientModel,
              ),
            );
          },
        ),
      ),
    );

    return ctx;
  }

  Future<void> assertWidgetsForDriverInformation({
    required BuildContext context,
    required String driverImageUrl,
    required String driverName,
    required String driverLicenseNumber,
  }) async {
    // Should find a profile image for the driver
    final profileImage = firstWidget(
      find.descendant(
        of: DriverAndRecipientSectionFinders.finderDriverInformation,
        matching: find.byType(CachedNetworkImage),
      ),
    ) as CachedNetworkImage;
    expect(profileImage.imageUrl, driverImageUrl);

    // Should find driver's name and vehicle license number
    expect(find.text(driverName), findsOneWidget);
    expect(find.text(driverLicenseNumber), findsOneWidget);

    // Should find a button to contact driver
    expect(
      DriverAndRecipientSectionFinders.finderContactDriverButton,
      findsOneWidget,
    );

    final contactDriverButtonText = firstWidget(
      DriverAndRecipientSectionFinders.finderContactDriverButtonText,
    ) as Text;

    // Should say 'contact'
    expect(contactDriverButtonText.data, context.res.strings.contact);
  }

  Future<void> assertWidgetsForRecipientInformation({
    required BuildContext context,
    required String recipientImageUrl,
    required String recipientName,
    required String recipientRelation,
  }) async {
    // Should find a profile image for the recipient
    final profileImage = firstWidget(
      find.descendant(
        of: DriverAndRecipientSectionFinders.finderRecipientInformation,
        matching: find.byType(CachedNetworkImage),
      ),
    ) as CachedNetworkImage;
    expect(profileImage.imageUrl, recipientImageUrl);

    // Should find recipient's name and relation to customer
    expect(find.text(recipientName), findsOneWidget);
    expect(find.text(recipientRelation), findsOneWidget);
  }
}

void main() {
  const driverImageUrl = 'https://dropezy.com';
  const driverName = 'Dropezy Driver';
  const driverLicenseNumber = 'B 1234 EZY';
  const driverWhatsappNumber = '+628123123123';

  const recipientImageUrl = 'https://dropezy-2.com';
  const recipientName = 'John Doe';
  const recipientRelation = 'Husband';

  group(
    'DriverAndRecipientSection',
    () {
      testWidgets(
        'shows driver information, profile image and a button to contact them',
        (tester) async {
          // setup
          final driverModel = OrderDriverModel(
            imageUrl: driverImageUrl,
            fullName: driverName,
            vehicleLicenseNumber: driverLicenseNumber,
            whatsappNumber: driverWhatsappNumber,
          );

          // act
          final ctx = await tester.pumpWidgetForTest(
            driverModel: driverModel,
          );

          // assert
          // Should find driver's information
          expect(
            DriverAndRecipientSectionFinders.finderDriverInformation,
            findsOneWidget,
          );

          await tester.assertWidgetsForDriverInformation(
            context: ctx,
            driverImageUrl: driverImageUrl,
            driverName: driverName,
            driverLicenseNumber: driverLicenseNumber,
          );

          // Should not display recipient information
          expect(
            DriverAndRecipientSectionFinders.finderRecipientInformation,
            findsNothing,
          );
        },
      );

      testWidgets(
        'shows recipient information and profile image '
        'if OrderRecipientModel is provided',
        (tester) async {
          // setup
          final driverModel = OrderDriverModel(
            imageUrl: driverImageUrl,
            fullName: driverName,
            vehicleLicenseNumber: driverLicenseNumber,
            whatsappNumber: driverWhatsappNumber,
          );

          final recipientModel = OrderRecipientModel(
            imageUrl: recipientImageUrl,
            fullName: recipientName,
            relationToCustomer: recipientRelation,
          );

          // act
          final ctx = await tester.pumpWidgetForTest(
            driverModel: driverModel,
            recipientModel: recipientModel,
          );

          // assert
          // Should find driver's information
          expect(
            DriverAndRecipientSectionFinders.finderDriverInformation,
            findsOneWidget,
          );

          await tester.assertWidgetsForDriverInformation(
            context: ctx,
            driverImageUrl: driverImageUrl,
            driverName: driverName,
            driverLicenseNumber: driverLicenseNumber,
          );

          // Should also find recipient's information
          expect(
            DriverAndRecipientSectionFinders.finderRecipientInformation,
            findsOneWidget,
          );

          await tester.assertWidgetsForRecipientInformation(
            context: ctx,
            recipientImageUrl: recipientImageUrl,
            recipientName: recipientName,
            recipientRelation: recipientRelation,
          );
        },
      );
    },
  );
}
