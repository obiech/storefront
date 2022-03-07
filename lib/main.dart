import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storefront_app/bloc/onboarding/onboarding_cubit.dart';
import 'package:storefront_app/constants/config/auth_config.dart';
import 'package:storefront_app/constants/config/grpc_config.dart';
import 'package:storefront_app/constants/prefs_keys.dart';
import 'package:storefront_app/domain/device/device_platform.dart';
import 'package:storefront_app/network/grpc/customer/customer.pbgrpc.dart';
import 'package:storefront_app/services/auth/auth_service.dart';
import 'package:storefront_app/services/auth/firebase_auth_service.dart';
import 'package:storefront_app/services/auth/prefs_user_credentials_storage.dart';
import 'package:storefront_app/services/auth/user_credentials_storage.dart';
import 'package:storefront_app/services/device/device_fingerprint_provider.dart';
import 'package:storefront_app/services/device/device_info_device_name_provider.dart';
import 'package:storefront_app/services/device/device_name_provider.dart';
import 'package:storefront_app/services/device/uuid_device_fingerprint_provider.dart';
import 'package:uuid/uuid.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  await _loadEnvVariables();
  await _initializeFirebase();
  _setupServices(prefs);
  _setupGrpcServices();

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

Future<void> _loadEnvVariables() async {
  await dotenv.load(fileName: 'env/.env');
}

Future<void> _initializeFirebase() async {
  await Firebase.initializeApp();
}

void _setupServices(SharedPreferences sharedPrefs) {
  final deviceInfoPlugin = DeviceInfoPlugin();
  const uuidPlugin = Uuid();

  final credsStorage = PrefsUserCredentialsStorage(sharedPrefs);
  final authService = FirebaseAuthService(
    credentialsStorage: credsStorage,
    firebaseAuth: FirebaseAuth.instance,
    otpTimeoutInSeconds: AuthConfig.otpTimeoutInSeconds,
  )..initialize();

  final deviceFingerprintProvider = UuidDeviceFingerprintProvider(uuidPlugin);
  final deviceNameProvider =
      DeviceInfoDeviceNameProvider(_getDevicePlatform(), deviceInfoPlugin);

  GetIt.I.registerSingleton<AuthService>(authService);
  GetIt.I.registerSingleton<UserCredentialsStorage>(credsStorage);
  GetIt.I
      .registerSingleton<DeviceFingerprintProvider>(deviceFingerprintProvider);
  GetIt.I.registerSingleton<DeviceNameProvider>(deviceNameProvider);
}

DevicePlatform _getDevicePlatform() {
  if (Platform.isAndroid) {
    return DevicePlatform.android;
  } else if (Platform.isIOS) {
    return DevicePlatform.ios;
  } else {
    throw UnsupportedError("Currently only supports Android and iOS platforms");
  }
}

/// Create a channel for gRPC connection
/// And registers gRPC [Client]s to Service Locator [GetIt]
void _setupGrpcServices() {
  //TODO (leovinsen): set up gRPC certificates for secure connection
  //TODO (leovinsen): throw an error if TLS is not enabled on production build
  final channel = ClientChannel(
    GrpcConfig.grpcServerUrl,
    port: GrpcConfig.grpcServerPort,
    options: ChannelOptions(
      connectionTimeout: const Duration(seconds: 5),
      credentials: GrpcConfig.grpcEnableTls
          ? const ChannelCredentials.secure()
          : const ChannelCredentials.insecure(),
      codecRegistry:
          CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
    ),
  );

  final customerServiceClient = CustomerServiceClient(channel);

  GetIt.I.registerSingleton<CustomerServiceClient>(customerServiceClient);
}
