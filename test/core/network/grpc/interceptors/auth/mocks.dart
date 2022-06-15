import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/auth/index.dart';

class MockAuthService extends Mock implements AuthService {}

class MockClientChannel extends Mock implements ClientChannel {}
