import 'dart:async';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
import 'features/address/index.dart';
import 'features/cart_checkout/index.dart';
import 'features/discovery/index.dart';
import 'features/home/index.dart';
import 'features/permission_handler/index.dart';
import 'features/product_search/index.dart';

Future<void> main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await dotenv.load(fileName: 'env/.env');

      // Initialize Firebase depencencies
      // AppCheck must come after Firebase.initializeApp
      await Firebase.initializeApp();
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      await FirebaseAppCheck.instance.activate();

      await Hive.initFlutter();

      // Dependency Injection
      await configureInjection(determineEnvironment());

      runApp(
        /// Reserved for BLocs that are needed by various pages
        /// but are difficult to scope
        MultiBlocProvider(
          providers: [
            BlocProvider(
              lazy: false,
              create: (context) => getIt<DiscoveryCubit>()..loadStore(),
            ),
            BlocProvider(
              lazy: false,
              create: (context) => getIt<CartBloc>(),
            ),
            BlocProvider(
              lazy: false,
              create: (_) =>
                  getIt<DeliveryAddressCubit>()..fetchDeliveryAddresses(),
            ),

            /// Search
            BlocProvider(
              create: (_) => getIt<HomeNavCubit>(),
            ),
            BlocProvider(
              create: (_) => getIt<SearchHistoryCubit>(),
            ),
            BlocProvider(
              create: (_) => getIt<AutosuggestionBloc>(),
            ),
            BlocProvider(
              create: (_) => getIt<SearchInventoryBloc>(),
            ),

            /// Permission
            BlocProvider(
              create: (_) => getIt<PermissionHandlerCubit>(),
            )
          ],
          child: AppWidget(
            router: getIt<AppRouter>(),
          ),
        ),
      );
    },
    (error, stack) =>
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
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
