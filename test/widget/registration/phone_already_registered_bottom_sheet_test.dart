import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/auth/pages/registration/phone_already_registered_bottom_sheet.dart';

import '../../src/mock_navigator.dart';

void main() {
  late StackRouter mockStackRouter;

  Widget buildWidgetToTest(String phoneNumber) {
    return MaterialApp(
      home: StackRouterScope(
        controller: mockStackRouter,
        stateHash: 0,
        child: PhoneAlreadyRegisteredBottomSheet(
          phoneNumberLocalFormat: phoneNumber,
        ),
      ),
    );
  }

  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());
    mockStackRouter = MockStackRouter();
    when(() => mockStackRouter.push(any())).thenAnswer((_) async => null);
  });

  group('PhoneAlreadyRegisteredBottomSheet', () {
    testWidgets(
      'asserts that phone number must be in local format',
      (WidgetTester tester) async {
        TestWidgetsFlutterBinding.ensureInitialized();
        const phoneNumber = '+6281234567890';

        bool throwsAssertionError = false;

        try {
          await tester.pumpWidget(
            PhoneAlreadyRegisteredBottomSheet(
              phoneNumberLocalFormat: phoneNumber,
            ),
          );
        } on AssertionError catch (_) {
          throwsAssertionError = true;
        }

        expect(throwsAssertionError, true);
      },
    );
    testWidgets(
      'should display phone number passed into it, and tapping on button '
      'will take push a route for [RegistrationPage] with args of phone number '
      'with leading zero removed. ',
      (WidgetTester tester) async {
        const phoneNumber = '081234567890';

        await tester.pumpWidget(buildWidgetToTest(phoneNumber));

        // Phone number should be displayed
        final finderTextPhoneNumber = find.byWidgetPredicate(
          (Widget widget) =>
              widget is RichText &&
              widget.text.toPlainText().contains(phoneNumber),
        );

        expect(finderTextPhoneNumber, findsOneWidget);

        // Should push a route for Registration Page
        await tester.tap(find.byType(DropezyButton));
        final routes =
            verify(() => mockStackRouter.push(captureAny())).captured;

        /// Only single route pushed/ pushReplace
        expect(routes.length, 1);
        var route = routes.first;
        expect(route, isA<LoginRoute>());
        route = route as LoginRoute;
        expect(route.args?.initialPhoneNumber, '81234567890');
      },
    );
  });
}
