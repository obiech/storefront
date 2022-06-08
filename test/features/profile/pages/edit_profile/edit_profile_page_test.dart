import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/profile/index.dart';

import '../../mocks.dart';

void main() {
  late EditProfileBloc editProfileBloc;

  setUp(() {
    editProfileBloc = MockEditProfileBloc();

    // Default state
    when(() => editProfileBloc.state).thenReturn(const EditProfileState());
  });

  testWidgets(
    'should display view correctly '
    'when page is rendered',
    (widgetTester) async {
      await widgetTester.pumpEditProfilePage(editProfileBloc);

      expect(
        find.byKey(EditProfilePageKeys.fullNameField),
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
      final context = await widgetTester.pumpEditProfilePage(editProfileBloc);

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
  Future<BuildContext> pumpEditProfilePage(
    EditProfileBloc editProfileBloc,
  ) async {
    late BuildContext ctx;

    await pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            ctx = context;
            return BlocProvider(
              create: (context) => editProfileBloc,
              child: const Scaffold(
                body: EditProfilePage(),
              ),
            );
          },
        ),
      ),
    );

    return ctx;
  }
}
