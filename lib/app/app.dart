import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/bloc/onboarding/onboarding_cubit.dart';
import 'package:storefront_app/ui/home/home_screen.dart';
import 'package:storefront_app/ui/onboarding/onboarding_screen.dart';

import 'router.dart';
import 'theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dropezy',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: lightTheme,
      onGenerateRoute: appRouter,
      home: BlocBuilder<OnboardingCubit, bool>(
        builder: (_, isOnboarded) {
          return !isOnboarded ? const OnboardingScreen() : const HomeScreen();
        },
      ),
    );
  }
}
