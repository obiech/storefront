import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storefront_app/bloc/onboarding/onboarding_cubit.dart';
import 'package:storefront_app/constant/prefs_keys.dart';
import 'package:storefront_app/network/grpc/customer/customer.pbgrpc.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

/// Create a channel for gRPC connection
/// And registers gRPC [Client]s to Service Locator [GetIt]
void _setupGrpcServices() {
  //TODO: use environment variables for gRPC url
  final channel = ClientChannel(
    'localhost',
    port: 8443,
    options: ChannelOptions(
      connectionTimeout: const Duration(seconds: 5),
      credentials: const ChannelCredentials.insecure(),
      codecRegistry:
          CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
    ),
  );

  final customerServiceClient = CustomerServiceClient(channel);

  GetIt.I.registerSingleton<CustomerServiceClient>(customerServiceClient);
}
