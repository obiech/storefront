import 'package:flutter/material.dart';

/// Repository for retrieving user device information,
/// such as device Os name and version, model,
/// app version, and public IP
///
abstract class IUserDeviceInfoRepository {
  Future<String> getOsNameAndVersion();
  Future<String> getDeviceModel();
  Future<String> getAppVersionName();
  Future<String> getOriginIP();
  Future<Locale> getDeviceLocale();
}
