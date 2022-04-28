import 'package:dropezy_proto/v1/search/search.pbgrpc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/product_search/domain/domain.dart';

class MockSearchHistoryRepository extends Mock
    implements ISearchHistoryRepository {}

class MockProductSearchRepository extends Mock
    implements IProductSearchRepository {}

class MockSearchServiceClient extends Mock implements SearchServiceClient {}
