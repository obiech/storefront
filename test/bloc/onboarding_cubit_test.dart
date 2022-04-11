import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/services/prefs/i_prefs_repository.dart';
import 'package:storefront_app/features/auth/index.dart';

import '../src/mock_customer_service_client.dart';

void main() {
  group('Onboarding Cubit', () {
    late IPrefsRepository prefs;

    setUp(() async {
      // Set onboarded to be initially false
      prefs = MockIPrefsRepository();
    });

    test('Initial state is FALSE if FALSE is passed in constructor', () {
      final cubit = OnboardingCubit(
        initialState: false,
        sharedPreferences: prefs,
      );

      expect(cubit.state, false);
    });

    test('Initial state is TRUE if TRUE is passed in constructor', () {
      final cubit = OnboardingCubit(
        initialState: true,
        sharedPreferences: prefs,
      );

      expect(cubit.state, true);
    });

    /*TODO - Restore test
       blocTest(
      'Sets SharedPreferences with key [PrefsKeys.kIsOnboarded] to TRUE when [isOnboarded()] is called, and emits TRUE afterwards',
      build: () => OnboardingCubit(
        sharedPreferences: prefs,
        initialState: false,
      ),
      setUp: () {
        when(() => prefs.setIsOnBoarded(any())).thenAnswer((_) async => {});
        when(() => prefs.isOnBoarded()).thenAnswer((_) async => true);
      },
      act: (OnboardingCubit cubit) => cubit.finishOnboarding(),
      expect: () => [true],
      verify: (_) async {
        expect(await prefs.isOnBoarded(), true);
      },
    );*/
  });
}
