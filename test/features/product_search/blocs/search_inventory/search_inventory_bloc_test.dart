import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/product_search/index.dart';

import '../../fixtures.dart';
import '../../mocks.dart';

void main() {
  late SearchInventoryBloc bloc;
  late IProductSearchRepository repository;
  late ISearchHistoryRepository searchHistoryRepository;

  String _query = '';
  const limitPerPage = 5;
  const mockStoreId = 'store-id-1';

  setUp(() {
    repository = MockProductSearchRepository();
    searchHistoryRepository = MockSearchHistoryRepository();
    bloc = SearchInventoryBloc(
      repository,
      searchHistoryRepository,
    );

    when(
      () => repository.searchInventoryForItems(
        any(),
        mockStoreId,
        page: any(named: 'page'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((invocation) async {
      _query = invocation.positionalArguments.first.toString();
      final page = invocation.namedArguments[const Symbol('page')] as int;
      // final limit = invocation.namedArguments[const Symbol('limit')] as int;

      final pageResults =
          pageInventory.skip(page * limitPerPage).take(limitPerPage).toList();

      return pageResults.isEmpty
          ? left(NoInventoryResults())
          : right(pageResults);
    });

    when(() => searchHistoryRepository.addSearchQuery(any()))
        .thenAnswer((_) async => []);
  });

  test(
      'Default state is [SearchInventoryInitial], '
      'page count is zero, query is empty '
      'and inventory list is empty', () async {
    expect(bloc.state, isA<SearchInventoryInitial>());
    expect(bloc.page, 0);
    expect(bloc.query.isEmpty, true);
    expect(bloc.inventory.isEmpty, true);
  });

  blocTest<SearchInventoryBloc, SearchInventoryState>(
    'When [searchInventory] is called, page, query & inventory are reset '
    'then loading shown and if successful a full list of inventory results emitted',
    build: () => bloc,
    act: (cubit) => cubit.add(SearchInventory('beans', mockStoreId)),
    expect: () => [
      isA<SearchingForItemInInventory>(),
      InventoryItemResults(
        pageInventory.take(limitPerPage).toList(),
        mockStoreId,
      )
    ],
    verify: (bloc) {
      verify(
        () => repository.searchInventoryForItems(
          any(),
          mockStoreId,
          limit: any(named: 'limit'),
        ),
      ).called(1);

      expect(bloc.query, _query);
      expect(bloc.page, 0);

      expect(bloc.inventory, pageInventory.take(limitPerPage).toList());
    },
  );

  blocTest<SearchInventoryBloc, SearchInventoryState>(
    'When no results are returned during [searchInventory], an error state is emitted',
    setUp: () {
      when(
        () => repository.searchInventoryForItems(
          any(),
          mockStoreId,
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => left(NoInventoryResults()));
    },
    build: () => bloc,
    act: (cubit) => cubit.add(
      SearchInventory(
        'beans',
        mockStoreId,
      ),
    ),
    expect: () => [
      isA<SearchingForItemInInventory>(),
      isA<ErrorOccurredSearchingForItem>(),
    ],
  );

  blocTest<SearchInventoryBloc, SearchInventoryState>(
    'When an error occurs during [searchInventory], an error state is emitted',
    setUp: () {
      when(
        () => repository.searchInventoryForItems(
          any(),
          mockStoreId,
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => left(NetworkError(Exception().toFailure)));
    },
    build: () => bloc,
    act: (cubit) => cubit.add(SearchInventory('beans', mockStoreId)),
    expect: () => [
      isA<SearchingForItemInInventory>(),
      isA<ErrorOccurredSearchingForItem>(),
    ],
  );

  blocTest<SearchInventoryBloc, SearchInventoryState>(
    'When [loadMoreItems] is called, the existing query is used to query more items from the repository and '
    'When no items are returned during [loadMoreItems], we assume that the last page has been reached',
    build: () => bloc,
    act: (cubit) async {
      cubit.add(SearchInventory('beans', mockStoreId));
      await Future.delayed(const Duration(milliseconds: 400));
      cubit.add(LoadMoreItems());
      await Future.delayed(const Duration(milliseconds: 400));
    },
    expect: () {
      expect(bloc.query, _query);
      expect(bloc.page, 1);

      /// Page One
      final pageOneResults = pageInventory.take(limitPerPage).toList();

      /// Page two
      final pageTwoResults =
          pageInventory.skip(limitPerPage).take(limitPerPage).toList();

      expect(bloc.inventory, pageOneResults + pageTwoResults);

      return [
        isA<SearchingForItemInInventory>(),
        InventoryItemResults(
          pageOneResults,
          mockStoreId,
        ),
        InventoryItemResults(
          pageOneResults,
          mockStoreId,
          isLoadingMore: true,
        ),
        InventoryItemResults(
          pageOneResults + pageTwoResults,
          mockStoreId,
          isAtEnd: true,
        ),
      ];
    },
    verify: (_) {
      verify(
        () => repository.searchInventoryForItems(
          any(),
          mockStoreId,
          limit: any(named: 'limit'),
        ),
      ).called(1);

      verify(
        () => repository.searchInventoryForItems(
          any(),
          mockStoreId,
          limit: any(named: 'limit'),
          page: 1,
        ),
      ).called(1);
    },
  );

  /// Page One
  final pageOneResults = pageInventory.take(limitPerPage).toList();

  blocTest<SearchInventoryBloc, SearchInventoryState>(
    'When an error occurs during loading, more items nothing should happen',
    setUp: () {
      when(
        () => repository.searchInventoryForItems(
          any(),
          mockStoreId,
          limit: any(named: 'limit'),
          page: 1,
        ),
      ).thenAnswer((_) async => left(NetworkError(Exception().toFailure)));
    },
    build: () => bloc,
    act: (cubit) async {
      cubit.add(SearchInventory('beans', mockStoreId));
      await Future.delayed(const Duration(milliseconds: 400));
      cubit.add(LoadMoreItems());
      await Future.delayed(const Duration(milliseconds: 400));
    },
    expect: () => [
      isA<SearchingForItemInInventory>(),
      InventoryItemResults(pageOneResults, mockStoreId),
      InventoryItemResults(pageOneResults, mockStoreId, isLoadingMore: true),
      InventoryItemResults(pageOneResults, mockStoreId),
    ],
    verify: (bloc) {
      verify(
        () => repository.searchInventoryForItems(
          any(),
          mockStoreId,
          limit: any(named: 'limit'),
        ),
      ).called(1);
      verify(
        () => repository.searchInventoryForItems(
          any(),
          mockStoreId,
          limit: any(named: 'limit'),
          page: 1,
        ),
      ).called(1);

      expect(bloc.query, _query);
      expect(bloc.page, 0);

      /// Page One
      final pageOneResults = pageInventory.take(limitPerPage).toList();

      expect(bloc.inventory, pageOneResults);
    },
  );
}
