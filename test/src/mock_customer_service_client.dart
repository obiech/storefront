import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/network/grpc/customer/customer.pbgrpc.dart';
import 'package:storefront_app/core/services/prefs/i_prefs_repository.dart';

/// Generates stubs for all functions in [CustomerServiceClient]
class MockCustomerServiceClient extends Mock implements CustomerServiceClient {}

/// Generates stubs for all functions in [IPrefsRepository]
class MockIPrefsRepository extends Mock implements IPrefsRepository {}
