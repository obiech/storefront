import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/home/index.dart';

import '../mocks.dart';
import 'home_screen_finder.dart';

void main() {
  late ParentCategoriesCubit parentCategoriesCubit;
  late HttpClient httpClient;

  const mockparentCategoryList = [
    ParentCategoryModel(
      id: '0',
      name: 'Sayuran',
      thumbnailUrl:
          'https://freepngimg.com/thumb/broccoli/12-broccoli-png-image-with-transparent-background-thumb.png',
      color: 'FEE5E4',
      childCategories: [],
    ),
  ];

  const mockErrorMessage = 'Fake Error';

  setUp(() {
    parentCategoriesCubit = MockParentCategoriesCubit();
    httpClient = MockHttpClient();
  });

  Future<void> pumpHomePage(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<ParentCategoriesCubit>(
            create: (_) => parentCategoriesCubit,
            child: const HomePage(),
          ),
        ),
      ),
    );
  }

  group('Parent Categories Home Page', () {
    testWidgets(
        'display a loading indicator when state is [LoadingParentCategoriesState]',
        (tester) async {
      whenListen(
        parentCategoriesCubit,
        Stream.fromIterable([LoadingParentCategoriesState()]),
      );

      when(() => parentCategoriesCubit.close()).thenAnswer((_) async {});

      when(() => parentCategoriesCubit.state)
          .thenAnswer((invocation) => LoadingParentCategoriesState());

      await pumpHomePage(tester);

      expect(HomeScreenFinders.loadingParentCategoryWidget, findsOneWidget);
    });

    testWidgets(
        'display list of CategoriesOne when state is [LoadedParentCategoriesState]',
        (tester) async {
      HttpOverrides.runZoned(
        // Run your tests.
        () async {
          whenListen(
            parentCategoriesCubit,
            Stream.fromIterable(
              [const LoadedParentCategoriesState(mockparentCategoryList)],
            ),
          );

          when(() => parentCategoriesCubit.close()).thenAnswer((_) async {});

          when(() => parentCategoriesCubit.state).thenAnswer(
            (invocation) => const LoadedParentCategoriesState(
              mockparentCategoryList,
            ),
          );

          await pumpHomePage(tester);

          expect(HomeScreenFinders.gridParentCategoryWidget, findsOneWidget);
        },
        createHttpClient: (securityContext) => httpClient,
      );
    });

    testWidgets(
      'should display error message when state is [ErrorLoadingParentCategoriesState]',
      (tester) async {
        whenListen(
          parentCategoriesCubit,
          Stream.fromIterable(
            [const ErrorLoadingParentCategoriesState(mockErrorMessage)],
          ),
        );

        when(() => parentCategoriesCubit.close()).thenAnswer((_) async {});

        when(() => parentCategoriesCubit.state).thenAnswer(
          (_) => const ErrorLoadingParentCategoriesState(mockErrorMessage),
        );

        await pumpHomePage(tester);

        expect(HomeScreenFinders.errorParentCategoryWidget, findsOneWidget);
        expect(find.text(mockErrorMessage), findsOneWidget);
      },
    );
  });
}
