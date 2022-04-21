import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:storefront_app/features/product_search/index.dart';

import '../../fixtures.dart';
import '../../mocks.dart';

void main() {
  late SearchInventoryCubit cubit;
  late IProductSearchRepository repository;

  String _query = '';
  const limitPerPage = 5;

  setUp(() {
    repository = MockProductSearchRepository();
    cubit = SearchInventoryCubit(repository);

    when(
      () => repository.searchInventoryForItems(
        any(),
        page: any(named: 'page'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((invocation) async {
      _query = invocation.positionalArguments.first.toString();
      final page = invocation.namedArguments[const Symbol('page')] as int;
      // final limit = invocation.namedArguments[const Symbol('limit')] as int;

      return pageInventory
          .skip(page * limitPerPage)
          .take(limitPerPage)
          .toList();
    });
  });

  test(
      'Default state is [SearchInventoryInitial], '
      'page count is zero, query is empty '
      'and inventory list is empty', () async {
    expect(cubit.state, isA<SearchInventoryInitial>());
    expect(cubit.page, 0);
    expect(cubit.query.isEmpty, true);
    expect(cubit.inventory.isEmpty, true);
  });

  blocTest<SearchInventoryCubit, SearchInventoryState>(
    'When [searchInventory] is called, page, query & inventory are reset '
    'then loading shown and if successful a full list of inventory results emitted',
    build: () => cubit,
    act: (cubit) => cubit.searchInventory('beans'),
    expect: () {
      verify(
        () => repository.searchInventoryForItems(any()),
      ).called(1);

      expect(cubit.query, _query);
      expect(cubit.page, 0);

      final pageZeroResults = pageInventory.take(limitPerPage).toList();
      expect(cubit.inventory, pageZeroResults);

      return [
        isA<SearchingForItemInInventory>(),
        InventoryItemResults(pageZeroResults)
      ];
    },
  );

  blocTest<SearchInventoryCubit, SearchInventoryState>(
    'When no results are returned during [searchInventory], an error state is emitted',
    setUp: () {
      when(() => repository.searchInventoryForItems(any()))
          .thenAnswer((_) async => []);
    },
    build: () => cubit,
    act: (cubit) => cubit.searchInventory('beans'),
    expect: () => [
      isA<SearchingForItemInInventory>(),
      isA<ErrorOccurredSearchingForItem>(),
    ],
  );

  blocTest<SearchInventoryCubit, SearchInventoryState>(
    'When an error occurs during [searchInventory], an error state is emitted',
    setUp: () {
      when(() => repository.searchInventoryForItems(any()))
          .thenThrow(Exception('Some error has occurred'));
    },
    build: () => cubit,
    act: (cubit) => cubit.searchInventory('beans'),
    expect: () => [
      isA<SearchingForItemInInventory>(),
      isA<ErrorOccurredSearchingForItem>(),
    ],
  );

  blocTest<SearchInventoryCubit, SearchInventoryState>(
    'When [loadMoreItems] is called, the existing query is used to query more items from the repository',
    build: () => cubit,
    act: (cubit) async {
      await cubit.searchInventory('beans');
      await cubit.loadMoreItems();
    },
    expect: () {
      verify(() => repository.searchInventoryForItems(any())).called(1);
      verify(() => repository.searchInventoryForItems(any(), page: 1))
          .called(1);

      expect(cubit.query, _query);
      expect(cubit.page, 1);

      /// Page One
      final pageOneResults = pageInventory.take(limitPerPage).toList();

      /// Page two
      final pageTwoResults =
          pageInventory.skip(limitPerPage).take(limitPerPage).toList();

      expect(cubit.inventory, pageOneResults + pageTwoResults);

      return [
        isA<SearchingForItemInInventory>(),
        InventoryItemResults(pageOneResults),
        InventoryItemResults(pageOneResults + pageTwoResults),
      ];
    },
  );

  blocTest<SearchInventoryCubit, SearchInventoryState>(
    'When no items are returned during [loadMoreItems], we assume that the last page has been reached',
    build: () => cubit,
    act: (cubit) async {
      await cubit.searchInventory('beans');
      await cubit.loadMoreItems();
      await cubit.loadMoreItems();
    },
    expect: () {
      verify(() => repository.searchInventoryForItems(any())).called(1);
      verify(() => repository.searchInventoryForItems(any(), page: 1))
          .called(1);
      verify(() => repository.searchInventoryForItems(any(), page: 2))
          .called(1);

      expect(cubit.query, _query);
      expect(cubit.page, 1);

      /// Page One
      final pageOneResults = pageInventory.take(limitPerPage).toList();

      /// Page two
      final pageTwoResults =
          pageInventory.skip(limitPerPage).take(limitPerPage).toList();
      expect(cubit.inventory, pageOneResults + pageTwoResults);

      return [
        isA<SearchingForItemInInventory>(),
        InventoryItemResults(pageOneResults),
        InventoryItemResults(pageOneResults + pageTwoResults),

        /// TODO - Handle isAtEnd
      ];
    },
  );

  blocTest<SearchInventoryCubit, SearchInventoryState>(
    'When an error occurs during loading, more items nothing should happen',
    setUp: () {
      when(() => repository.searchInventoryForItems(any(), page: 1))
          .thenThrow(Exception('Some weird error'));
    },
    build: () => cubit,
    act: (cubit) async {
      await cubit.searchInventory('beans');
      await cubit.loadMoreItems();
    },
    expect: () {
      verify(() => repository.searchInventoryForItems(any())).called(1);
      verify(() => repository.searchInventoryForItems(any(), page: 1))
          .called(1);

      expect(cubit.query, _query);
      expect(cubit.page, 0);

      /// Page One
      final pageOneResults = pageInventory.take(limitPerPage).toList();

      expect(cubit.inventory, pageOneResults);

      return [
        isA<SearchingForItemInInventory>(),
        InventoryItemResults(pageOneResults),
      ];
    },
  );
}
