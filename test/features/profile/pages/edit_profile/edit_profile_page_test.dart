import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/profile/index.dart';

void main() {
  testWidgets(
    'should display view correctly '
    'when page is rendered',
    (widgetTester) async {
      await widgetTester.pumpEditProfilePage();

      expect(
        find.byKey(EditProfilePageKeys.nameField),
        findsOneWidget,
      );
      expect(
        find.byKey(EditProfilePageKeys.saveProfileButton),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should show validation error '
    'when save button is tapped '
    'and form is empty',
    (widgetTester) async {
      final context = await widgetTester.pumpEditProfilePage();

      await widgetTester.tap(find.byKey(EditProfilePageKeys.saveProfileButton));
      await widgetTester.pumpAndSettle();

      expect(
        find.text(
          context.res.strings.cannotBeEmpty(context.res.strings.name()),
        ),
        findsOneWidget,
      );
    },
  );
}

extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpEditProfilePage() async {
    late BuildContext ctx;

    await pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            ctx = context;
            return const Scaffold(
              body: EditProfilePage(),
            );
          },
        ),
      ),
    );

    return ctx;
  }
}
