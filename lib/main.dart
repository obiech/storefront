import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/config/test_config.dart';
import 'package:storefront_app/core/utils/is_test_mode.dart';

import 'app.dart';
import 'core/services/prefs/i_prefs_repository.dart';
import 'di/injection.dart';
import 'features/auth/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: 'env/.env');
  await Firebase.initializeApp();

  // Dependency Injection
  configureInjection(determineEnvironment());

  final prefs = getIt<IPrefsRepository>();
  final isOnboarded = await prefs.isOnBoarded();

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

String determineEnvironment() {
  if (kTestMode) {
    return Environment.test;
  }

  if (kReleaseMode || TestConfig.isEndToEndTest) {
    return Environment.prod;
  }

  return Environment.dev;
}
