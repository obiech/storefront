import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:dropezy_proto/v1/category/category.pbgrpc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/address/index.dart';
import 'package:storefront_app/features/auth/index.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/discovery/index.dart';
import 'package:storefront_app/features/home/index.dart';
import 'package:storefront_app/features/product_search/index.dart';

class MockAuthService extends Mock implements AuthService {}

class MockIParentCategoriesRepository extends Mock
    implements IParentCategoriesRepository {}

class MockParentCategoriesCubit extends Mock implements ParentCategoriesCubit {}

class MockHttpClient extends Mock implements HttpClient {}

class MockDeliveryAddressCubit extends MockCubit<DeliveryAddressState>
    implements DeliveryAddressCubit {}

class MockCategoryServiceClient extends Mock implements CategoryServiceClient {}

class MockHomeNavCubit extends MockCubit<HomeNavState> implements HomeNavCubit {
}

class MockSearchInventoryBloc
    extends MockBloc<SearchInventoryEvent, SearchInventoryState>
    implements SearchInventoryBloc {}

class MockCartBloc extends MockBloc<CartEvent, CartState> implements CartBloc {}

class MockSearchHistoryCubit
    extends MockBloc<SearchHistoryEvent, SearchHistoryState>
    implements SearchHistoryCubit {}

class MockDiscoveryCubit extends MockCubit<String?> implements DiscoveryCubit {}
