import 'package:flutter_test/flutter_test.dart';

import '../../test_commons/finders/home_page_finders.dart';

class HomePageRobot {
  const HomePageRobot(this.tester);

  final WidgetTester tester;

  /// Expects that [HomePage] is shown
  Future<void> expectPageIsShown() async {
    expect(finderHomePage, findsOneWidget);
  }
}
