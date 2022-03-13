import 'package:flutter_test/flutter_test.dart';

import '../../test_commons/finders/home_screen_finders.dart';

class HomeScreenRobot {
  const HomeScreenRobot(this.tester);

  final WidgetTester tester;

  /// Expects that [HomeScreen] is shown
  Future<void> expectScreenIsShown() async {
    expect(finderHomeScreen, findsOneWidget);
  }
}
