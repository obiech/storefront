import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/constants/device_platform.dart';

import 'device_name_provider.dart';

@LazySingleton(as: DeviceNameProvider)
class DeviceInfoDeviceNameProvider extends DeviceNameProvider {
  DeviceInfoDeviceNameProvider(this.devicePlatform, this.deviceInfoPlugin);

  final DevicePlatform devicePlatform;
  final DeviceInfoPlugin deviceInfoPlugin;

  /// On Android, retrieves Android model (e.g. Samsung SM-G991).
  /// Falls back to Manufacturer name. If both are unavailable,
  /// return 'Unknown Android Device';
  ///
  /// On iOS, retrieves Device name (e.g. Leonardo's iPhone). Falls back to
  /// Model name (e.g. iPhone). If both are unavailable,
  /// return 'Unknown iOS Device';
  ///
  /// If model name is not human-friendly enough, we can lookup the marketed
  /// name using https://pub.dev/packages/device_marketing_names.
  @override
  Future<String> getDeviceName() async {
    switch (devicePlatform) {
      case DevicePlatform.android:
        final AndroidDeviceInfo androidInfo =
            await deviceInfoPlugin.androidInfo;

        return androidInfo.model ??
            androidInfo.manufacturer ??
            'Unknown Android Device';
      case DevicePlatform.ios:
        final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;

        return iosInfo.name ?? iosInfo.model ?? 'Unknown iOS Device';
    }
  }
}
