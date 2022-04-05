import 'package:dart_ipify/dart_ipify.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core.dart';
import 'repository/_exporter.dart';

/// This [UserDeviceInfoRepository] class will inherit
/// method of [IUserDeviceInfoRepository] and will
/// return the value thats is needed.
///
@LazySingleton(as: IUserDeviceInfoRepository)
class UserDeviceInfoRepository extends IUserDeviceInfoRepository {
  UserDeviceInfoRepository({
    required this.packageInfo,
    required this.deviceInfoPlugin,
    required this.devicePlatform,
  });
  final PackageInfo packageInfo;
  final DeviceInfoPlugin deviceInfoPlugin;
  final DevicePlatform devicePlatform;

  /// Return current device's OS and version
  /// concantenated into single string. Example:
  ///
  /// android-7.1.2
  ///
  @override
  Future<String> getOsNameAndVersion() async {
    switch (devicePlatform) {
      case DevicePlatform.android:
        final AndroidDeviceInfo androidInfo =
            await deviceInfoPlugin.androidInfo;

        return 'android-${androidInfo.version.release}';
      case DevicePlatform.ios:
        final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;

        return 'ios-${iosInfo.systemVersion}';
    }
  }

  /// Return current device's model name.
  /// Example:
  ///
  /// vivo 1611
  ///
  @override
  Future<String> getDeviceModel() async {
    switch (devicePlatform) {
      case DevicePlatform.android:
        final AndroidDeviceInfo androidInfo =
            await deviceInfoPlugin.androidInfo;

        return androidInfo.model.toString();

      case DevicePlatform.ios:
        final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;

        return iosInfo.model.toString();
    }
  }

  /// Return current device's app version
  /// Example:
  ///
  /// 2.0.1
  ///
  @override
  Future<String> getAppVersionName() async {
    return packageInfo.version;
  }

  /// Return current device's public IP
  @override
  Future<String> getOriginIP() async {
    final originIP = await Ipify.ipv4();
    return originIP;
  }
}
