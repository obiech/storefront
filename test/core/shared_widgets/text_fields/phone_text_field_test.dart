import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/shared_widgets/text_fields/phone_text_field.dart';

void main() {
  testWidgets('Ensure error message if shown if input less than 9 number',
      (tester) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: PhoneTextField(controller: controller),
          ),
        ),
      ),
    );

    final finderTextField = find.byType(PhoneTextField);

    final finderErrorMessage =
        find.text(PhoneTextField.errorPhoneNumberTooShort);

    await tester.enterText(finderTextField, '8112'); //4 Digit Number
    formKey.currentState?.validate();
    await tester.pumpAndSettle();
    expect(finderErrorMessage, findsOneWidget);

    await tester.enterText(finderTextField, '81127256'); //8 Digit Number
    formKey.currentState?.validate();
    await tester.pumpAndSettle();
    expect(finderErrorMessage, findsOneWidget);
  });
}
