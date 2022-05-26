import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/address/pages/request_location/request_location_access_page.dart';

class RequestLocationAccessPageFinders {
  static Finder get page => find.byType(RequestLocationAccessPage);

  static Finder get assetImage => find.byKey(
        const ValueKey(RequestLocationAccessPageKeys.assetImage),
      );

  static Finder get buttonGrantAccess => find.byKey(
        const ValueKey(RequestLocationAccessPageKeys.buttonGrantAccess),
      );

  static Finder get buttonSkipProcess => find.byKey(
        const ValueKey(RequestLocationAccessPageKeys.buttonSkipProcess),
      );
}
