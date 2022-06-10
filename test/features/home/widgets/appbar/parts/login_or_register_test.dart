import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/home/widgets/appbar/appbar.dart';

import '../../../../../../test_commons/utils/locale_setup.dart';

void main() {
  setUpAll(() {
    setUpLocaleInjection();
  });

  testWidgets(
    '[PromptLoginOrRegister] should be tappable and has '
    'text content that encourages user to login or register',
    (tester) async {
      bool clicked = false;
      late BuildContext ctx;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Builder(
                builder: (context) {
                  ctx = context;
                  return PromptLoginOrRegister(
                    onTap: () {
                      clicked = true;
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Test tapping functionality
      await tester.tap(find.byType(PromptLoginOrRegister));
      expect(clicked, true);

      // Expect appropriate text to be shown
      expect(find.text(ctx.res.strings.promptLoginOrRegister), findsOneWidget);
    },
  );
}
