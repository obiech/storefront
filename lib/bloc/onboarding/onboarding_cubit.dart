import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storefront_app/constant/prefs_keys.dart';

/// A [Cubit] for emitting the current Onboarding Status
/// and to abstract away data persistence logic from the UI
///
/// Currently the initial state is injected through the constructor for simplicity,
/// but in the future we can move the initialization logic inside this [Cubit]
/// once the app initialization process gets more complex.
class OnboardingCubit extends Cubit<bool> {
  final SharedPreferences sharedPreferences;

  OnboardingCubit({
    required this.sharedPreferences,
    required bool initialState,
  }) : super(initialState);

  void finishOnboarding() async {
    await sharedPreferences.setBool(PrefsKeys.kIsOnboarded, true);

    emit(true);
  }
}
