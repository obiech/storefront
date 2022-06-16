import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/network/grpc/interceptors/device_info/device_info_interceptor.dart';
import 'package:storefront_app/core/services/device/user_device_info_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../../src/mock_response_future.dart';
import 'mocks.dart';

void main() {
  group('Device gRPC interceptor', () {
    late DeviceInterceptor deviceInterceptor;

    late UserDeviceInfoRepository mockUserDeviceInfoProvider;
    late Uuid mockUuid;

    const mockOs = 'android-7.1.2';
    const fakeDeviceModel = 'vivo 1611';

    const mockAppVersion = '2.0.1';
    const mockOriginIP = '84.17.39.204';
    const mockXCorrelationID = 'f058ebd6-02f7-4d3f-942e-904344e8cde5';
    const mockDeviceLocale = Locale('id', 'ID');

    const mockMetadata = {
      'OS-Version': 'value1',
      'Device-Model': 'value2',
      'App-Version': 'value3',
      'Origin-IP': 'value4',
      'X-Correlation-ID': 'value5',
      'Locale': 'id-ID',
    };

    setUp(() {
      mockUserDeviceInfoProvider = MockUserDeviceInfoProvider();
      mockUuid = MockUuid();

      deviceInterceptor = DeviceInterceptor(
        userDeviceInfoProvider: mockUserDeviceInfoProvider,
        uuid: mockUuid,
      );
    });

    void testForMetadataProvider({
      required List<MetadataProvider> expectedProviders,
    }) {
      final clientMethod = ClientMethod<Object, Object>(
        '',
        (obj) => [0],
        (bytes) => Object(),
      );

      final metadata = Map<String, String>.from(mockMetadata);
      final callOptions = CallOptions(metadata: metadata);
      late CallOptions newOptions;

      deviceInterceptor.interceptUnary<Object, Object>(
          clientMethod, Object(), callOptions, (method, request, options) {
        newOptions = options;
        return MockResponseFuture.value(Object());
      });

      expect(newOptions.metadataProviders, expectedProviders);
    }

    test('add MetadataProvider to unary request', () {
      testForMetadataProvider(
        expectedProviders: [
          deviceInterceptor.addOsVersion,
          deviceInterceptor.addDeviceModel,
          deviceInterceptor.addAppVersion,
          // deviceInterceptor.addOriginIp,
          deviceInterceptor.addXCorrelationID,
          deviceInterceptor.addDeviceLocale,
        ],
      );
    });
    group('Metadata provider ', () {
      test(
        "add OS into 'OS-Version'",
        () async {
          when(() => mockUserDeviceInfoProvider.getOsNameAndVersion())
              .thenAnswer((_) async => mockOs);

          final Map<String, String> metadata = {};

          await deviceInterceptor.addOsVersion(metadata, 'randomUri');

          verify(() => mockUserDeviceInfoProvider.getOsNameAndVersion())
              .called(1);
          expect(
            metadata,
            {
              'OS-Version': mockOs,
            },
          );
        },
      );
      test(
        "add device model into 'Device-Model'",
        () async {
          const mockDeviceModel = 'vivo_1611';
          when(() => mockUserDeviceInfoProvider.getDeviceModel())
              .thenAnswer((_) async => fakeDeviceModel);

          final Map<String, String> metadata = {};

          await deviceInterceptor.addDeviceModel(metadata, 'randomUri');

          verify(() => mockUserDeviceInfoProvider.getDeviceModel()).called(1);
          expect(
            metadata,
            {
              'Device-Model': mockDeviceModel,
            },
          );
        },
      );
      test(
        "add app version into 'App-Version'",
        () async {
          when(() => mockUserDeviceInfoProvider.getAppVersionName())
              .thenAnswer((_) async => mockAppVersion);

          final Map<String, String> metadata = {};

          await deviceInterceptor.addAppVersion(metadata, 'randomUri');

          verify(() => mockUserDeviceInfoProvider.getAppVersionName())
              .called(1);
          expect(
            metadata,
            {
              'App-Version': mockAppVersion,
            },
          );
        },
      );
      test(
        "add origin ip into 'Origin-IP'",
        () async {
          when(() => mockUserDeviceInfoProvider.getOriginIP())
              .thenAnswer((_) async => mockOriginIP);

          final Map<String, String> metadata = {};

          await deviceInterceptor.addOriginIp(metadata, 'randomUri');

          verify(() => mockUserDeviceInfoProvider.getOriginIP()).called(1);
          expect(
            metadata,
            {
              'Origin-IP': mockOriginIP,
            },
          );
        },
      );
      test(
        "add UUID into 'X-Correlation-ID'",
        () async {
          when(() => mockUuid.v4()).thenReturn(mockXCorrelationID);

          final Map<String, String> metadata = {};

          await deviceInterceptor.addXCorrelationID(metadata, 'randomUri');

          verify(() => mockUuid.v4()).called(1);
          expect(
            metadata,
            {
              'X-Correlation-ID': mockXCorrelationID,
            },
          );
        },
      );

      test(
        "add locale into 'Locale'",
        () async {
          when(() => mockUserDeviceInfoProvider.getDeviceLocale()).thenAnswer(
            (_) => mockDeviceLocale,
          );

          final Map<String, String> metadata = {};

          deviceInterceptor.addDeviceLocale(metadata, 'randomUri');

          verify(() => mockUserDeviceInfoProvider.getDeviceLocale()).called(1);
          expect(
            metadata,
            {
              'Locale': mockDeviceLocale.toLanguageTag(),
            },
          );
        },
      );
    });
  });
}
