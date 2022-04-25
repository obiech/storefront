import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:storefront_app/di/config/di_config.dart';
import 'package:storefront_app/features/home/blocs/categories_one/cubit/categories_one_cubit.dart';

import 'app.dart';
import 'core/core.dart';
import 'di/di_environment.dart';
import 'di/injection.dart';
import 'features/auth/index.dart';
import 'features/cart_checkout/index.dart';
import 'features/order/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: 'env/.env');
  await Firebase.initializeApp();

  // Dependency Injection
  await configureInjection(determineEnvironment());

  runApp(
    MultiBlocProvider(
      providers: [
        // BlocProvider<OnboardingCubit>(
        //   create: (_) => OnboardingCubit(
        //     sharedPreferences: prefs,
        //     initialState: isOnboarded,
        //   ),
        // ),
        // BlocProvider<AccountVerificationCubit>(
        //   create: (context) => AccountVerificationCubit(
        //     authService,
        //     customerServiceClient,
        //     widget.registerAccountAfterSuccessfulOtp,
        //   )..sendOtp(widget.phoneNumberIntlFormat)
        BlocProvider(
          lazy: true,
          create: (context) => getIt<PaymentMethodCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<AccountAvailabilityCubit>(),
        ),
        BlocProvider(
          lazy: true,
          create: (_) => getIt<PinRegistrationCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<OrderHistoryCubit>()..fetchUserOrderHistory(),
        ),
        BlocProvider<CategoriesOneCubit>(
          create: (_) => getIt<CategoriesOneCubit>()..fetchCategoriesOne(),
        )
      ],
      child: AppWidget(
        router: getIt<AppRouter>(),
      ),
    ),
  );
}

String determineEnvironment() {
  if (DiConfig.enableDummyRepos) {
    return DiEnvironment.dummy;
  }

  if (kTestMode) {
    return DiEnvironment.test;
  }

  if (kReleaseMode || TestConfig.isEndToEndTest) {
    return DiEnvironment.prod;
  }

  return DiEnvironment.dev;
}
