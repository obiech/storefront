import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:uuid/uuid.dart';

import '../../../../services/device/repository/_exporter.dart';

/// Intercept unary request and send metadata that contains
/// - User Device Os Information
/// - User Device Model
/// - User App Version
/// - User Device public IPv4 Address
/// - UUID to uniquely identify each request
///
/// For values in Metadata, there should not be
/// any whitespaces like example shown. If values
/// got any whitespaces it should be automatically replace
/// by underscore (_) with ReGex.

/// Example:
/// OS-Version: android-7.1.2
/// Device-Model: vivo_1611
/// App-Version: 2.0.1
/// Origin-IP: 84.17.39.204
/// Locale: en-US
/// X-Correlation-ID: f058ebd6-02f7-4d3f-942e-904344e8cde5

class DeviceInterceptor extends ClientInterceptor {
  DeviceInterceptor({
    required this.userDeviceInfoProvider,
    required this.uuid,
  });

  final IUserDeviceInfoRepository userDeviceInfoProvider;

  final Uuid uuid;

  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    final newOptions = options.mergedWith(
      CallOptions(
        providers: [
          addOsVersion,
          addDeviceModel,
          addAppVersion,
          addOriginIp,
          addXCorrelationID,
          addDeviceLocale,
        ],
      ),
    );

    return invoker(method, request, newOptions);
  }

  @visibleForTesting
  Future<void> addOsVersion(
    Map<String, String> metadata,
    String uri,
  ) async {
    if (metadata['OS-Version'] != null) {
      return;
    }
    final osVersion = await userDeviceInfoProvider.getOsNameAndVersion();

    metadata['OS-Version'] = osVersion.replaceAll(RegExp(' '), '_');
  }

  @visibleForTesting
  Future<void> addDeviceModel(
    Map<String, String> metadata,
    String uri,
  ) async {
    if (metadata['Device-Model'] != null) {
      return;
    }

    final deviceModel = await userDeviceInfoProvider.getDeviceModel();

    metadata['Device-Model'] = deviceModel.replaceAll(RegExp(' '), '_');
  }

  @visibleForTesting
  Future<void> addAppVersion(
    Map<String, String> metadata,
    String uri,
  ) async {
    if (metadata['App-Version'] != null) {
      return;
    }

    final appVersion = await userDeviceInfoProvider.getAppVersionName();

    metadata['App-Version'] = appVersion.replaceAll(RegExp(' '), '_');
  }

  @visibleForTesting
  Future<void> addOriginIp(
    Map<String, String> metadata,
    String uri,
  ) async {
    if (metadata['Origin-IP'] != null) {
      return;
    }

    metadata['Origin-IP'] = await userDeviceInfoProvider.getOriginIP();
  }

  @visibleForTesting
  Future<void> addXCorrelationID(
    Map<String, String> metadata,
    String uri,
  ) async {
    if (metadata['X-Correlation-ID'] != null) {
      return;
    }

    metadata['X-Correlation-ID'] = uuid.v4();
  }

  @visibleForTesting
  void addDeviceLocale(
    Map<String, String> metadata,
    String uri,
  ) {
    final appLocale = userDeviceInfoProvider.getDeviceLocale();

    metadata['Locale'] = appLocale.toLanguageTag();
  }
}
