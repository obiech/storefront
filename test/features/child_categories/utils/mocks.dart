import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/child_categories/index.dart';
import 'package:storefront_app/features/discovery/index.dart';
import 'package:storefront_app/features/product_search/index.dart';

class MockChildCategoryCubit extends Mock implements ChildCategoryCubit {}

class MockCategoryProductCubit extends Mock implements CategoryProductCubit {}

class MockIProductInventoryRepo extends Mock
    implements IProductInventoryRepository {}

class MockHttpClient extends Mock implements HttpClient {}

class MockDiscoveryCubit extends MockCubit<String?> implements DiscoveryCubit {}

class MockCartBloc extends MockBloc<CartEvent, CartState> implements CartBloc {}
