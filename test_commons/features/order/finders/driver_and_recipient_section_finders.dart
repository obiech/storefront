import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/order/widgets/order_details/driver_recipient/widget.dart';

class DriverAndRecipientSectionFinders {
  static Finder get finderDriverInformation => find.byKey(
        const ValueKey(DriverAndRecipientSectionKeys.driverInformation),
      );

  static Finder get finderRecipientInformation => find.byKey(
        const ValueKey(DriverAndRecipientSectionKeys.recipientInformation),
      );

  static Finder get finderContactDriverButton => find.byKey(
        const ValueKey(DriverAndRecipientSectionKeys.contactDriverButton),
      );

  static Finder get finderContactDriverButtonText => find.descendant(
        of: finderContactDriverButton,
        matching: find.byType(Text),
      );
}
