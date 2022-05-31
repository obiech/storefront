import 'package:fpjs_pro_plugin/fpjs_pro_plugin.dart';
import 'package:fpjs_pro_plugin/region.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../core/config/fpjs_config.dart';
import '../core/core.dart';
import '../core/services/device/fpjs_provider.dart';
import 'di_environment.dart';

/// Finger print dependencies module.
///
/// Dependencies provision for [DeviceFingerprintProvider] service.
@module
abstract class FingerprintSingleton {
  @LazySingleton(env: [DiEnvironment.prod])
  @preResolve
  Future<DeviceFingerprintProvider> fingerprintProvider({
    required IPrefsRepository sharedPreferences,
  }) async {
    await FpjsProPlugin.initFpjs(FpjsConfig.fpjsApiKey, region: Region.ap);
    return FingerPrintJsProvider(
      sharedPreferences: sharedPreferences,
    );
  }

  @LazySingleton(env: [DiEnvironment.dev, DiEnvironment.dummy])
  DeviceFingerprintProvider fingerprintProviderDev({
    required Uuid uuid,
    required IPrefsRepository sharedPreferences,
  }) {
    return UuidDeviceFingerprintProvider(uuid, sharedPreferences);
  }
}
