import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/constants/device_platform.dart';
import 'package:storefront_app/core/services/device/index.dart';

class MockDeviceInfoPlugin extends Mock implements DeviceInfoPlugin {}

class MockAndroidDeviceInfo extends Mock implements AndroidDeviceInfo {}

class MockIosDeviceInfo extends Mock implements IosDeviceInfo {}

void main() {
  group('DeviceInfoDeviceNameProvider', () {
    late DeviceInfoPlugin deviceInfoPlugin;
    late DeviceInfoDeviceNameProvider deviceNameProvider;
    late AndroidDeviceInfo androidDeviceInfo;
    late IosDeviceInfo iosDeviceInfo;

    setUpAll(() {
      deviceInfoPlugin = MockDeviceInfoPlugin();
      androidDeviceInfo = MockAndroidDeviceInfo();
      iosDeviceInfo = MockIosDeviceInfo();

      when(() => deviceInfoPlugin.androidInfo)
          .thenAnswer((_) async => androidDeviceInfo);
      when(() => deviceInfoPlugin.iosInfo)
          .thenAnswer((_) async => iosDeviceInfo);
    });

    group('[getDeviceName()]', () {
      group('on Android', () {
        setUpAll(() {
          deviceNameProvider = DeviceInfoDeviceNameProvider(
            DevicePlatform.android,
            deviceInfoPlugin,
          );
        });

        test(
          'should return device model',
          () async {
            const fakeDeviceModel = 'Samsung GT-1234';
            when(() => androidDeviceInfo.model).thenReturn(fakeDeviceModel);

            final name = await deviceNameProvider.getDeviceName();

            expect(name, fakeDeviceModel);
          },
        );

        test(
          'should return device manufacturer if device model unavailable',
          () async {
            const fakeDeviceManufacturer = 'Samsung';
            when(() => androidDeviceInfo.model).thenReturn(null);
            when(() => androidDeviceInfo.manufacturer)
                .thenReturn(fakeDeviceManufacturer);

            final name = await deviceNameProvider.getDeviceName();

            expect(name, fakeDeviceManufacturer);
          },
        );

        test(
          "should return 'Unknown Android Device' if device model and name unavailable",
          () async {
            when(() => androidDeviceInfo.model).thenReturn(null);
            when(() => androidDeviceInfo.manufacturer).thenReturn(null);

            final name = await deviceNameProvider.getDeviceName();

            expect(name, 'Unknown Android Device');
          },
        );
      });

      group('on iOS', () {
        setUpAll(() {
          deviceNameProvider = DeviceInfoDeviceNameProvider(
            DevicePlatform.ios,
            deviceInfoPlugin,
          );
        });

        test(
          'should return device name',
          () async {
            const fakeDeviceName = "Leonardo's iPhone";
            when(() => iosDeviceInfo.name).thenReturn(fakeDeviceName);

            final name = await deviceNameProvider.getDeviceName();

            expect(name, fakeDeviceName);
          },
        );

        test(
          'should return device model if device name unavailable',
          () async {
            const fakeDeviceModel = 'iPhone 12 Pro Max';
            when(() => iosDeviceInfo.name).thenReturn(null);
            when(() => iosDeviceInfo.model).thenReturn(fakeDeviceModel);

            final name = await deviceNameProvider.getDeviceName();

            expect(name, fakeDeviceModel);
          },
        );

        test(
          "should return 'Unknown iOS Device' if device model and name unavailable",
          () async {
            when(() => iosDeviceInfo.name).thenReturn(null);
            when(() => iosDeviceInfo.model).thenReturn(null);

            final name = await deviceNameProvider.getDeviceName();

            expect(name, 'Unknown iOS Device');
          },
        );
      });
    });
  });
}
