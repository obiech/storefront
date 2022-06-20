import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/profile/blocs/language_selection/language_selection_cubit.dart';
import 'package:storefront_app/features/profile/widgets/language_selection/keys.dart';
import 'package:storefront_app/features/profile/widgets/language_selection/language_selection_bottomsheet.dart';

import '../../../../commons.dart';
import '../../fixtures.dart';
import '../../mocks.dart';

void main() {
  late LanguageSelectionCubit languageSelectionCubit;

  setUp(() {
    languageSelectionCubit = MockLanguageSelectionCubit();

    when(() => languageSelectionCubit.state).thenReturn(
      const LanguageSelectionState(locale: idLocale),
    );
  });

  setUpAll(() {
    setUpLocaleInjection();
  });

  group('[LanguageSelectionBottomSheet]', () {
    testWidgets(
      'should display LanguageItemTile (ID) and '
      'LanguageItemTile (EN) when bottom sheet is rendered',
      (tester) async {
        await tester.pumpLanguageSelectionSheet(languageSelectionCubit);

        expect(find.byType(LanguageItemTile), findsNWidgets(2));
        expect(find.byKey(LanguageSelectionKeys.idTile), findsOneWidget);
        expect(find.byKey(LanguageSelectionKeys.enTile), findsOneWidget);
      },
    );

    testWidgets(
      'should set locale to selected locale '
      'when Language Item Tile is tapped',
      (tester) async {
        await tester.pumpLanguageSelectionSheet(languageSelectionCubit);

        await tester.tap(find.byKey(LanguageSelectionKeys.enTile));
        await tester.pumpAndSettle();

        verify(
          () => languageSelectionCubit.onLocaleChanged(enLocale),
        ).called(1);
      },
    );

    testWidgets(
      'should show active radio icon '
      'when Language is selected',
      (tester) async {
        whenListen(
          languageSelectionCubit,
          Stream.fromIterable([
            const LanguageSelectionState(
              locale: enLocale,
            )
          ]),
        );
        await tester.pumpLanguageSelectionSheet(languageSelectionCubit);
        await tester.pumpAndSettle();

        final radioIcon = tester.widget<RadioIcon>(
          find.descendant(
            of: find.byKey(LanguageSelectionKeys.enTile),
            matching: find.byType(RadioIcon),
          ),
        );

        expect(
          radioIcon.active,
          languageSelectionCubit.state.locale == enLocale,
        );
      },
    );

    testWidgets(
      'should update locale to device '
      'when save button is tapped',
      (tester) async {
        final context = await tester.pumpLanguageSelectionSheet(
          languageSelectionCubit,
        );

        await tester.tap(find.text(context.res.strings.saveProfile));
        await tester.pumpAndSettle();

        verify(
          () => languageSelectionCubit.submitLocale(),
        ).called(1);
      },
    );

    testWidgets(
      'should close language sheet '
      'when locale is submitted',
      (tester) async {
        whenListen(
          languageSelectionCubit,
          Stream.fromIterable([
            const LanguageSelectionState(
              locale: idLocale,
              localeUpdated: true,
            )
          ]),
        );

        await tester.pumpLanguageSelectionSheet(languageSelectionCubit);
        await tester.pumpAndSettle();

        expect(find.byType(LanguageSelectionBottomSheet), findsNothing);
      },
    );
  });
}

/// Helper functions specific to this test
extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpLanguageSelectionSheet(
    LanguageSelectionCubit languageSelectionCubit,
  ) async {
    late BuildContext ctx;

    await pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            ctx = context;
            return Scaffold(
              body: BlocProvider<LanguageSelectionCubit>(
                create: (_) => languageSelectionCubit,
                child: LanguageSelectionBottomSheet(mainContext: context),
              ),
            );
          },
        ),
      ),
    );

    return ctx;
  }
}
