import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/auth/index.dart';
import 'package:storefront_app/features/auth/screens/login/phone_not_registered_bottom_sheet.dart';

import '../../src/mock_navigator.dart';

void main() {
  late MockNavigator navigator;

  Widget buildWidgetToTest(String phoneNumber) {
    return MaterialApp(
      home: MockNavigatorProvider(
        navigator: navigator,
        child: PhoneNotRegisteredBottomSheet(
          phoneNumberLocalFormat: phoneNumber,
        ),
      ),
    );
  }

  setUpAll(() {
    navigator = createStubbedMockNavigator();
  });

  group('PhoneNotRegisteredBottomSheet', () {
    testWidgets(
      'asserts that phone number must be in local format',
      (WidgetTester tester) async {
        const phoneNumber = '+6281234567890';

        bool throwsAssertionError = false;

        try {
          await tester.pumpWidget(
            MockNavigatorProvider(
              navigator: navigator,
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
      'will take push a route for [RegistrationScreen] with args of phone number '
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

        // Should push a route for Registration Screen
        await tester.tap(find.byType(DropezyButton));
        verifyPushReplacementNamed(
          navigator,
          RegistrationScreen.routeName,
          arguments: '81234567890',
        );
      },
    );
  });
}
