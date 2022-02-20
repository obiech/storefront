import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storefront_app/bloc/onboarding/onboarding_cubit.dart';
import 'package:storefront_app/constant/prefs_keys.dart';
import 'package:storefront_app/constants/config/grpc_config.dart';
import 'package:storefront_app/network/grpc/customer/customer.pbgrpc.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _loadEnvVariables();
  _setupGrpcServices();

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

Future<void> _loadEnvVariables() async {
  await dotenv.load(fileName: 'env/.env');
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
