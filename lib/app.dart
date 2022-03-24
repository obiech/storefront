import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router.dart';
import 'core/theme.dart';
import 'features/auth/index.dart';
import 'features/home/index.dart';

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
