import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/child_categories/index.dart';
import 'package:storefront_app/features/product_search/index.dart';

class MockChildCategoryCubit extends Mock implements ChildCategoryCubit {}

class MockCategoryProductCubit extends Mock implements CategoryProductCubit {}

class MockIProductInventoryRepo extends Mock
    implements IProductInventoryRepository {}

class MockHttpClient extends Mock implements HttpClient {}
