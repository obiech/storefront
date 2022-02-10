import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/network/grpc/customer/customer.pbgrpc.dart';

/// Generates stubs for all functions in [CustomerServiceClient]
class MockCustomerServiceClient extends Mock implements CustomerServiceClient {}
