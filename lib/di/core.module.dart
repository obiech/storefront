import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/auth/domain/domain.dart';
import 'package:storefront_app/features/order/index.dart';
import 'package:uuid/uuid.dart';

import '../features/cart_checkout/index.dart';

@module
abstract class CoreModule {
  AppRouter router(IPrefsRepository prefs, IOrderRepository orderRepository) {
    return AppRouter(
      checkOrderStatus: CheckOrderStatus(orderRepository),
      checkAuthStatus: CheckAuthStatus(prefs),
    );
  }

  @lazySingleton
  Uuid get uuid => const Uuid();

  @lazySingleton
  DevicePlatform get devicePlatform {
    if (Platform.isAndroid) {
      return DevicePlatform.android;
    } else if (Platform.isIOS) {
      return DevicePlatform.ios;
    } else {
      throw UnsupportedError(
        'Currently only supports Android and iOS platforms',
      );
    }
  }

  @lazySingleton
  DeviceInfoPlugin get deviceInfo => DeviceInfoPlugin();

  @preResolve
  Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();

  @Named(PREF_BOX)
  @singleton
  @preResolve
  Future<Box> get prefsBox => Hive.openBox(PREF_BOX);
}
