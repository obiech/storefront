import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/profile/blocs/language_selection/language_selection_cubit.dart';

import '../../../../widget/onboarding/onboarding_page_test.dart';
import '../../fixtures.dart';

void main() {
  late IPrefsRepository prefsRepository;
  late LanguageSelectionCubit languageSelectionCubit;

  setUp(() {
    prefsRepository = MockPrefsRepository();
    when(() => prefsRepository.getDeviceLocale()).thenAnswer((_) => idLocale);

    languageSelectionCubit = LanguageSelectionCubit(prefsRepository);
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
      setUp: () {
        when(() => prefsRepository.setDeviceLocale(idLocale))
            .thenAnswer((_) async {});
      },
      build: () => languageSelectionCubit,
      act: (cubit) => cubit.submitLocale(),
      expect: () => [
        const LanguageSelectionState(
          locale: idLocale,
          localeUpdated: true,
        ),
      ],
      verify: (_) {
        verify(() => prefsRepository.setDeviceLocale(idLocale)).called(1);
      },
    );
  });
}
