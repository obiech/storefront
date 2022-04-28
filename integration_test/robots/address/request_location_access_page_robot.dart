import 'package:flutter_test/flutter_test.dart';

import '../../../test_commons/finders/address/request_location_access_page_finders.dart';

class RequestLocationAccessPageRobot {
  const RequestLocationAccessPageRobot(this.tester);

  final WidgetTester tester;

  /// Expects that [RequestLocationAccessPage] is shown.
  Future<void> expectScreenIsShown() async {
    expect(RequestLocationAccessPageFinders.page, findsOneWidget);
  }

  /// Tap on 'Grant Access' button that will trigger
  /// system dialog for granting location access.
  Future<void> tapGrantAccessButton() async {
    await tester.tap(RequestLocationAccessPageFinders.buttonGrantAccess);
    await tester.pumpAndSettle();
  }
}
