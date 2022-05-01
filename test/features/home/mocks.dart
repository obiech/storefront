import 'dart:io';

import 'package:dropezy_proto/v1/category/category.pbgrpc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/address/index.dart';
import 'package:storefront_app/features/auth/domain/services/user_credentials_storage.dart';
import 'package:storefront_app/features/home/index.dart';

class MockIParentCategoriesRepository extends Mock
    implements IParentCategoriesRepository {}

class MockParentCategoriesCubit extends Mock implements ParentCategoriesCubit {}

class MockHttpClient extends Mock implements HttpClient {}

class MockDeliveryAddressCubit extends Mock implements DeliveryAddressCubit {}

class MockUserCredentialsStorage extends Mock
    implements UserCredentialsStorage {}

class MockCategoryServiceClient extends Mock implements CategoryServiceClient {}
