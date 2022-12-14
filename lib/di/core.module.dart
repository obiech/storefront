import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/auth/domain/domain.dart';
import 'package:storefront_app/features/order/index.dart';
import 'package:uuid/uuid.dart';

import '../core/services/geofence/models/dropezy_polygon.dart';
import '../features/cart_checkout/index.dart';
import '../res/strings/base_strings.dart';
import '../res/strings/base_strings.ext.dart';

@module
abstract class CoreModule {
  AppRouter router(AuthService authService, IOrderRepository orderRepository) {
    return AppRouter(
      checkOrderStatus: CheckOrderStatus(orderRepository),
      checkAuthStatus: CheckAuthStatus(authService),
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

  @Named(GEOFENCE_PREF_BOX)
  @singleton
  @preResolve
  Future<Box<DropezyPolygon>> get geofencePrefsBox =>
      Hive.openBox(GEOFENCE_PREF_BOX);

  /// To access translations in Bloc & repositories,
  /// [BaseStrings] can be injected
  /// TODO(obella): Update factory on [Locale] change
  BaseStrings appStrings(IPrefsRepository prefs) =>
      prefs.getDeviceLocale().strings;
}
