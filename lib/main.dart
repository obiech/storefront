import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:storefront_app/di/config/di_config.dart';

import 'app.dart';
import 'core/core.dart';
import 'di/config/di_config.dart';
import 'di/di_environment.dart';
import 'di/injection.dart';
import 'features/cart_checkout/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: 'env/.env');
  await Firebase.initializeApp();
  await Hive.initFlutter();

  // Dependency Injection
  await configureInjection(determineEnvironment());

  runApp(
    /// Reserved for BLocs that are needed by various pages
    /// but are difficult to scope
    MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: true,
          create: (context) => getIt<PaymentMethodCubit>(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => getIt<CartBloc>()..add(const LoadCart()),
        ),
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
