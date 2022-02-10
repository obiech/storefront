import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storefront_app/bloc/onboarding/onboarding_cubit.dart';
import 'package:storefront_app/constant/prefs_keys.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final isOnboarded = prefs.getBool(PrefsKeys.kIsOnboarded) ?? false;
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<OnboardingCubit>(
          create: (_) => OnboardingCubit(
            sharedPreferences: prefs,
            initialState: isOnboarded,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
