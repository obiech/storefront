import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/core/services/device/user_device_info_provider.dart';

import '../../../widget/onboarding/onboarding_page_test.dart';
import '../../network/grpc/interceptors/device_info/mocks.dart';

void main() {
  late PackageInfo packageInfo;
  late DeviceInfoPlugin deviceInfoPlugin;
  late DevicePlatform devicePlatform;
  late IPrefsRepository prefsRepository;

  setUp(() {
    packageInfo = MockPackageInfo();
    deviceInfoPlugin = MockDeviceInfoPlugin();
    prefsRepository = MockPrefsRepository();
    devicePlatform = DevicePlatform.android;
  });
  test('Get App-Version', () async {
    const mockVersion = '2.0.1';

    when(() => packageInfo.version).thenReturn(mockVersion);

    final UserDeviceInfoRepository apps = UserDeviceInfoRepository(
      packageInfo: packageInfo,
      deviceInfoPlugin: deviceInfoPlugin,
      devicePlatform: devicePlatform,
      prefs: prefsRepository,
    );
    final expectedVersion = await apps.getAppVersionName();

    expect(mockVersion, expectedVersion);
  });

  test(
      'should return Locale in [IPrefsRepository] '
      'when [getDeviceLocale] is called', () async {
    const mockLocale =
        Locale.fromSubtags(languageCode: 'id', countryCode: 'ID');

    when(() => prefsRepository.getDeviceLocale()).thenAnswer((_) => mockLocale);

    final UserDeviceInfoRepository apps = UserDeviceInfoRepository(
      packageInfo: packageInfo,
      deviceInfoPlugin: deviceInfoPlugin,
      devicePlatform: devicePlatform,
      prefs: prefsRepository,
    );
    final expectedLocale = apps.getDeviceLocale();

    expect(mockLocale, expectedLocale);
  });
}
