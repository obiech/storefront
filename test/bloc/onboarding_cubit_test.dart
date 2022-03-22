import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storefront_app/bloc/onboarding/onboarding_cubit.dart';
import 'package:storefront_app/constants/prefs_keys.dart';

void main() {
  group('Onboarding Cubit', () {
    late SharedPreferences prefs;

    setUp(() async {
      // Set onboarded to be initially false
      SharedPreferences.setMockInitialValues({PrefsKeys.kIsOnboarded: false});
      prefs = await SharedPreferences.getInstance();
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

    blocTest(
      'Sets SharedPreferences with key [PrefsKeys.kIsOnboarded] to TRUE when [isOnboarded()] is called, and emits TRUE afterwards',
      build: () => OnboardingCubit(
        sharedPreferences: prefs,
        initialState: false,
      ),
      act: (OnboardingCubit cubit) => cubit.finishOnboarding(),
      expect: () => [true],
      verify: (_) {
        expect(prefs.getBool(PrefsKeys.kIsOnboarded), true);
      },
    );
  });
}
