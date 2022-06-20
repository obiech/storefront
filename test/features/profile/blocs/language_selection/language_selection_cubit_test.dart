import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/profile/blocs/language_selection/language_selection_cubit.dart';

import '../../fixtures.dart';

void main() {
  late LanguageSelectionCubit languageSelectionCubit;

  setUp(() {
    languageSelectionCubit = LanguageSelectionCubit();
  });

  group('LanguageSelectionCubit', () {
    blocTest<LanguageSelectionCubit, LanguageSelectionState>(
      'should emit locale '
      'when onLocaleChanged is called',
      build: () => languageSelectionCubit,
      act: (cubit) => cubit.onLocaleChanged(enLocale),
      expect: () => [const LanguageSelectionState(locale: enLocale)],
    );

    blocTest<LanguageSelectionCubit, LanguageSelectionState>(
      'should emit profileUpdated '
      'when submitLocale is called',
      build: () => languageSelectionCubit,
      act: (cubit) => cubit.submitLocale(),
      expect: () => [
        const LanguageSelectionState(
          locale: idLocale,
          localeUpdated: true,
        ),
      ],
    );
  });
}
