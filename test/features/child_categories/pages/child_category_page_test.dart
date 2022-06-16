import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/child_categories/index.dart';
import 'package:storefront_app/features/discovery/index.dart';
import 'package:storefront_app/features/home/index.dart';

import '../../../../test_commons/fixtures/cart/cart_models.dart';
import '../../../../test_commons/fixtures/product/product_models.dart'
    as fixtures;
import '../../../commons.dart';
import '../../../src/mock_navigator.dart';
import '../utils/mocks.dart';
import 'child_category_page_finder.dart';

void main() {
  late ChildCategoryCubit childCategoryCubit;
  late CategoryProductCubit categoryProductCubit;
  late DiscoveryCubit discoveryCubit;
  late CartBloc cartBloc;
  late StackRouter stackRouter;

  const mockStoreId = 'store-id-1';

  const activeCategory = 0;

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
    childCategories: mockChildCategoryList,
  );

  setUp(() {
    childCategoryCubit = MockChildCategoryCubit();
    categoryProductCubit = MockCategoryProductCubit();
    cartBloc = MockCartBloc();

    discoveryCubit = MockDiscoveryCubit();
    whenListen(
      discoveryCubit,
      Stream.fromIterable([mockStoreId]),
    );

    // Navigation
    registerFallbackValue(FakePageRouteInfo());

    stackRouter = MockStackRouter();
    when(() => stackRouter.push(any())).thenAnswer((_) async => null);
  });

  setUpAll(() {
    setUpLocaleInjection();
  });

  Future<void> pumpChildCategoriesPage(WidgetTester tester) async {
    await tester.pumpWidget(
      StackRouterScope(
        controller: stackRouter,
        stateHash: 0,
        child: MaterialApp(
          home: Scaffold(
            body: MultiBlocProvider(
              providers: [
                BlocProvider<ChildCategoryCubit>(
                  create: (_) => ChildCategoryCubit(
                    mockParentCategoryList.childCategories,
                  ),
                ),
                BlocProvider(create: (_) => categoryProductCubit),
                BlocProvider(create: (_) => cartBloc),
                BlocProvider(create: (_) => discoveryCubit),
              ],
              child: const ChildCategoriesPage(
                parentCategoryModel: mockParentCategoryList,
              ),
            ),
          ),
        ),
      ),
    );
  }

  group('Child Categories Page', () {
    setUp(() {
      whenListen(
        childCategoryCubit,
        Stream.fromIterable(
          [
            ChildCategoryState(
              mockParentCategoryList.childCategories,
              mockParentCategoryList.childCategories[activeCategory],
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
          mockParentCategoryList.childCategories[activeCategory],
        ),
      );

      when(() => categoryProductCubit.state).thenAnswer(
        (invocation) => LoadedCategoryProductState(
          fixtures.fakeCategoryProductList,
        ),
      );

      when(() => cartBloc.state).thenAnswer(
        (_) => CartLoaded.success(mockCartModel),
      );
    });

    testWidgets(
        'should display grid of List Categories '
        'and Product Category', (tester) async {
      await pumpChildCategoriesPage(tester);

      expect(ChildCategoryFinders.listChildCategoryWidget, findsOneWidget);
      expect(
        ChildCategoryFinders.gridProductCategoryWidget,
        findsOneWidget,
      );
    });

    testWidgets('should display a floating cart summary', (tester) async {
      await pumpChildCategoriesPage(tester);

      expect(find.byType(CartSummary), findsOneWidget);
    });

    testWidgets(
        'should go to search page '
        'when search action is tapped', (WidgetTester tester) async {
      /// arrange
      await pumpChildCategoriesPage(tester);

      /// act
      final searchButtonFinder = find.ancestor(
        of: find.byIcon(DropezyIcons.search),
        matching: find.byType(IconButton),
      );
      expect(searchButtonFinder, findsOneWidget);
      await tester.tap(searchButtonFinder);

      /// assert
      final capturedRoutes =
          verify(() => stackRouter.push(captureAny())).captured;
      expect(capturedRoutes.length, 1);

      final routeInfo = capturedRoutes.first as PageRouteInfo;

      // expecting the right route being pushed
      expect(routeInfo, isA<GlobalSearchRoute>());
    });

    testWidgets(
        'should do nothing '
        'when active C2 category is tapped', (tester) async {
      await pumpChildCategoriesPage(tester);

      await tester.tap(find.byType(ListView).at(activeCategory));
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(ProductGridLoading), findsNothing);

      verifyNever(
        () => childCategoryCubit
            .setActiveChildCategory(mockChildCategoryList[activeCategory]),
      );

      verifyNever(
        () => categoryProductCubit.fetchCategoryProduct(
          activeCategory.toString(),
        ),
      );
    });

    testWidgets(
        'should show [ProductGridLoading] '
        'when state is [LoadingCategoryProductState]', (tester) async {
      when(() => categoryProductCubit.state).thenAnswer(
        (invocation) => LoadingCategoryProductState(),
      );

      await pumpChildCategoriesPage(tester);

      expect(find.byType(ProductGridLoading), findsWidgets);
    });

    testWidgets(
        'should show [DropezyError] '
        'when state is [ErrorCategoryProductState]', (tester) async {
      when(() => categoryProductCubit.state).thenAnswer(
        (invocation) => const ErrorCategoryProductState('Fake Error'),
      );

      await pumpChildCategoriesPage(tester);

      expect(find.byType(DropezyError), findsWidgets);
      expect(find.text('Fake Error'), findsOneWidget);
    });
  });
}
