import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/child_categories/index.dart';
import 'package:storefront_app/features/home/index.dart';

import '../../../../test_commons/fixtures/product/product_models.dart'
    as fixtures;
import '../utils/mocks.dart';
import 'child_category_page_finder.dart';

void main() {
  late ChildCategoryCubit childCategoryCubit;
  late CategoryProductCubit categoryProductCubit;
  late HttpClient httpClient;

  const mockChildCategoryList = [
    ChildCategoryModel(
      id: '0',
      name: 'Daun',
      thumbnailUrl: 'https://pngimg.com/uploads/spinach/spinach_PNG65.png',
    ),
    ChildCategoryModel(
      id: '1',
      name: 'Bunga',
      thumbnailUrl:
          'https://pngimg.com/uploads/cauliflower/small/cauliflower_PNG12683.png',
    ),
  ];

  const mockParentCategoryList = ParentCategoryModel(
    id: '0',
    name: 'Sayuran',
    thumbnailUrl:
        'https://freepngimg.com/thumb/broccoli/12-broccoli-png-image-with-transparent-background-thumb.png',
    color: 'FEE5E4',
    childCategories: mockChildCategoryList,
  );

  setUp(() {
    childCategoryCubit = MockChildCategoryCubit();
    categoryProductCubit = MockCategoryProductCubit();
    httpClient = MockHttpClient();
  });

  Future<void> pumpChildCategoriesPage(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MultiBlocProvider(
            providers: [
              BlocProvider<ChildCategoryCubit>(
                create: (_) =>
                    ChildCategoryCubit(mockParentCategoryList.childCategories),
              ),
              BlocProvider(create: (_) => categoryProductCubit),
            ],
            child: const ChildCategoriesPage(
              parentCategoryModel: mockParentCategoryList,
            ),
          ),
        ),
      ),
    );
  }

  group('Child Categories Page', () {
    testWidgets(
        'display grid of List Categories '
        'and Product Category', (tester) async {
      HttpOverrides.runZoned(
        () async {
          whenListen(
            childCategoryCubit,
            Stream.fromIterable(
              [
                ChildCategoryState(
                  mockParentCategoryList.childCategories,
                  mockParentCategoryList.childCategories[0],
                )
              ],
            ),
          );
          whenListen(
            categoryProductCubit,
            Stream.fromIterable([
              LoadedCategoryProductState(
                fixtures.fakeCategoryProductList,
              ),
            ]),
          );

          when(() => childCategoryCubit.close()).thenAnswer((_) async {});

          when(() => categoryProductCubit.close()).thenAnswer((_) async {});

          when(() => childCategoryCubit.state).thenAnswer(
            (invocation) => ChildCategoryState(
              mockParentCategoryList.childCategories,
              mockParentCategoryList.childCategories[0],
            ),
          );

          when(() => categoryProductCubit.state).thenAnswer(
            (invocation) => LoadedCategoryProductState(
              fixtures.fakeCategoryProductList,
            ),
          );

          await pumpChildCategoriesPage(tester);

          expect(ChildCategoryFinders.listChildCategoryWidget, findsOneWidget);
          // TODO (Jonathan) : Add expect for CategoryProduct in STOR-398
        },
        createHttpClient: (securityContext) => httpClient,
      );
    });
  });
}
