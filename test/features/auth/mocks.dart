import 'package:dropezy_proto/v1/customer/customer.pbgrpc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';

class MockCustomerServiceClient extends Mock implements CustomerServiceClient {}

class MockIPrefsRepository extends Mock implements IPrefsRepository {}

class MockDeviceFingerprintProvider extends Mock
    implements DeviceFingerprintProvider {}

class MockDeviceNameProvider extends Mock implements DeviceNameProvider {}
