import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/network/grpc/interceptors/auth/index.dart';
import 'package:storefront_app/features/auth/index.dart';

import '../../../../../src/mock_response_future.dart';
import 'mocks.dart';

void main() {
  group(
    'Auth gRPC Interceptor',
    () {
      late AuthInterceptor authInterceptor;
      late AuthService authService;

      const whitelistedPath = '/path/to/whitelist';
      const mockToken = 'token-123';
      const mockMetadata = {
        'key1': 'value1',
        'key2': 'value2',
      };

      setUp(() {
        authService = MockAuthService();
        authInterceptor = AuthInterceptor(
          authService: authService,
          whitelistedPaths: [whitelistedPath],
        );
      });

      void testForMetadataProvider({
        required String requestPath,
        required List<MetadataProvider> expectedProviders,
      }) {
        // only path needs to be set properly for this test's purpose
        final clientMethod = ClientMethod<Object, Object>(
          requestPath,
          (obj) => [0],
          (bytes) => Object(),
        );

        final metadata = Map<String, String>.from(mockMetadata);
        final callOptions = CallOptions(metadata: metadata);
        late CallOptions newOptions;

        // attempt interception
        authInterceptor.interceptUnary<Object, Object>(
          clientMethod,
          Object(),
          callOptions,
          (method, request, options) {
            newOptions = options;
            return MockResponseFuture.value(Object());
          },
        );

        expect(
          newOptions.metadataProviders,
          expectedProviders,
        );
      }

      test(
        'adds auth MetadataProvider to unary requests if path is not whitelisted',
        () {
          testForMetadataProvider(
            requestPath: '/path/to/intercept',
            expectedProviders: [authInterceptor.appendAuthMetadata],
          );
        },
      );

      test(
        'does not add auth MetadataProvider if path is whitelisted',
        () {
          testForMetadataProvider(
            requestPath: whitelistedPath,
            expectedProviders: [],
          );
        },
      );

      group(
        'appendAuthMetadata',
        () {
          test(
            "terminates if key 'authorization' is already set in metadata",
            () async {
              when(() => authService.getToken())
                  .thenAnswer((_) async => mockToken);

              final metadata = {
                'authorization': 'bearer adsf',
              };

              await authInterceptor.appendAuthMetadata(metadata, 'randomUri');

              // should not attempt to retrieve token
              // nor modifies the metadata
              verifyNever(() => authService.getToken());
              expect(
                metadata,
                {
                  'authorization': 'bearer adsf',
                },
              );
            },
          );

          test(
            'terminates if token is null (user is not logged in)',
            () async {
              when(() => authService.getToken()).thenAnswer((_) async => null);

              final metadata = {
                'key1': 'value1',
              };

              await authInterceptor.appendAuthMetadata(metadata, 'randomUri');

              // should not modify metadata
              verify(() => authService.getToken()).called(1);
              expect(
                metadata,
                {
                  'key1': 'value1',
                },
              );
            },
          );

          test(
            "appends key 'authorization' if not set and user is logged in",
            () async {
              when(() => authService.getToken())
                  .thenAnswer((_) async => mockToken);

              final metadata = {
                'key1': 'value1',
              };

              await authInterceptor.appendAuthMetadata(metadata, 'randomUri');

              // should append key 'authorization'
              verify(() => authService.getToken()).called(1);
              expect(
                metadata,
                {
                  'key1': 'value1',
                  'authorization': 'bearer $mockToken',
                },
              );
            },
          );
        },
      );
    },
  );
}
