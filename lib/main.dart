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
import 'core/services/geofence/models/dropezy_latlng.dart';
import 'core/services/geofence/models/dropezy_polygon.dart';
import 'di/config/di_config.dart';
import 'di/di_environment.dart';
import 'di/injection.dart';
import 'features/address/index.dart';
import 'features/cart_checkout/index.dart';
import 'features/home/index.dart';
import 'features/permission_handler/index.dart';
import 'features/product_search/index.dart';
import 'features/profile/index.dart';

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
      Hive.registerAdapter(SearchLocationHistoryQueryAdapter());
      Hive.registerAdapter(PlaceModelAdapter());
      Hive.registerAdapter(DropezyLatLngAdapter());
      Hive.registerAdapter(DropezyPolygonAdapter());

      // Dependency Injection
      await configureInjection(determineEnvironment());

      runApp(
        /// Reserved for BLocs that are needed by various pages
        /// but are difficult to scope
        MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => getIt<CartBloc>(),
            ),
            BlocProvider(
              create: (_) => getIt<DeliveryAddressCubit>(),
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
            ),

            // Profile
            BlocProvider(
              create: (context) => getIt<ProfileCubit>(),
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
