import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';

import '../../../commons.dart';

void main() {
  setUpAll(() {
    setUpLocaleInjection();
  });

  testWidgets(
      'should clear on submit '
      'when [clearOnSearch] is set to true', (WidgetTester tester) async {
    /// arrange
    final TextEditingController _controller = TextEditingController();

    await tester.pumpSearchField(controller: _controller, clearOnSearch: true);

    /// act
    final finderTextField = find.descendant(
      of: find.byType(SearchTextField),
      matching: find.byType(TextField),
    );

    expect(finderTextField, findsOneWidget);
    const text = 'Apple Juice';
    await tester.enterText(finderTextField, text);

    expect(find.text(text), findsOneWidget);
    expect(_controller.text, text);

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(find.text(text), findsNothing);
    expect(_controller.text, '');
  });

  testWidgets(
      'should not clear on submit '
      'when [clearOnSearch] is set to false', (WidgetTester tester) async {
    /// arrange
    final TextEditingController _controller = TextEditingController();

    await tester.pumpSearchField(controller: _controller);

    /// act
    final finderTextField = find.descendant(
      of: find.byType(SearchTextField),
      matching: find.byType(TextField),
    );

    expect(finderTextField, findsOneWidget);
    const text = 'Apple Juice';
    await tester.enterText(finderTextField, text);

    expect(find.text(text), findsOneWidget);
    expect(_controller.text, text);

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(find.text(text), findsOneWidget);
    expect(_controller.text, text);
  });
}

extension WidgetTesterX on WidgetTester {
  Future<void> pumpSearchField({
    required TextEditingController controller,
    bool clearOnSearch = false,
  }) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SearchTextField(
            controller: controller,
            clearOnSearch: clearOnSearch,
          ),
        ),
      ),
    );
  }
}
