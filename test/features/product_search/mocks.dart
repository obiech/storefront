import 'package:dropezy_proto/v1/search/search.pbgrpc.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/product_search/index.dart';

class MockSearchHistoryRepository extends Mock
    implements ISearchHistoryRepository {}

class MockProductSearchRepository extends Mock
    implements IProductSearchRepository {}

class MockSearchServiceClient extends Mock implements SearchServiceClient {}

class MockAutosuggestionBloc extends Mock implements AutosuggestionBloc {}

class MockSearchHistoryCubit extends Mock implements SearchHistoryCubit {}

class MockSearchInventoryBloc extends Mock implements SearchInventoryBloc {}

/// Hive
class MockDateTimeHiveBox extends Mock implements Box<DateTime> {}
