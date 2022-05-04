import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/child_categories/index.dart';
import 'package:storefront_app/features/home/index.dart';

void main() {
  const mockChildCategoryList = [
    ChildCategoryModel(
      id: '0',
      name: 'Daun',
      thumbnailUrl: 'https://pngimg.com/uploads/spinach/spinach_PNG65.png',
      parentCategoryId: '1',
    ),
    ChildCategoryModel(
      id: '1',
      name: 'Citrus',
      thumbnailUrl: 'https://pngimg.com/uploads/orange/orange_PNG803.png',
      parentCategoryId: '1',
    ),
  ];

  ChildCategoryCubit createCubit() {
    return ChildCategoryCubit(mockChildCategoryList);
  }

  group(
    '[ChildCategoryCubit] ',
    () {
      test(
        'initial state should be [ChildCategoryState] with first in index selected',
        () {
          final childCategoryCubit = createCubit();
          expect(
            childCategoryCubit.state,
            ChildCategoryState(mockChildCategoryList, mockChildCategoryList[0]),
          );
        },
      );

      blocTest<ChildCategoryCubit, ChildCategoryState>(
        'Change selected data into the active one',
        build: () => createCubit(),
        act: (cubit) => cubit.setActiveChildCategory(mockChildCategoryList[1]),
        expect: () => [
          ChildCategoryState(mockChildCategoryList, mockChildCategoryList[1]),
        ],
      );
    },
  );
}
