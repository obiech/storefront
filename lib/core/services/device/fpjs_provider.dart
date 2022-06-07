import 'package:fpjs_pro_plugin/fpjs_pro_plugin.dart';

import '../prefs/i_prefs_repository.dart';
import 'device_fingerprint_provider.dart';

/// Generate FingerPrint for Device using [FpjsProPlugin] Plugin
///
/// It throws an [Exception] if no fingerPrint
class FingerPrintJsProvider extends DeviceFingerprintProvider {
  final IPrefsRepository sharedPreferences;
  final FpJsProPluginWrapper wrapper;
  FingerPrintJsProvider({
    required this.sharedPreferences,
    this.wrapper = const FpJsProPluginWrapper(),
  });
  @override
  Future<String> getFingerprint() async {
    String? newFingerprint;
    final savedFingerprint = sharedPreferences.getFingerPrint();

    if (savedFingerprint != null) {
      return savedFingerprint;
    }

    newFingerprint = await wrapper();
    if (newFingerprint != null) {
      sharedPreferences.setFingerPrint(newFingerprint);
      return newFingerprint;
    }
    // TODO Handle Exception. Convert Exception to Failure.
    throw Exception();
  }
}

/// A wrapper around [FpjsProPlugin.getVisitorId()] static method
/// To make it testable.
class FpJsProPluginWrapper {
  const FpJsProPluginWrapper();

  Future<String?> call() {
    return FpjsProPlugin.getVisitorId();
  }
}
