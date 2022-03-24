import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/config/external_url_config.dart';
import 'package:storefront_app/core/config/grpc_config.dart';

void main() {
  const testVariables = '''
    GRPC_SERVER_URL=http://localhost
    GRPC_SERVER_PORT=8443
    GRPC_ENABLE_TLS=false
    URL_PRIVACY_POLICY=https://dropezy.com/privacy
    URL_TERMS_CONDITIONS=https://dropezy.com/terms-and-conditions
      ''';
  test('[EnvVariables] should return the right environment variables', () {
    dotenv.testLoad(fileInput: testVariables);

    expect(GrpcConfig.grpcServerUrl, 'http://localhost');
    expect(GrpcConfig.grpcServerPort, 8443);
    expect(GrpcConfig.grpcEnableTls, false);
    expect(ExternalUrlConfig.urlPrivacyPolicy, 'https://dropezy.com/privacy');
    expect(
      ExternalUrlConfig.urlTermsConditions,
      'https://dropezy.com/terms-and-conditions',
    );
  });
}
