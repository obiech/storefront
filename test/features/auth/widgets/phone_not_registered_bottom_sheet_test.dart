import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/auth/pages/login/phone_not_registered_bottom_sheet.dart';

import '../../../src/mock_navigator.dart';

void main() {
  late StackRouter navigator;

  Widget buildWidgetToTest(String phoneNumber) {
    return MaterialApp(
      home: StackRouterScope(
        controller: navigator,
        stateHash: 0,
        child: PhoneNotRegisteredBottomSheet(
          phoneNumberLocalFormat: phoneNumber,
        ),
      ),
    );
  }

  setUpAll(() {
    navigator = MockStackRouter();

    // Router stubs
    registerFallbackValue(FakePageRouteInfo());
    when(() => navigator.push(any())).thenAnswer((_) async => null);
    when(() => navigator.replaceAll(any())).thenAnswer((_) async => {});
  });

  group('PhoneNotRegisteredBottomSheet', () {
    testWidgets(
      'asserts that phone number must be in local format',
      (WidgetTester tester) async {
        const phoneNumber = '+6281234567890';

        bool throwsAssertionError = false;

        try {
          await tester.pumpWidget(
            StackRouterScope(
              controller: navigator,
              stateHash: 0,
              child: PhoneNotRegisteredBottomSheet(
                phoneNumberLocalFormat: phoneNumber,
              ),
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
            verify(() => navigator.replaceAll(captureAny())).captured;

        expect(routes.length, 1);
        expect(routes.first.length, 1);
        expect(routes.first.first, isA<RegistrationRoute>());
        final route = routes.first.first as RegistrationRoute;
        expect(route.args?.initialPhoneNumber, '81234567890');
      },
    );
  });
}
