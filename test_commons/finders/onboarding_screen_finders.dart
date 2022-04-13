import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/auth/screens/onboarding/onboarding_screen.dart';
import 'package:storefront_app/features/auth/widgets/onboarding/keys.dart';

Finder finderOnboardingScreen = find.byType(OnboardingScreen);

Finder finderButtonRegister =
    find.byKey(const ValueKey(OnboardingViewKeys.buttonRegister));

Finder finderButtonLogin =
    find.byKey(const ValueKey(OnboardingViewKeys.buttonLogin));

Finder finderButtonSkipOnboarding =
    find.byKey(const ValueKey(OnboardingViewKeys.buttonSkipOnboarding));
