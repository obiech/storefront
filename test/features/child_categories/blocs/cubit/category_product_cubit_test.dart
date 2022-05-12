import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/errors/failure.dart';
import 'package:storefront_app/features/child_categories/index.dart';
import 'package:storefront_app/features/product_search/domain/domain.dart';

import '../../../../../test_commons/fixtures/product/product_models.dart'
    as fixtures;
import '../../utils/mocks.dart';

void main() {
  late IProductInventoryRepository repository;

  CategoryProductCubit createCubit() {
    return CategoryProductCubit(repository);
  }

  setUp(() {
    repository = MockIProductInventoryRepo();
  });

  group(
    '[CategoryProductState]',
    () {
      test('Initial state should be [InitialCategoryProductState]', () {
        final categoryProductCubit = createCubit();
        expect(categoryProductCubit.state, InitialCategoryProductState());
      });
      group(
        '[fetchCategoryProduct()] emits [LoadingCategoryProductState] followed by',
        () {
          blocTest<CategoryProductCubit, CategoryProductState>(
            '[LoadedCategoryProductState] with result from '
            '[repository.getCategoryProduct(categoryID)]',
            setUp: () {
              when(() => repository.getProductByCategory('4')).thenAnswer(
                (_) async => right(fixtures.fakeCategoryProductList),
              );
            },
            build: () => createCubit(),
            act: (cubit) => [
              cubit.fetchCategoryProduct('4'),
            ],
            expect: () => [
              LoadingCategoryProductState(),
              LoadedCategoryProductState(
                fixtures.fakeCategoryProductList,
              ),
            ],
            verify: (cubit) {
              verify(() => repository.getProductByCategory('4')).called(1);
            },
          );

          blocTest<CategoryProductCubit, CategoryProductState>(
            'Change category product of [LoadedCategoryProductState] '
            'with result from [repository.getCategoryProduct(categoryID)]',
            setUp: () {
              when(() => repository.getProductByCategory('2')).thenAnswer(
                (_) async => right(fixtures.fakeCategoryProductList),
              );
            },
            build: () => createCubit(),
            seed: () => LoadedCategoryProductState(
              fixtures.fakeCategoryProductList,
            ),
            act: (cubit) => [cubit.fetchCategoryProduct('2')],
            expect: () => [
              LoadingCategoryProductState(),
              LoadedCategoryProductState(
                fixtures.fakeCategoryProductList,
              ),
            ],
            verify: (cubit) {
              verify(() => repository.getProductByCategory('2')).called(1);
            },
          );

          blocTest<CategoryProductCubit, CategoryProductState>(
            '[ErrorCategoryProductState] if [repository.getCategoryProduct(categoryID)] '
            'returns a failure',
            setUp: () {
              when(() => repository.getProductByCategory('3')).thenAnswer(
                (_) async => left(
                  Failure('Failed to load category product'),
                ),
              );
            },
            build: () => createCubit(),
            act: (cubit) => cubit.fetchCategoryProduct('3'),
            expect: () => [
              LoadingCategoryProductState(),
              const ErrorCategoryProductState(
                'Failed to load category product',
              ),
            ],
            verify: (cubit) {
              verify(() => repository.getProductByCategory('3')).called(1);
            },
          );
        },
      );
    },
  );
}
