import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:storefront_app/core/constants/device_platform.dart';
import 'package:storefront_app/core/services/device/user_device_info_provider.dart';

import '../../network/grpc/interceptors/device_info/mocks.dart';

void main() {
  late PackageInfo packageInfo;
  late DeviceInfoPlugin deviceInfoPlugin;
  late DevicePlatform devicePlatform;

  setUp(() {
    packageInfo = MockPackageInfo();
    deviceInfoPlugin = MockDeviceInfoPlugin();
    devicePlatform = DevicePlatform.android;
  });
  test('Get App-Version', () async {
    const mockVersion = '2.0.1';

    when(() => packageInfo.version).thenReturn(mockVersion);

    final UserDeviceInfoRepository apps = UserDeviceInfoRepository(
      packageInfo: packageInfo,
      deviceInfoPlugin: deviceInfoPlugin,
      devicePlatform: devicePlatform,
    );
    final expectedVersion = await apps.getAppVersionName();

    expect(mockVersion, expectedVersion);
  });
}
