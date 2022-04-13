import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/home/domain/repository/i_parent_categories_repository.dart';
import 'package:storefront_app/features/home/index.dart';

class MockIParentCategoriesRepository extends Mock
    implements IParentCategoriesRepository {}

class MockParentCategoriesCubit extends Mock implements ParentCategoriesCubit {}

class MockHttpClient extends Mock implements HttpClient {}
