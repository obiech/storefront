import 'package:device_info_plus/device_info_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:storefront_app/core/services/device/user_device_info_provider.dart';
import 'package:uuid/uuid.dart';

class MockUserDeviceInfoProvider extends Mock
    implements UserDeviceInfoRepository {}

class MockUuid extends Mock implements Uuid {}

class MockDeviceInfoPlugin extends Mock implements DeviceInfoPlugin {}

class MockAndroidDeviceInfo extends Mock implements AndroidDeviceInfo {}

class MockIosDeviceInfo extends Mock implements IosDeviceInfo {}

class MockAndroidBuildVersion extends Mock implements AndroidBuildVersion {}

class MockPackageInfo extends Mock implements PackageInfo {}
