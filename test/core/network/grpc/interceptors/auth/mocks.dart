import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/auth/domain/services/user_credentials_storage.dart';

class MockUserCredentialsStorage extends Mock
    implements UserCredentialsStorage {}

class MockClientChannel extends Mock implements ClientChannel {}
