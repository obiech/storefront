import 'package:dropezy_proto/v1/customer/customer.pbgrpc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/services/prefs/i_prefs_repository.dart';
import 'package:storefront_app/features/auth/index.dart';

/// Generates stubs for all functions in [CustomerServiceClient]
class MockCustomerServiceClient extends Mock implements CustomerServiceClient {}

/// Generates stubs for all functions in [IPrefsRepository]
class MockIPrefsRepository extends Mock implements IPrefsRepository {}

class MockCustomerRepository extends Mock implements ICustomerRepository {}
