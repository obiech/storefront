import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/errors/failure.dart';
import 'package:storefront_app/features/home/index.dart';

import '../../../mocks.dart';

void main() {
  late IParentCategoriesRepository parentCategoriesRepository;

  const mockParentCategoryModel = [
    ParentCategoryModel(
      id: '0',
      name: 'Sayuran',
      thumbnailUrl:
          'https://freepngimg.com/thumb/broccoli/12-broccoli-png-image-with-transparent-background-thumb.png',
      color: 'FEE5E4',
      childCategories: [],
    ),
    ParentCategoryModel(
      id: '1',
      name: 'Buah',
      thumbnailUrl:
          'https://freepngimg.com/thumb/apple/88-png-apple-image-clipart-transparent-png-apple-thumb.png',
      color: 'DFEEFF',
      childCategories: [],
    ),
  ];

  ParentCategoriesCubit createCubit() {
    return ParentCategoriesCubit(parentCategoriesRepository);
  }

  setUp(() {
    parentCategoriesRepository = MockIParentCategoriesRepository();
  });
  group(
    '[ParentCategoriesCubit]',
    () {
      test('Initial state should be [InitialParentCategoriesState]', () {
        final parentCategoriesCubit = createCubit();
        expect(parentCategoriesCubit.state, InitialParentCategoriesState());
      });
      group(
        '[fetchParentCategories()] emits [LoadingParentCategoriesState] followed by',
        () {
          blocTest<ParentCategoriesCubit, ParentCategoriesState>(
            '[LoadedParentCategoriesState] with result from '
            '[parentCategoriesRepository.getParentCategories()]',
            setUp: () {
              when(() => parentCategoriesRepository.getParentCategories())
                  .thenAnswer(
                (_) async => right(mockParentCategoryModel),
              );
            },
            build: () => createCubit(),
            act: (cubit) => cubit.fetchParentCategories(),
            expect: () => [
              LoadingParentCategoriesState(),
              const LoadedParentCategoriesState(mockParentCategoryModel),
            ],
            verify: (cubit) {
              verify(() => parentCategoriesRepository.getParentCategories())
                  .called(1);
            },
          );

          blocTest<ParentCategoriesCubit, ParentCategoriesState>(
            '[ErrorLoadingParentCategoriesState] if [parentCategoriesRepository.getParentCategories()] '
            'returns a failure',
            setUp: () {
              when(() => parentCategoriesRepository.getParentCategories())
                  .thenAnswer(
                (_) async => left(
                  Failure('Failed to load categories'),
                ),
              );
            },
            build: () => createCubit(),
            act: (cubit) => cubit.fetchParentCategories(),
            expect: () => [
              LoadingParentCategoriesState(),
              const ErrorLoadingParentCategoriesState(
                'Failed to load categories',
              ),
            ],
            verify: (cubit) {
              verify(() => parentCategoriesRepository.getParentCategories())
                  .called(1);
            },
          );
        },
      );
    },
  );
}
