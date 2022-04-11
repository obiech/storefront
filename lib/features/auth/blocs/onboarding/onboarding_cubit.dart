import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/prefs/i_prefs_repository.dart';

/// A [Cubit] for emitting the current Onboarding Status
/// and to abstract away data persistence logic from the UI
///
/// Currently the initial state is injected through the constructor for simplicity,
/// but in the future we can move the initialization logic inside this [Cubit]
/// once the app initialization process gets more complex.
class OnboardingCubit extends Cubit<bool> {
  final IPrefsRepository sharedPreferences;

  OnboardingCubit({
    required this.sharedPreferences,
    required bool initialState,
  }) : super(initialState);

  /*Future<void> finishOnboarding() async {
    await sharedPreferences.setIsOnBoarded(true);

    emit(true);
  }*/
}
